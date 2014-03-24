require 'minitest/autorun'
require 'rtest/test'

module Rtest
  class TestCase < Minitest::Test
    class PassingTest < Test
      def test_even_eh
        assert 2.even?
      end

      def test_includes_eh
        assert [1, 2].include?(2)
      end
    end

    class FailingTest < Test
      def test_fail_even_eh
        refute 2.even?
      end

      def test_empty
      end
    end

    class SkippedTest < Test
      def test_skip
        skip
      end

      def test_skip_with_msg
        skip "implement me when IQ > 80"
      end
    end
  end
end
