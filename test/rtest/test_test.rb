require 'minitest/autorun'
require 'rtest/test'

module Rtest
  class MetaMeta < Minitest::Test
    def test_runnable_methods
      klass = Class.new(Test) {
        def test_foo; end
        def spec_foo; end
      }

      assert_equal Test::PREFIX, /^test_/
      assert_includes klass.runnable_methods, "test_foo"
    end

    def test_run_handles_assertions
      k = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end
      }.new

      result = k.run "test_even_eh"

      assert_equal 1, result.assertions
    end

    def test_run_handles_failures
      k = Class.new(Test) {
        def test_fail_even_eh
          assert 1.even?
        end
      }.new

      result  = k.run "test_fail_even_eh"

      exp_msg = "Failed assertion, no message given."
      failure = result.failures.pop

      assert_instance_of Rtest::Assertion, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_empty_tests
      k = Class.new(Test) {
        def test_empty
        end
      }.new

      result  = k.run "test_empty"

      exp_msg = "Empty test, 'test_empty'"
      failure = result.failures.pop

      assert_instance_of Rtest::EmptyTest, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_skipped_tests
      k = Class.new(Test) {
        def test_super_complex_implementation
          skip
        end
      }.new

      result  = k.run "test_super_complex_implementation"

      exp_msg = "Skipped 'test_super_complex_implementation'"
      failure = result.failures.pop

      assert_instance_of Rtest::Skip, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_skipped_tests_can_have_customized_messages
      k = Class.new(Test) {
        def test_super_complex_implementation
          skip "implement me when IQ > 80"
        end
      }.new

      result  = k.run "test_super_complex_implementation"

      exp_msg = "implement me when IQ > 80"
      failure = result.failures.pop

      assert_equal exp_msg, failure.message
    end

    def test_run_passes_through_errors
      k = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end
      }.new

      assert_raises NoMethodError do
        k.run "test_odd_eh"
      end
    end

    def test_run_runs_all_tests
      k = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end

        def test_includes_eh
          assert [1, 2].include?(2)
        end
      }.new

      result = k.run

      assert_equal 2, result.assertions
    end

    def test_run_times_each_run
      k = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end
      }.new

      result = k.run "test_even_eh"

      assert_instance_of Float, result.time
    end
  end
end
