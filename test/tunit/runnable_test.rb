require 'test_helper'
require 'tunit/runnable'

module Tunit
  class RunnableTest < TestCase
    def setup
      Runnable.runnables = PassingTest
    end

    def dummy_reporter
      @dummy_reporter ||= Class.new {
        def initialize
          self.assertions = 0
        end
        attr_accessor :assertions

        def record(*)
          self.assertions += 1
        end
      }.new
    end

    def test_runnable_methods_is_a_subclass_responsibility
      e = assert_raises NotImplementedError do
        Runnable.runnable_methods
      end

      exp = "subclass responsibility"
      assert_equal exp, e.message
    end

    def test_runnables_list_all_runnables_that_inherit_from_runnable
      Runnable.runnables.clear
      new_subklass = Class.new(Runnable)

      assert_includes Runnable.runnables, new_subklass
    end

    def test_runnables_custom
      Runnable.runnables = "omg"

      assert_equal ["omg"], Runnable.runnables
    end

    def test_runnable_methods_shuffles_the_tests
      assert_equal :random, PassingTest.order
    end

    def test_order_bang_orders_your_tests
      sucky_test = Class.new(PassingTest) {
        order!
      }

      assert_equal :alpha, sucky_test.order
    end

    def test_run_runs_all_tests_with_a_given_reporter
      PassingTest.run dummy_reporter, io: io

      assert_equal dummy_reporter.assertions, PassingTest.runnable_methods.size
    end

    def test_run_runs_all_tests_with_matching_pattern
      filter          = "test_pass_one_more"
      matched_methods = PassingTest.runnable_methods.grep(/#{filter}/)

      PassingTest.run dummy_reporter, io: io, filter: filter

      assert_equal dummy_reporter.assertions, matched_methods.size
    end

    def test_runnable_methods_can_be_customized_to_find_your_tests
      super_klass = Class.new(Runnable) {
        def self.runnable_methods
          methods_matching(/^blah_/)
        end
      }

      klass = Class.new(super_klass) {
        def blah_foo; end
        def test_foo; end
      }

      assert_includes klass.runnable_methods, "blah_foo"
    end

    def test_run_is_a_subclass_responsibility
      e = assert_raises NotImplementedError do
        Runnable.new("name").run
      end

      exp = "subclass responsibility"
      assert_equal exp, e.message
    end
  end
end
