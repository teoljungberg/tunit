module Rtest
  class Assertion < Exception
    def error
      self
    end

    def result_code
      result_label[0, 1]
    end

    def result_label
      "Failure"
    end
  end

  class EmptyTest < Assertion
    def result_label
      "_Empty"
    end
  end

  module Assertions
    def assert test, msg = nil
      msg ||= "Failed assertion, no message given."
      self.assertions += 1
      unless test
        msg = msg.call if Proc === msg
        raise ::Rtest::Assertion, msg
      end
      true
    end

    def assert_equal exp, act, msg = nil
      msg ||= "Failed assertion, no message given."
      assert exp == act, msg
    end

    def refute test, msg = nil
      msg ||= "Failed assertion, no message given."
      ! assert !test, msg
    end

    def refute_equal exp, act, msg = nil
      msg ||= "Failed assertion, no message given."
      refute exp == act, msg
    end
  end
end
