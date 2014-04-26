require_relative '../test_case'
require 'tunit/spec'

module Tunit
  class SpecExpectTest < TestCase
    def test_expect_wraps_up_a_expect_object
      tc = self

      Class.new(Spec) {
        tc.assert_instance_of Spec::Expect, expect(2)
      }
    end
  end
end
