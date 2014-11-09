require 'abbrev'

module Tunit
  class Spec
    def expect value
      Expect.new value, self
    end

    class Expect
      def initialize value, klass
        self.value = -> { value }
        self.klass = klass
      end
      attr_accessor :value, :klass

      def to matcher
        assertion, real_value = matcher
        exp_value             = value.call

        klass.send assertion, exp_value, real_value
      end

      module Expectations
        def method_missing method_name, *args, &block
          assertion = fetch_assertion method_name

          if assertion
            [assertion, args.shift]
          else
            super
          end
        end

        def respond_to_missing? method_name, include_private = false
          fetch_assertion(method_name) || super
        end

        private

        def assertions_mapper
          Tunit::Assertions.public_instance_methods(false).map(&:to_s).
            grep(/(assert|refute)/).abbrev
        end

        def fetch_assertion method_name
          if method_name.match(/^not_(.*)/)
            assertions_mapper["refute_#{$1}"]
          else
            assertions_mapper["assert_#{method_name}"]
          end
        end
      end
    end
  end
end
