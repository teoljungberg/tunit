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
      result = PassingTest.new.run

      assert result.passed?
      assert_equal 1, result.assertions
    end

    def test_run_handles_failures
      result  = FailingTest.new.run

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
      result  = SkippedTest.new.run

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
        PassingTest.new(:non_existing_method).run
      end
    end

    def test_run_times_each_run
      result = PassingTest.new.run

      assert_instance_of Float, result.time
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

      assert_instance_of ::Rtest::Assertion, result.failure
    end

    def test_skipped_eh
      result = SkippedTest.new.run

      assert_instance_of ::Rtest::Skip, result.failure
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

      assert_equal "_", result.code
    end

    def test_location_of_a_failing_test
      result       = FailingTest.new(:test_fail).run
      exp_location = %r(Rtest::TestCase::FailingTest#test_fail \[.*/rtest/test/rtest/test_case.rb:\d{1,}\])

      assert_match exp_location, result.location
    end

    def test_to_s_returns_the_klass_and_test
      result = PassingTest.new(:test_pass).run
      exp_klass_and_test = "Rtest::TestCase::PassingTest#test_pass"

      assert_equal exp_klass_and_test, result.to_s
      assert_equal result.to_s, result.location
    end

    def test_to_s_returns_the_failing_test
      result    = FailingTest.new(:test_fail).run
      exp_error = <<-EOS
Failure:
Rtest::TestCase::FailingTest#test_fail [test/rtest/test_case.rb:26]:
Failed assertion, no message given.
EOS

      assert_equal exp_error, truncate_absolut_path(result.to_s)
    end
  end
end
