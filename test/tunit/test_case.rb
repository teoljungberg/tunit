if RUBY_VERSION == "1.9.3"
  gem "minitest"
end

require "minitest/autorun"
require "tunit/test"
require "stringio"

module Tunit
  class TestCase < Minitest::Test
    def io
      @io ||= StringIO.new ""
    end

    def dummy_reporter
      @dummy_reporter ||= Class.new {
        def initialize
          self.assertions = 0
        end
        attr_accessor :assertions

        def record(*)
          self.assertions += 1
        end
      }.new
    end

    private

    def truncate_absolut_path str
      str.gsub(%r{\[.*(test/tunit/test_case.rb.*)\]}, '[\1]')
    end

    def remove_line_numbers str
      str.gsub(/:\d{1,}/, ':LINE')
    end

    def zeroify_time str
      str.gsub(/\d/, '0')
    end

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

    class ErrorTest < Test
      def initialize test = :test_error
        super
      end

      def test_error
        fail NotAnAssertion
      end
    end
  end
end
