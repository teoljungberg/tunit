require 'rtest/runnable'
require 'rtest/assertions'

module Rtest
  class Test < Runnable
    PREFIX = /^test_/

    include Assertions

    def self.runnable_methods
      methods_matching PREFIX
    end

    def initialize
      self.assertions = 0
      self.failures   = []
    end
    attr_accessor :assertions, :failures

    def run test
      run_single_method test
    end

    private

    def run_single_method test
      capture_exceptions do
        send test
      end
    end

    def capture_exceptions
      yield
    rescue Assertion => e
      self.failures << e
    end
  end
end
