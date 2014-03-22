require 'minitest/autorun'
require 'rtest/assertions'

module Rtest
  class AssertionErrorTest < Minitest::Test
    def setup
      self.assertion = Assertion.new
    end
    attr_accessor :assertion

    def test_error
      assert Assertion === assertion.error
    end

    def test_result_code
      assert_equal "F", assertion.result_code
    end

    def test_result_label
      assert_equal "Failure", assertion.result_label
    end
  end

  class EmptyTestErrorTest < Minitest::Test
    def setup
      self.assertion = EmptyTest.new
    end
    attr_accessor :assertion

    def test_error
      assert EmptyTest === assertion.error
    end

    def test_result_code
      assert_equal "_", assertion.result_code
    end

    def test_result_label
      assert_equal "_Empty", assertion.result_label
    end
  end
end
