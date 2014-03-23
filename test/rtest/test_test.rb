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

      k.run "test_even_eh"
      assert_equal 1, k.assertions
    end

    def test_run_handles_failures
      k = Class.new(Test) {
        def test_fail_even_eh
          assert 1.even?
        end
      }.new

      k.run "test_fail_even_eh"

      exp_error = Rtest::Assertion
      exp_msg   = "Failed assertion, no message given."
      failure   = k.failures.pop

      assert exp_error === failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_empty_tests
      k = Class.new(Test) {
        def test_empty
        end
      }.new

      k.run "test_empty"

      exp_error = Rtest::EmptyTest
      exp_msg   = "Empty test, 'test_empty'"
      failure   = k.failures.pop

      assert exp_error === failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_skipped_tests
      k = Class.new(Test) {
        def test_super_complex_implementation
          skip
        end
      }.new

      k.run "test_super_complex_implementation"

      exp_error = Rtest::Skip
      exp_msg   = "Skipped 'test_super_complex_implementation'"
      failure   = k.failures.pop

      assert exp_error === failure
      assert_equal exp_msg, failure.message
    end

    def test_run_skipped_tests_can_have_customized_messages
      k = Class.new(Test) {
        def test_super_complex_implementation
          skip "implement me when IQ > 80"
        end
      }.new

      k.run "test_super_complex_implementation"

      exp_msg = "implement me when IQ > 80"
      failure = k.failures.pop

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

      k.run
      assert_equal 2, k.assertions
    end

    def test_run_times_each_run
      k = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end
      }.new

      k.run "test_even_eh"
      test_time = Time.new k.time
      assert_instance_of Time, test_time
    end
  end
end
