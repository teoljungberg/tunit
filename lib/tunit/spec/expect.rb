require 'tunit/test'

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
      def eq exp = nil
        [:assert_equal, exp]
      end

      def not_eq exp = nil
        [:refute_equal, exp]
      end
    end

    extend Expectations
  end
end
