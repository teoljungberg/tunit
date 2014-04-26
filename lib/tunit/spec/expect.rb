require 'tunit/test'
require 'abbrev'

module Tunit
  class Spec < Test
    def self.expect value
      Expect.new value
    end

    class Expect < Spec
      def initialize value
        super
        self.value = -> { value }
      end
      attr_accessor :value

      def to matcher
        self.send matcher.shift, value.call, matcher.shift
      end
    end

    module Expectations
      def method_missing method, *args, &block
        assertion = if method.match(/^not_(.*)/)
                      assertions["refute_#{$1}"]
                    else
                      assertions["assert_#{method}"]
                    end

        if assertion
          [assertion, args.shift]
        else
          fail NotAnAssertion
        end
      end

      private

      def assertions
        Tunit::Assertions.public_instance_methods(false).map(&:to_s).abbrev
      end
    end

    extend Expectations
  end
end
