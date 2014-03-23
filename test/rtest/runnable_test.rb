require 'minitest/autorun'
require 'rtest/runnable'

module Rtest
  class RunnableTest < Minitest::Test
    def test_runnable_methods_is_a_subclass_responsibility
      e = assert_raises NotImplementedError do
        Runnable.runnable_methods
      end

      exp = "subclass responsibility"
      assert_equal exp, e.message
    end

    def test_runnable_methods_can_be_customized_to_find_your_tests
      super_klass = Class.new(Runnable) {
        def self.runnable_methods
          methods_matching(/^test_/)
        end
      }

      klass = Class.new(super_klass) {
        def test_foo; end
        def foo_test; end
      }

      assert_includes klass.runnable_methods, "test_foo"
    end

    def test_run_is_a_subclass_responsibility
      e = assert_raises NotImplementedError do
        Runnable.new.run "test_foo"
      end

      exp = "subclass responsibility"
      assert_equal exp, e.message
    end
  end
end
