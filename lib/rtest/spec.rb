require 'rtest/test'

module Rtest
  class Spec < Test
    module DSL
      def before &block
        define_method :setup do
          self.instance_eval(&block)
        end
      end

      def after &block
        define_method :teardown do
          self.instance_eval(&block)
        end
      end

      def it desc, &block
        block ||= -> { skip "(no tests defined)" }

        @specs ||= 0
        @specs += 1

        test_name = desc.gsub " ", "_"
        name      = "test_%04d_%s" % [ @specs, test_name ]

        define_method name, &block

        name
      end
    end

    extend DSL
  end
end
