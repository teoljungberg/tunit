require 'minitest/autorun'
require 'rtest/assertions'
require 'rtest/test'

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

  class AssertionsTest < Minitest::Test
    def setup
      self.klass = Class.new(Test) {
        def test_assert
          assert 2.even?
        end

        def test_refute
          refute 1.even?
        end

        def test_assert_equal
          assert_equal 1, 2
        end

        def test_refute_equal
          refute_equal 1, 2
        end
      }.new
    end
    attr_accessor :klass

    def test_assert
      klass.run "test_assert"
      assert_equal 1, klass.assertions
    end

    def test_refute
      klass.run "test_refute"
      assert_equal 1, klass.assertions
    end

    def test_assert_equal
      klass.run "test_assert_equal"
      assert_equal 1, klass.assertions
    end

    def test_refute_equal
      klass.run "test_refute_equal"
      assert_equal 1, klass.assertions
    end
  end
end
