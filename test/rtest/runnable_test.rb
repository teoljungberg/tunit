require_relative 'test_case'
require 'rtest/runnable'

module Rtest
  class RunnableTest < TestCase
    def test_runnable_methods_is_a_subclass_responsibility
      e = assert_raises NotImplementedError do
        Runnable.runnable_methods
      end

      exp = "subclass responsibility"
      assert_equal exp, e.message
    end

    def test_runnables_list_all_runnables_that_inherit_from_runnable
      assert_includes Runnable.runnables, PassingTest
    end

    def test_runnables_can_be_overridden
      prev_runnables = Runnable.runnables

      Runnable.runnables = "omg"
      assert_includes Runnable.runnables, "omg"

      # reset Runnable.runnables to avoid mishaps, teardown didn't pull through
    ensure
      Runnable.runnables = prev_runnables
    end

    def test_run_runs_all_tests_with_a_given_reporter
      PassingTest.run dummy_reporter, io: io

      assert_equal dummy_reporter.report, PassingTest.runnable_methods.size
    end

    def test_run_runs_all_tests_with_matching_pattern
      filter          = "test_pass_one_more"
      matched_methods = PassingTest.runnable_methods.grep(/#{filter}/).size

      PassingTest.run dummy_reporter, io: io, filter: filter

      assert_equal dummy_reporter.report, matched_methods
    end

    def test_runnable_methods_can_be_customized_to_find_your_tests
      super_klass = Class.new(Runnable) {
        def self.runnable_methods
          methods_matching(/^spec_/)
        end
      }

      klass = Class.new(super_klass) {
        def spec_foo; end
        def foo_test; end
      }

      assert_includes klass.runnable_methods, "spec_foo"
    end

    def test_run_is_a_subclass_responsibility
      e = assert_raises NotImplementedError do
        Runnable.new.run
      end

      exp = "subclass responsibility"
      assert_equal exp, e.message
    end
  end
end
