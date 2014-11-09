require 'tunit/runnable'
require 'tunit/assertions'
require 'tunit/hooks'

module Tunit
  class Test < Runnable
    include Assertions
    include Hooks

    PREFIX = /^test_/

    def self.runnable_methods
      test_methods = methods_matching PREFIX
      set_test_order test_methods
    end

    # Randomize tests by default
    def self.test_order
      :random
    end

    def self.order!
      class << self
        undef_method :test_order if method_defined?(:test_order)
        define_method(:test_order) { :alpha }
      end
    end

    def run
      capture_exceptions do
        time_it do
          SETUP_HOOKS.each {|hook| send hook }
          send name
        end

        skip "Empty test, <#{self}>" if assertions.zero?
      end

      TEARDOWN_HOOKS.each do |hook|
        capture_exceptions do
          send hook
        end
      end
      self
    end

    def passed?
      !failure
    end

    def skipped?
      failure && Skip === failure
    end

    def failure
      self.failures.first
    end

    def code
      failure && failure.result_code || "."
    end

    def location
      loc = " [#{failure.location}]" unless passed?
      "#{self.class}##{name}#{loc}"
    end

    def to_s
      return location if passed? && !skipped?

      failures.map { |failure|
        "#{failure.result_label}:\n#{location}:\n#{failure.message}\n"
      }.join "\n"
    end

    private

    def time_it
      t0 = Time.now
      yield
    ensure
      self.time = Time.now - t0
    end

    def capture_exceptions
      yield
    rescue Skip => e
      location = method(name).source_location.join(":")

      redefine_method e.class, :location do
        -> { location }
      end

      self.failures << e
    rescue FailedAssertion => e
      self.failures << e
    rescue Exception => e
      self.failures << UnexpectedError.new(e)
    end

    def self.set_test_order test_methods
      case test_order
      when :random
        max = test_methods.size
        test_methods.sort.sort_by { rand max }
      when :alpha
        test_methods.sort
      else
        fail "Unknown test_order: #{test_order.inspect}"
      end
    end

    def redefine_method klass, method
      return unless block_given?

      klass.send :alias_method, "old_#{method}", method
      klass.send :define_method, method, yield
    ensure
      klass.send :remove_method, "old_#{method}"
    end
  end
end
