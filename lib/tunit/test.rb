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

    def skip message = nil
      method_in_backtrace_regexp = /`.*'/
      method_responsible = caller[0][method_in_backtrace_regexp][1..-2]
      message ||= "Skipped '#{method_responsible}'"

      fail Skip, message
    end

    def passed?
      !failure
    end

    def skipped?
      Skip === failure
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
      e.location = location_of_skipped_test

      self.failures << e
    rescue FailedAssertion => e
      self.failures << e
    rescue Exception => e
      self.failures << UnexpectedError.new(e)
    end

    def self.set_test_order test_methods
      case order
      when :random
        test_methods.shuffle
      when :alpha
        test_methods.sort
      else
        fail "Unknown order: #{order.inspect}"
      end
    end

    def location_of_skipped_test
      method(name).source_location.join(":")
    end
  end
end
