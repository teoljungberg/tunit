require_relative 'test_case'
require 'tunit/test'

module Tunit
  class AssertionsTest < TestCase
    def setup
      self.tc = Class.new(Test).new "custom_test"
      self.assertion_count = 0
    end
    attr_accessor :tc, :assertion_count

    def teardown
      super
      assert_equal assertion_count, tc.assertions,
        "Expected #{assertion_count} assertions to have been made to #{tc}, but was #{tc.assertions}"
    end

    def test_assert
      self.assertion_count = 1

      tc.assert "truthy"
    end

    def test_refute
      self.assertion_count = 1

      tc.refute false
    end

    def test_assert_equal
      self.assertion_count = 1

      tc.assert_equal 1, 1
    end

    def test_refute_equal
      self.assertion_count = 1

      tc.refute_equal 1, 2
    end

    def test_assert_includes
      self.assertion_count = 2

      tc.assert_includes [2], 2
    end

    def test_refute_includes
      self.assertion_count = 2

      tc.refute_includes [1], 2
    end

    def test_assert_respond_to
      self.assertion_count = 1

      tc.assert_respond_to tc, :assert
    end

    def test_refute_respond_to
      self.assertion_count = 1

      tc.refute_respond_to tc, :omg
    end

    def test_assert_instance_of
      self.assertion_count = 1

      tc.assert_instance_of String, "omg"
    end

    def test_refute_instance_of
      self.assertion_count = 1

      tc.refute_instance_of String, 1
    end

    def test_assert_match
      self.assertion_count = 2

      tc.assert_match(/oo/, "foo")
    end

    def test_refute_match
      self.assertion_count = 2

      tc.refute_match(/foo/, "bar")
    end

    def test_assert_raises
      self.assertion_count = 1

      tc.assert_raises NoMethodError do
        tc.unexisting_method
      end
    end

    def test_assert_raises_returns_the_message
      self.assertion_count = 1

      e = tc.assert_raises NoMethodError do
        tc.unexisting_method
      end

      exp_msg = /undefined method `unexisting_method'/

      assert_match exp_msg, e.message
    end
  end
end
