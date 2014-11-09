require 'test_helper'
require 'tunit/spec'

module Tunit
  class SpecExpectTest < TestCase
    def test_expect_wraps_up_a_expect_object
      klass = Class.new(Spec) {
        it 'passes' do
          assert_instance_of Spec::Expect, expect(2)
        end
      }

      k = klass.new "spec_0001_passes"
      k.run

      assert_equal 1, k.assertions
    end

    def test_to_sends_assertions
      klass = Class.new(Spec) {
        it "passes" do
          expect(2).to eq 2
        end
      }

      k = klass.new "spec_0001_passes"
      k.run

      assert_equal 1, k.assertions
    end

    def test_not_to_sends_refutions
      klass = Class.new(Spec) {
        it "passes" do
          expect(6).not_to eq 9
        end
      }

      k = klass.new "spec_0001_passes"
      k.run

      assert_equal 1, k.assertions
    end

    def test_expect_must_be_inside_an_it_block
      e = assert_raises NoMethodError do
        Class.new(Spec) {
          expect(2).to eq 1
        }
      end

      exp_match = /undefined method `expect'/

      assert_match exp_match, e.message
    end
  end

  class ExpectTest < TestCase
    def test_initialize_sets_the_value_as_a_proc
      expect = Spec::Expect.new 2, self

      assert_instance_of Proc, expect.value
      assert_equal 2, expect.value.call
    end

    def test_method_missing_defines_matchers_depending_on_the_assertions
      tc = self

      klass = Class.new(Spec) {
        it 'passes' do
          tc.assert_equal "assert_match", match.first
          self.assertions = tc.assertions
        end
      }

      k = klass.new "spec_0001_passes"
      k.run
    end

    def test_respond_to_missing_maps_expectation_matchers_to_assertions
      k = Class.new(Spec).new :test

      assert_respond_to k, :eq
      assert_equal ["assert_equal", 42], k.eq(42)
    end

    def test_respond_to_missing_maps_expectation_matchers_to_refutions
      k = Class.new(Spec).new :test

      assert_respond_to k, :not_match
      assert_equal ["refute_match", 42], k.not_match(42)
    end

    def test_respond_to_missing_only_maps_to_assertions_and_refutions
      k = Class.new(Spec).new :test

      refute_respond_to k, :jikes
    end

    def test_method_missing_executes_assertions_from_the_caller_class
      klass = Class.new(Spec) {
        it 'passes' do
          expect(/oo/).to match "foo"
        end
      }

      k = klass.new "spec_0001_passes"
      k.run

      assert_equal 2, k.assertions
    end
  end
end
