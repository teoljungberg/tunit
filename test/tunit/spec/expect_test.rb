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

  class ExpectTest < TestCase
    def setup
      self.expect = Spec::Expect.new 2
    end
    attr_accessor :expect

    def test_initialize_sets_the_value_as_a_proc
      assert_instance_of Proc, expect.value
    end

    def test_eq_asserts_equality
      tc = self

      Class.new(Spec) {
        tc.assert expect(2).to(eq(2))
      }
    end

    def test_not_eq_refutes_equality
      tc = self

      Class.new(Spec) {
        tc.refute expect(2).to(not_eq(4))
      }
    end
  end
end
