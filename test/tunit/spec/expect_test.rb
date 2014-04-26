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

    def test_to_shows_value_to_the_world
      assert_equal 2, expect.to
    end

    def test_not_to_inverts_the_value_of_to
      assert_equal false, expect.not_to
    end
  end
end
