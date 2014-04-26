require 'tunit/test'

module Tunit
  class Spec < Test
    def self.expect value
      Expect.new value
    end

    class Expect
      def initialize value
        self.value = value
      end
      attr_accessor :value
    end
  end
end
