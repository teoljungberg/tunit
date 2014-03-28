require 'minitest/autorun'
require 'rtest/test'

module Rtest
  class TestCase < Minitest::Test
    class PassingTest < Test
      def initialize name = :test_pass
        super
      end

      def test_pass
        assert 2.even?
      end

      def test_pass_one_more
        assert [1, 2].include?(2)
      end
    end

    class FailingTest < Test
      def initialize name = :test_fail
        super
      end

      def test_fail
        assert false
      end

      def test_empty
      end
    end

    class SkippedTest < Test
      def initialize test = :test_skip
        super
      end

      def test_skip
        skip
      end

      def test_skip_with_msg
        skip "implement me when IQ > 80"
      end
    end

    private

    def truncate_absolut_path str
      str.gsub(%r{\[.*(test/rtest/test_case.rb.*)\]}, '[\1]')
    end
  end
end
