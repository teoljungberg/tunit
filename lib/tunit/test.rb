require 'tunit/runnable'
require 'tunit/assertions'
require 'tunit/hooks'

module Tunit
  class Test < Runnable
    include Assertions
    include Hooks
    PREFIX = /^test_/

    def self.runnable_methods
      methods = methods_matching PREFIX
      case self.test_order
      when :random
        max = methods.size
        methods.sort.sort_by { rand max }
      when :alpha
        methods.sort
      else
        raise "Unknown test_order: #{self.test_order.inspect}"
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
          setup
          send name
        end

        if self.assertions.zero?
          e = ::Tunit::Empty.new "Empty test, <#{self.to_s}>"
          method_obj = self.method(name)

          redefine_method e.class, :location do
            -> { method_obj.source_location.join(":") }
          end

          fail e
        end
      end

      capture_exceptions do
        teardown
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
      loc = " [#{self.failure.location}]" unless passed?
      "#{self.class}##{self.name}#{loc}"
    end

    def to_s
      return location if passed? && !skipped?

      failures.map { |failure|
        "#{failure.result_label}:\n#{self.location}:\n#{failure.message}\n"
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
    rescue Assertion => e
      self.failures << e
    end

    def redefine_method klass, method
      return unless block_given?

      klass.send :alias_method, "old_#{method}", method
      klass.send :define_method, method, yield
    end
  end
end
