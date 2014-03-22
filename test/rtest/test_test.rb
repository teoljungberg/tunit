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

      assert exp_error === k.failures.first
      assert_equal exp_msg, k.failures.first.message
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
  end
end
