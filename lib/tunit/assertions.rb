require 'tunit/assertion_errors'

module Tunit
  module Assertions
    def assert test, msg = nil
      msg ||= "Failed assertion, no message given."
      self.assertions += 1

      unless test
        fail FailedAssertion, msg
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

    def assert_predicate obj, meth, msg = nil
      msg ||= "Expected #{obj.inspect} to be #{meth.inspect}"

      assert obj.__send__(meth), msg
    end

    def refute_predicate obj, meth, msg = nil
      msg ||= "Expected #{obj.inspect} not to be #{meth.inspect}"

      refute obj.__send__(meth)
    end

    def refute test, msg = nil
      msg ||= "Failed assertion, no message given."

      not assert !test, msg
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

    def assert_match regexp, string, msg = nil
      msg ||= "Expected #{regexp.inspect} to match '#{string}'"

      assert_respond_to string, :=~
      assert string =~ regexp, msg
    end

    def refute_match regexp, string, msg = nil
      msg ||= "Expected #{regexp.inspect} not to match '#{string}'"

      assert_respond_to string, :=~
      refute string =~ regexp, msg
    end

    def assert_raises exception
      yield
    rescue Exception => e
      msg = "Expected #{exception.inspect} to have been raised, got #{e.inspect}"
      assert exception === e , msg
      e
    end
  end
end
