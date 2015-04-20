require_relative '../test_helper'

module Tunit
  class TestTest < TestCase
    def test_PREFIX
      expected_prefix = /^test_/

      assert_equal expected_prefix, Test::PREFIX
    end

    def test_TEARDOWN_HOOKS
      assert_equal %w(before_teardown teardown after_teardown),
        Test::TEARDOWN_HOOKS
    end

    def test_SETUP_HOOKS
      assert_equal %w(before_setup setup after_setup),
        Test::SETUP_HOOKS
    end

    def test_runnable_methods
      assert_includes PassingTest.runnable_methods, "test_pass"
    end

    def test_run_handles_assertions
      result = PassingTest.new.run

      assert_predicate result, :passed?
      assert_equal 1, result.assertions
    end

    def test_run_handles_failures
      result = FailingTest.new.run

      expected_message = "Failed assertion, no message given."
      failure = result.failure

      assert_instance_of Tunit::FailedAssertion, failure
      assert_equal expected_message, failure.message
    end

    def test_run_handles_empty_tests_as_skips
      result  = FailingTest.new(:test_empty).run

      expected_message = "Empty test, <Tunit::FailingTest#test_empty>"
      failure = result.failure

      assert_instance_of Tunit::Skip, failure
      assert_equal expected_message, failure.message
    end

    def test_run_handles_skipped_tests
      result = SkippedTest.new.run

      expected_message = "Skipped 'test_skip'"
      failure = result.failure

      assert_predicate result, :skipped?
      assert_instance_of Tunit::Skip, failure
      assert_equal expected_message, failure.message
    end

    def test_run_skipped_tests_can_have_customized_messages
      result = SkippedTest.new(:test_skip_with_message).run

      expected_message = "implement me when IQ > 80"
      failure = result.failure

      assert_equal expected_message, failure.message
    end

    def test_run_saves_exceptions_as_failures
      result = PassingTest.new(:non_existing_method).run

      assert_kind_of UnexpectedError, result.failure
      assert_kind_of NoMethodError, result.failure.exception
    end

    def test_run_times_each_run
      result = PassingTest.new.run

      assert_instance_of Float, result.time
    end

    def test_run_execs_setup_before_each_run
      expected_calls = []

      tc = Class.new PassingTest do
        define_method :setup do
          expected_calls << :setup
        end
      end

      tc.new.run

      assert_equal [:setup], expected_calls
    end

    def test_run_execs_before_and_after_setup
      setup_order = []

      tc = Class.new PassingTest do
        define_method :setup do
          setup_order << :setup
        end

        define_method :before_setup do
          setup_order << :before_setup
        end

        define_method :after_setup do
          setup_order << :after_setup
        end
      end

      tc.new(:test_pass).run
      expected_order = [:before_setup, :setup, :after_setup]

      assert_equal expected_order, setup_order
    end

    def test_run_execs_teardown_after_each_run
      expected_calls = []

      tc = Class.new PassingTest do
        define_method :teardown do
          expected_calls << :teardown
        end
      end

      tc.new.run

      assert_equal [:teardown], expected_calls
    end

    def test_run_execs_before_and_after_teardown
      teardown_order = []

      tc = Class.new PassingTest do
        define_method :teardown do
          teardown_order << :teardown
        end

        define_method :before_teardown do
          teardown_order << :before_teardown
        end

        define_method :after_teardown do
          teardown_order << :after_teardown
        end
      end

      tc.new(:test_pass).run
      expected_order = [:before_teardown, :teardown, :after_teardown]

      assert_equal expected_order, teardown_order
    end

    def test_run_captures_any_errors_and_skips_the_hook_that_raised_the_error
      teardown_order = []

      tc = Class.new PassingTest do
        define_method :teardown do
          teardown_order << :teardown
        end

        define_method :before_teardown do
          raise "hell"
        end

        define_method :after_teardown do
          teardown_order << :after_teardown
        end
      end

      tc.new(:test_pass).run
      expected_order = [:teardown, :after_teardown]

      assert_equal expected_order, teardown_order
    end

    def test_skip
      skipped_test = Class.new Tunit::Test do
        def test_skip
          skip
        end
      end

      result = skipped_test.new(:test_skip).run

      assert Skip === result.failure
    end

    def test_skip_message
      skipped_test = Class.new Tunit::Test do
        def test_skip
          skip "my message"
        end
      end

      result = skipped_test.new(:test_skip).run

      assert_equal "my message", result.failure.message
    end

    def test_passed_eh
      result = PassingTest.new.run
      assert_predicate result, :passed?
    end

    def test_passed_eh_is_only_true_if_not_a_failure
      result = FailingTest.new.run
      refute result.passed?
    end

    def test_failure
      result = FailingTest.new.run

      assert_instance_of ::Tunit::FailedAssertion, result.failure
    end

    def test_skipped_eh
      result = SkippedTest.new.run

      assert_instance_of ::Tunit::Skip, result.failure
      assert_predicate result, :skipped?
    end

    def test_code_for_success
      result = PassingTest.new.run

      assert_equal ".", result.code
    end

    def test_code_for_failure
      result = FailingTest.new.run

      assert_equal "F", result.code
    end

    def test_code_for_skipped
      result = SkippedTest.new.run

      assert_equal "S", result.code
    end

    def test_code_for_empty_test
      result = FailingTest.new(:test_empty).run

      assert_equal "S", result.code
    end

    def test_location_of_a_failing_test
      result = FailingTest.new(:test_fail).run
      expected_location = %r(Tunit::FailingTest#test_fail \[test/support/sample/tests.rb:\d{1,}\])

      assert_match expected_location, result.location
    end

    def test_to_s_returns_the_klass_and_test
      result = PassingTest.new(:test_pass).run
      expected_klass_and_test = "Tunit::PassingTest#test_pass"

      assert_equal expected_klass_and_test, result.to_s
      assert_equal result.to_s, result.location
    end

    def test_to_s_returns_the_failing_test
      result = FailingTest.new(:test_fail).run
      expected_match = %r(Tunit::FailingTest#test_fail \[test/support/sample/tests.rb:\d{1,}\])

      assert_match expected_match, result.to_s
    end
  end
end
