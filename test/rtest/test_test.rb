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

    def test_run_all_runs_all_tests_in_a_new_scope
      klass = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end

        def test_includes_eh
          assert [1, 2].include?(2)
        end
      }

      result     = klass.run_all
      assertions = result.map(&:assertions).inject(:+)

      assert_equal 2, assertions
    end


    def test_run_handles_assertions
      klass = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end
      }

      result = klass.new("test_even_eh").run

      assert result.passed?
      assert_equal 1, result.assertions
    end

    def test_run_handles_failures
      klass = Class.new(Test) {
        def test_fail_even_eh
          assert 1.even?
        end
      }

      result  = klass.new("test_fail_even_eh").run

      exp_msg = "Failed assertion, no message given."
      failure = result.failures.first

      assert_instance_of Rtest::Assertion, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_empty_tests
      klass = Class.new(Test) {
        def test_empty
        end
      }

      result  = klass.new("test_empty").run

      exp_msg = "Empty test, 'test_empty'"
      failure = result.failures.first

      assert_instance_of Rtest::EmptyTest, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_handles_skipped_tests
      klass = Class.new(Test) {
        def test_super_complex_implementation
          skip
        end
      }

      result  = klass.new("test_super_complex_implementation").run

      exp_msg = "Skipped 'test_super_complex_implementation'"
      failure = result.failures.first

      assert result.skipped?
      assert_instance_of Rtest::Skip, failure
      assert_equal exp_msg, failure.message
    end

    def test_run_skipped_tests_can_have_customized_messages
      klass = Class.new(Test) {
        def test_super_complex_implementation
          skip "implement me when IQ > 80"
        end
      }

      result  = klass.new("test_super_complex_implementation").run

      exp_msg = "implement me when IQ > 80"
      failure = result.failures.first

      assert_equal exp_msg, failure.message
    end

    def test_run_passes_through_errors
      klass = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end
      }

      assert_raises NoMethodError do
        klass.new("test_odd_eh").run
      end
    end

    def test_run_times_each_run
      klass = Class.new(Test) {
        def test_even_eh
          assert 2.even?
        end
      }

      result = klass.new("test_even_eh").run

      assert_instance_of Float, result.time
    end
  end
end
