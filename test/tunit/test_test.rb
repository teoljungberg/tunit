require_relative '../test_helper'

module Tunit
  class TestTest < TestCase
    def test_PREFIX
      exp_prefix = /^test_/

      assert_equal exp_prefix, Test::PREFIX
    end

    def test_TEARDOWN_HOOKS
      assert_equal %w(before_teardown teardown after_teardown),
        Test::TEARDOWN_HOOKS
    end

    def test_runnable_methods
      assert_includes PassingTest.runnable_methods, "test_pass"
    end

    def test_runnable_methods_shuffles_the_tests
      assert_equal :random, PassingTest.test_order
    end

    def test_order_bang_orders_your_tests
      sucky_test = Class.new(PassingTest) {
        order!
      }

      assert_equal :alpha, sucky_test.test_order
    end

    def test_run_handles_assertions
      result = PassingTest.new.run

      assert result.passed?
      assert_equal 1, result.assertions
    end

    def test_run_handles_failures
      result  = FailingTest.new.run

      exp_msg = "Failed assertion, no message given."
      failure = result.failure

      assert_instance_of Tunit::Assertion, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_empty_tests_as_skips
      result  = FailingTest.new(:test_empty).run

      exp_msg = "Empty test, <Tunit::FailingTest#test_empty>"
      failure = result.failure

      assert_instance_of Tunit::Skip, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_skipped_tests
      result  = SkippedTest.new.run

      exp_msg = "Skipped 'test_skip'"
      failure = result.failure

      assert result.skipped?
      assert_instance_of Tunit::Skip, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_skipped_tests_can_have_customized_messages
      result  = SkippedTest.new(:test_skip_with_msg).run

      exp_msg = "implement me when IQ > 80"
      failure = result.failure

      assert_equal exp_msg, failure.message
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
      exp_calls = []

      tc = Class.new PassingTest do
        define_method :setup do
          exp_calls << :setup
        end
      end

      tc.new.run

      assert_equal [:setup], exp_calls
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
      exp_order = [:before_setup, :setup, :after_setup]

      assert_equal exp_order, setup_order
    end

    def test_run_execs_teardown_after_each_run
      exp_calls = []

      tc = Class.new PassingTest do
        define_method :teardown do
          exp_calls << :teardown
        end
      end

      tc.new.run

      assert_equal [:teardown], exp_calls
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
      exp_order = [:before_teardown, :teardown, :after_teardown]

      assert_equal exp_order, teardown_order
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
      exp_order = [:teardown, :after_teardown]

      assert_equal exp_order, teardown_order
    end

    def test_passed_eh
      result = PassingTest.new.run
      assert result.passed?
    end

    def test_passed_eh_is_only_true_if_not_a_failure
      result = FailingTest.new.run
      refute result.passed?
    end

    def test_failure
      result = FailingTest.new.run

      assert_instance_of ::Tunit::Assertion, result.failure
    end

    def test_skipped_eh
      result = SkippedTest.new.run

      assert_instance_of ::Tunit::Skip, result.failure
      assert result.skipped?
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
      result       = FailingTest.new(:test_fail).run
      exp_location = %r(Tunit::FailingTest#test_fail \[test/sample/tests.rb:\d{1,}\])

      assert_match exp_location, truncate_absolute_path(result.location)
    end

    def test_to_s_returns_the_klass_and_test
      result = PassingTest.new(:test_pass).run
      exp_klass_and_test = "Tunit::PassingTest#test_pass"

      assert_equal exp_klass_and_test, result.to_s
      assert_equal result.to_s, result.location
    end

    def test_to_s_returns_the_failing_test
      result    = FailingTest.new(:test_fail).run
      exp_match = %r(Tunit::FailingTest#test_fail \[test/sample/tests.rb:\d{1,}\])

      assert_match exp_match, truncate_absolute_path(result.to_s)
    end
  end
end
