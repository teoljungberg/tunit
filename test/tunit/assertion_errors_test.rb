require_relative '../test_helper'
require 'tunit/assertion_errors'
require 'tunit/test'

module Tunit
  class AssertionErrorTest < TestCase
    def setup
      @assertion_error = Assertion.new
    end
    attr_reader :assertion_error

    def test_error
      assert_instance_of Assertion, assertion_error.error
    end

    def test_location
      result          = FailingTest.new.run
      assertion_error = result.failure
      exp_location    = %r(test/test_helper.rb:\d{1,})

      assert_match exp_location, assertion_error.location
    end

    def test_result_code
      assert_equal "F", assertion_error.result_code
    end

    def test_result_label
      assert_equal "Failure", assertion_error.result_label
    end
  end

  class SkipErrorTest < TestCase
    def setup
      @assertion_error = Skip.new
    end
    attr_reader :assertion_error

    def test_error
      assert_instance_of Skip, assertion_error.error
    end

    def test_location
      result          = SkippedTest.new.run
      assertion_error = result.failure
      exp_location    = %r(test/test_helper.rb:\d{1,})

      assert_match exp_location, assertion_error.location
    end

    def test_result_code
      assert_equal "S", assertion_error.result_code
    end

    def test_result_label
      assert_equal "Skipped", assertion_error.result_label
    end
  end

  class ErrorErrorTest < TestCase
    def setup
      @assertion_error = Error.new
    end
    attr_reader :assertion_error

    def test_error
      assert_instance_of Error, assertion_error.error
    end

    def test_location
      result          = ErrorTest.new.run
      assertion_error = result.failure
      exp_location    = %r(test/test_helper.rb:\d{1,})

      assert_instance_of NotAnAssertion, result.failure
      assert_match exp_location, assertion_error.location
    end

    def test_result_code
      assert_equal "E", assertion_error.result_code
    end

    def test_result_label
      assert_equal "Error", assertion_error.result_label
    end
  end

  class UnexpectedErrorTest < TestCase
    def raised_error
      raise "hell"
    rescue => e
      e
    end

    def setup
      @assertion_error = UnexpectedError.new raised_error
    end
    attr_reader :assertion_error

    def test_exception
      assert_instance_of RuntimeError, assertion_error.exception
    end

    def test_error
      assert_instance_of UnexpectedError, assertion_error.error
    end

    def test_location
      result          = ErrorTest.new(:test_exception).run
      assertion_error = result.failure
      exp_location    = %r(test/test_helper.rb:\d{1,})

      assert_instance_of UnexpectedError, result.failure
      assert_match exp_location, assertion_error.location
    end

    def test_result_code
      assert_equal "E", assertion_error.result_code
    end

    def test_result_label
      assert_equal "Error", assertion_error.result_label
    end
  end
end
