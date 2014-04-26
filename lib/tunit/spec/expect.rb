require 'tunit/test'

module Tunit
  class Spec < Test
    def self.expect value
      Expect.new value
    end

    class Expect
      def initialize value
        self.value = -> { value }
      end
      attr_accessor :value

      def to
        value.call
      end

      def not_to
        !to
      end
    end
  end
end
