require_relative './test_case'

module Rtest
  class TestTest < TestCase
    def test_runnable_methods
      assert_equal Test::PREFIX, /^test_/
      assert_includes PassingTest.runnable_methods, "test_pass"
    end

    def test_run_all_runs_all_tests_in_a_new_scope
      result     = PassingTest.run_all
      assertions = result.map(&:assertions).inject(:+)

      assert_equal 2, assertions
    end


    def test_run_handles_assertions
      result = PassingTest.new(:test_pass).run

      assert result.passed?
      assert_equal 1, result.assertions
    end

    def test_run_handles_failures
      result  = FailingTest.new(:test_fail).run

      exp_msg = "Failed assertion, no message given."
      failure = result.failures.first

      assert_instance_of Rtest::Assertion, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_empty_tests
      result  = FailingTest.new(:test_empty).run

      exp_msg = "Empty test, 'test_empty'"
      failure = result.failures.first

      assert_instance_of Rtest::Empty, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_skipped_tests
      result  = SkippedTest.new(:test_skip).run

      exp_msg = "Skipped 'test_skip'"
      failure = result.failures.first

      assert result.skipped?
      assert_instance_of Rtest::Skip, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_skipped_tests_can_have_customized_messages
      result  = SkippedTest.new(:test_skip_with_msg).run

      exp_msg = "implement me when IQ > 80"
      failure = result.failures.first

      assert_equal exp_msg, failure.message
    end

    def test_run_passes_through_errors
      assert_raises NoMethodError do
        PassingTest.new(:test_odd_eh).run
      end
    end

    def test_run_times_each_run
      result = PassingTest.new(:test_pass).run

      assert_instance_of Float, result.time
    end

    def test_passed_eh
      result = PassingTest.new(:test_pass).run
      assert result.passed?
    end

    def test_passed_eh_is_only_true_if_not_a_failure
      result = FailingTest.new(:test_fail).run
      refute result.passed?
    end

    def test_failure
      result = FailingTest.new(:test_fail).run

      assert_instance_of ::Rtest::Assertion, result.failure
    end

    def test_skipped_eh
      result = SkippedTest.new(:test_skip).run

      assert_instance_of ::Rtest::Skip, result.failure
      assert result.skipped?
    end

    def test_code_for_success
      result = PassingTest.new(:test_pass).run

      assert_equal ".", result.code
    end

    def test_code_for_failure
      result = FailingTest.new(:test_fail).run

      assert_equal "F", result.code
    end

    def test_code_for_skipped
      result = SkippedTest.new(:test_skip).run

      assert_equal "S", result.code
    end

    def test_code_for_empty_test
      result = FailingTest.new(:test_empty).run

      assert_equal "_", result.code
    end
  end
end
