require 'tunit/runnable'
require 'tunit/assertions'
require 'tunit/hooks'

module Tunit
  class Test < Runnable
    include Assertions
    include Hooks

    PREFIX = /^test_/

    def self.runnable_methods
      methods = methods_matching(PREFIX)
      case test_order
      when :random
        max = methods.size
        methods.sort.sort_by { rand max }
      when :alpha
        methods.sort
      else
        fail "Unknown test_order: #{test_order.inspect}"
      end
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
          before_setup; setup; after_setup
          send name
        end

        skip "Empty test, <#{self}>" if assertions.zero?
      end

      %w(before_teardown teardown after_teardown).each do |hook|
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
    rescue Assertion => e
      self.failures << e
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
