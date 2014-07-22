require_relative '../test_case'
require 'tunit/spec'

module Tunit
  class SpecExpectationsTest < TestCase
    include Spec::Expect::Expectations

    def setup
      self.tc                = Class.new(Spec).new "custom_spec"
      self.expectation_count = 0
    end
    attr_accessor :tc, :expectation_count

    def teardown
      super
      assert_equal expectation_count, tc.assertions,
        "Expected #{expectation_count} assertions to have been made to #{tc}, but was #{tc.assertions}"
    end

    def test_expect_to_equal
      self.expectation_count = 1

      tc.expect(2).to eq 2
    end

    def test_expect_to_not_equal
      self.expectation_count = 1

      tc.expect(1).to not_eq 2
    end

    def test_expect_to_match
      self.expectation_count = 2

      tc.expect("foo").to match(/oo/)
    end

    def test_expect_to_not_match
      self.expectation_count = 2

      tc.expect("foo").to not_match(/bar/)
    end

    def test_expect_to_include
      self.expectation_count = 2

      tc.expect([1,2]).to include 1
    end

    def test_expect_to_not_include
      self.expectation_count = 2

      tc.expect([1]).to not_include 2
    end

    def test_expect_to_respond_to
      self.expectation_count = 1

      tc.expect(String).to respond_to :=~
    end

    def test_expect_to_not_respond_to
      self.expectation_count = 1

      tc.expect(String).to not_respond_to :omg
    end
  end
end
