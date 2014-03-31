require_relative 'test_case'
require 'rtest/spec'

module Rtest
  class SpecTest < TestCase
    def test_it_blocks_are_converted_to_test_methods
      klass = Class.new(::Rtest::Spec) {
        it "does the thing" do end
      }

      klass.new "blah"

      assert_includes klass.runnable_methods, "test_0001_does_the_thing"
    end

    def test_before_is_converted_to_setup
      klass = Class.new(::Rtest::Spec)
      klass.before { "here!" }

      assert_respond_to klass.new(:test), :setup
      assert_equal "here!", klass.new(:test).setup
    end

    def test_after_is_converted_to_teardown
      klass = Class.new(::Rtest::Spec)
      klass.after { "there!" }

      assert_respond_to klass.new(:test), :teardown
      assert_equal "there!", klass.new(:test).teardown
    end
  end
end
