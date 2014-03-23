require 'rtest/runnable'
require 'rtest/assertions'

module Rtest
  class Test < Runnable
    include Assertions
    PREFIX = /^test_/

    def self.runnable_methods
      methods_matching PREFIX
    end

    def run
      if name
        run_single_method name
      else
        self.class.runnable_methods.each { |test|
          run_single_method test
        }
      end
      self
    end

    private

    def run_single_method test
      capture_exceptions do
        time_it do
          send test
          if self.assertions.zero?
            raise ::Rtest::EmptyTest, "Empty test, '#{test}'"
          end
        end
      end
    end

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
    rescue EmptyTest => e
      self.failures << e
    end
  end
end
