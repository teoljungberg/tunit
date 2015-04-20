require "tunit/test"
require "tunit/spec"

module Tunit
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

    def test_skip_with_message
      skip "implement me when IQ > 80"
    end
  end

  class ErrorTest < Test
    def initialize test = :test_exception
      super
    end

    def test_exception
      raise "hell"
    end
  end
end
