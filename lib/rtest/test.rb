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
  end
end
