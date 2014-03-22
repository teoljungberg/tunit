require 'minitest/autorun'
require 'rtest/test'

module Rtest
  class MetaTest < Minitest::Test
    def test_runnable_methods
      klass = Class.new(Test) {
        def test_foo; end
        def spec_foo; end
      }

      assert_equal Test::PREFIX, /^test_/
      assert_includes klass.runnable_methods, "test_foo"
    end
  end
end
