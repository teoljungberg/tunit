require 'tunit/test'
require 'abbrev'

module Tunit
  class Spec < Test
    def expect value
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

      module Expectations
        def method_missing method, *args, &block
          assertion = fetch_assertion method

          if assertion
            [assertion, args.shift]
          else
            fail NotAnAssertion
          end
        end

        def respond_to_missing? method, include_private = false
          fetch_assertion(method) || super
        end

        private

        def assertions_mapper
          Tunit::Assertions.public_instance_methods(false).map(&:to_s).
            grep(/(assert|refute)/).abbrev
        end

        def fetch_assertion method
          if method.match(/^not_(.*)/)
            assertions_mapper["refute_#{$1}"]
          else
            assertions_mapper["assert_#{method}"]
          end
        end
      end
    end
  end
end
