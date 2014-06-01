require_relative '../test_case'
require 'tunit/spec'

MyThing = Class.new

module Tunit
  class SpecDSLTest < TestCase
    def test_it_blocks_are_converted_to_test_methods
      klass = Class.new(Spec) {
        it "does the thing" do end
      }

      assert_includes klass.runnable_methods, "test_0001_does_the_thing"
    end

    def test_before_is_converted_to_setup
      klass = Class.new(Spec)
      klass.before { "here!" }

      k = klass.new :test

      assert_respond_to k, :setup
      assert_equal "here!", k.setup
    end

    def test_after_is_converted_to_teardown
      klass = Class.new(Spec)
      klass.after { "there!" }

      k = klass.new :test

      assert_respond_to k, :teardown
      assert_equal "there!", k.teardown
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

    def test_describe_is_a_runnable_with_runnable_methods
      my_thing = describe MyThing do
        describe '#dance!' do
          it 'busts the moves' do end
          it 'busts the moves during a full moon' do end
        end

        describe '#stop?' do
          it 'loves hammer time' do end
        end
      end

      dance_bang, stop_eh = my_thing.children

      assert_includes my_thing.ancestors, Runnable

      assert_equal [
        "test_0001_busts_the_moves",
        "test_0002_busts_the_moves_during_a_full_moon"
      ], dance_bang.runnable_methods.sort

      assert_equal ["test_0001_loves_hammer_time"], stop_eh.runnable_methods.sort
    end

    def test_let_creates_attr_accessors
      thing = describe MyThing do
        let(:lazy) { "here ma" }
      end

      my_thing = thing.new(:test)

      assert_respond_to my_thing, :lazy
      assert_equal "here ma", my_thing.lazy
    end

    def test_let_is_lazy
      thing = describe MyThing do
        let(:lazy) { "here ma" }
      end

      my_thing      = thing.new(:test)
      first_obj_id  = my_thing.lazy
      second_obj_id = my_thing.lazy

      assert_equal first_obj_id, second_obj_id
    end
  end
end
