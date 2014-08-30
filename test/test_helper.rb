if RUBY_VERSION == "1.9.3"
  gem "minitest"
end

require "minitest/autorun"
require "tunit/test"
require "stringio"

require "sample/tests"
require "sample/specs"

module Tunit
  class TestCase < Minitest::Test
    def io
      @io ||= StringIO.new ""
    end

    def teardown
      Runnable.runnables.clear
    end

    private

    def truncate_absolute_path str
      str.gsub(%r{\[.*(test/sample/.*.rb.*)\]}, '[\1]')
    end

    def remove_line_numbers str
      str.gsub(/:\d{1,}/, ':LINE')
    end

    def zeroify_time str
      str.gsub(/\d/, '0')
    end
  end
end
