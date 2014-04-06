require_relative 'test_case'
require 'tunit/spec'

MyThing = Class.new

module Tunit
  class SpecTest < TestCase
    def test_it_blocks_are_converted_to_test_methods
      klass = Class.new(Spec) {
        it "does the thing" do end
      }

      klass.new "blah"

      assert_includes klass.runnable_methods, "test_0001_does_the_thing"
    end

    def test_before_is_converted_to_setup
      klass = Class.new(Spec)
      klass.before { "here!" }

      assert_respond_to klass.new(:test), :setup
      assert_equal "here!", klass.new(:test).setup
    end

    def test_after_is_converted_to_teardown
      klass = Class.new(Spec)
      klass.after { "there!" }

      assert_respond_to klass.new(:test), :teardown
      assert_equal "there!", klass.new(:test).teardown
    end

    def test_describe_is_converted_to_a_test_klass_with_test_methods
      my_thing = describe MyThing do
        it 'dances all night long' do end
      end

      assert_includes my_thing.ancestors, ::Tunit::Test
      assert_includes my_thing.runnable_methods, "test_0001_dances_all_night_long"
    end

    def test_describe_can_be_nested
      my_thing = describe MyThing do
        describe '#dance!' do
          it 'busts the moves' do end
        end
      end

      child = my_thing.children.first

      assert_equal 1, my_thing.children.size
      assert_equal "#dance!", child.name
      assert_includes child.runnable_methods, "test_0001_busts_the_moves"
    end

    def test_let_defines_accessors
      my_thing = describe MyThing do
        let(:lazy) { "here ma" }
      end

      my = my_thing.new(:bogus)
      assert_respond_to my, :lazy
      assert_equal "here ma", my.lazy
    end

    def test_let_is_lazy
      my_thing = describe MyThing do
        let(:lazy) { "here ma" }
      end

      my            = my_thing.new(:bogus)
      first_obj_id  = my.lazy
      second_obj_id = my.lazy

      assert_equal first_obj_id, second_obj_id
    end
  end
end
