require_relative 'test_case'
require 'tunit/assertion_errors'
require 'tunit/test'

module Tunit
  class AssertionErrorTest < TestCase
    def setup
      self.assertion = Assertion.new
    end
    attr_accessor :assertion

    def test_error
      assert_instance_of Assertion, assertion.error
    end

    def test_location
      result       = FailingTest.new.run
      assertion    = result.failure
      exp_location = %r(test/tunit/test_case.rb:\d{1,})

      assert_match exp_location, assertion.location
    end

    def test_result_code
      assert_equal "F", assertion.result_code
    end

    def test_result_label
      assert_equal "Failure", assertion.result_label
    end
  end

  class SkipErrorTest < TestCase
    def setup
      self.assertion = Skip.new
    end
    attr_accessor :assertion

    def test_error
      assert_instance_of Skip, assertion.error
    end

    def test_location
      result       = SkippedTest.new.run
      assertion    = result.failure
      exp_location = %r(test/tunit/test_case.rb:\d{1,})

      assert_match exp_location, assertion.location
    end

    def test_result_code
      assert_equal "S", assertion.result_code
    end

    def test_result_label
      assert_equal "Skipped", assertion.result_label
    end
  end

  class ErrorErrorTest < TestCase
    def setup
      self.assertion = Error.new
    end
    attr_accessor :assertion

    def test_error
      assert_instance_of Error, assertion.error
    end

    def test_location
      result       = ErrorTest.new.run
      assertion    = result.failure
      exp_location = %r(test/tunit/test_case.rb:\d{1,})

      assert_instance_of NotAnAssertion, result.failure
      assert_match exp_location, assertion.location
    end

    def test_result_code
      assert_equal "E", assertion.result_code
    end

    def test_result_label
      assert_equal "Error", assertion.result_label
    end
  end
end
