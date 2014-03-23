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

  class Skip < Assertion
    def result_label
      "Skipped"
    end
  end

  module Assertions
    def skip msg = nil, bt = caller
      method_responsible = bt[0][/`.*'/][1..-2]
      msg ||= "Skipped '#{method_responsible}'"
      raise ::Rtest::Skip, msg, bt
    end

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

    def assert_includes collection, obj, msg = nil
      msg ||= "Expected #{collection.inspect} to include #{obj}"
      assert_respond_to collection, :include?
      assert collection.include?(obj), msg
    end

    def assert_respond_to obj, meth, msg = nil
      msg ||= "Expected #{obj.inspect} (#{obj.class}) to respond to ##{meth}"
      assert obj.respond_to?(meth), msg
    end

    def assert_instance_of klass, obj, msg = nil
      msg ||= "Expected #{obj.inspect} to be an instance of #{klass}, not #{obj.class}"
      assert obj.instance_of?(klass), msg
    end

    def refute test, msg = nil
      msg ||= "Failed assertion, no message given."
      ! assert !test, msg
    end

    def refute_equal exp, act, msg = nil
      msg ||= "Failed assertion, no message given."
      refute exp == act, msg
    end

    def refute_includes collection, obj, msg = nil
      msg ||= "Expected #{collection.inspect} to not include #{obj}"
      assert_respond_to collection, :include?
      refute collection.include?(obj), msg
    end

    def refute_respond_to obj, meth, msg = nil
      msg ||= "Expected #{obj.inspect} (#{obj.class}) to not respond to #{meth}"
      refute obj.respond_to?(meth), msg
    end

    def refute_instance_of klass, obj, msg = nil
      msg ||= "Expected #{obj.inspect} not to be an instance of #{klass}"
      refute obj.instance_of?(klass), msg
    end
  end
end
