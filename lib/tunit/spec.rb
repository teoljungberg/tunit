require 'tunit/spec/dsl'
require 'tunit/spec/expect'

module Tunit
  class Spec < Test
    extend DSL
    include Expect::Expectations

    PREFIX = /^spec_/

    def self.runnable_methods
      spec_methods = methods_matching PREFIX
      set_test_order spec_methods
    end
  end
end
