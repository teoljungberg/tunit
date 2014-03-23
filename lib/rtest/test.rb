require 'rtest/runnable'
require 'rtest/assertions'

module Rtest
  class Test < Runnable
    include Assertions
    PREFIX = /^test_/

    def self.runnable_methods
      methods_matching PREFIX
    end

    def self.run_all
      runnable_methods.map { |test|
        new(test).run
      }
    end

    def run
      capture_exceptions do
        time_it do
          send name
          if self.assertions.zero?
            raise ::Rtest::Empty, "Empty test, '#{name}'"
          end
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
    rescue Empty, Skip => e
      self.failures << e
    end
  end
end
