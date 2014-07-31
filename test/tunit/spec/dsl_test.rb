require 'test_helper'
require 'tunit/spec'

MyThing = Class.new

module Tunit
  class SpecDSLTest < TestCase
    def test_it_blocks_are_converted_to_test_methods
      klass = Class.new(Spec) {
        it "does the thing" do end
      }

      assert_includes klass.runnable_methods, "spec_0001_does_the_thing"
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

      assert          my_thing < Tunit::Test
      assert          my_thing < Tunit::Runnable
      assert_includes my_thing.runnable_methods, "spec_0001_dances_all_night_long"
    end

    def test_describe_can_be_nested
      my_thing = describe MyThing do
        describe '#dance!' do
          it 'busts the moves' do end
        end
      end

      assert_equal 1, my_thing.children.size

      child = my_thing.children.first

      assert_equal "#dance!", child.name
      assert_includes child.runnable_methods, "spec_0001_busts_the_moves"
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
      first_obj_id  = my_thing.lazy.object_id
      second_obj_id = my_thing.lazy.object_id

      assert_equal first_obj_id, second_obj_id
    end
  end
end
