require 'tunit/assertion_errors'

module Tunit
  module Assertions
    def assert test, message = nil
      message ||= "Failed assertion, no message given."
      self.assertions += 1

      unless test
        fail FailedAssertion, message
      end

      true
    end

    def assert_equal expected, actual, message = nil
      message ||= "Failed assertion, no message given."

      assert expected == actual, message
    end

    def assert_includes collection, obj, message = nil
      message ||= "Expected #{collection.inspect} to include #{obj}"

      assert_respond_to collection, :include?
      assert collection.include?(obj), message
    end

    def assert_respond_to obj, method_name, message = nil
      message ||= "Expected #{obj.inspect} (#{obj.class}) to respond to ##{method_name}"

      assert obj.respond_to?(method_name), message
    end

    def assert_instance_of klass, obj, message = nil
      message ||= "Expected #{obj.inspect} to be an instance of #{klass}, not #{obj.class}"

      assert obj.instance_of?(klass), message
    end

    def assert_predicate obj, method_name, message = nil
      message ||= "Expected #{obj.inspect} to be #{method_name.inspect}"

      assert obj.__send__(method_name), message
    end

    def refute_predicate obj, method_name, message = nil
      message ||= "Expected #{obj.inspect} not to be #{method_name.inspect}"

      refute obj.__send__(method_name)
    end

    def refute test, message = nil
      message ||= "Failed assertion, no message given."

      not assert !test, message
    end

    def refute_equal expected, actual, message = nil
      message ||= "Failed assertion, no message given."

      refute expected == actual, message
    end

    def refute_includes collection, obj, message = nil
      message ||= "Expected #{collection.inspect} to not include #{obj}"
      assert_respond_to collection, :include?

      refute collection.include?(obj), message
    end

    def refute_respond_to obj, method_name, message = nil
      message ||= "Expected #{obj.inspect} (#{obj.class}) to not respond to #{method_name}"

      refute obj.respond_to?(method_name), message
    end

    def refute_instance_of klass, obj, message = nil
      message ||= "Expected #{obj.inspect} not to be an instance of #{klass}"

      refute obj.instance_of?(klass), message
    end

    def assert_match regexp, string, message = nil
      message ||= "Expected #{regexp.inspect} to match '#{string}'"

      assert_respond_to string, :=~
      assert string =~ regexp, message
    end

    def refute_match regexp, string, message = nil
      message ||= "Expected #{regexp.inspect} not to match '#{string}'"

      assert_respond_to string, :=~
      refute string =~ regexp, message
    end

    def assert_raises exception
      yield
    rescue Exception => e
      message = "Expected #{exception.inspect} to have been raised, got #{e.inspect}"
      assert exception === e , message
      e
    end
  end
end
