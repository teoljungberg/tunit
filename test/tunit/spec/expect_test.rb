require_relative '../test_case'
require 'tunit/spec'

module Tunit
  class SpecExpectTest < TestCase
    def test_expect_wraps_up_a_expect_object
      tc = self

      Class.new(Spec) {
        it 'passes' do
          tc.assert_instance_of Spec::Expect, expect(2)
        end
      }
    end

    def test_expect_must_be_inside_an_it_block
      tc = self

      Class.new(Spec) {
        tc.assert_raises NoMethodError do
          expect(2).to eq 1
        end
      }
    end
  end

  class ExpectTest < TestCase
    def setup
      self.expect = Spec::Expect.new 2
    end
    attr_accessor :expect

    def test_initialize_sets_the_value_as_a_proc
      assert_instance_of Proc, expect.value
    end

    def test_methods_missing_defines_matchers_depending_on_the_assertions
      tc = self

      Class.new(Spec) {
        it 'passes' do
          tc.assert expect(/oo/).to(match("foo"))
        end
      }
    end

    def test_methods_missing_fails_if_no_matcher_is_found
      tc = self

      Class.new(Spec) {
        it 'passes' do
          tc.assert_raises NotAnAssertion do
            expect(/oo/).to(die("foo"))
          end
        end
      }
    end
  end
end
