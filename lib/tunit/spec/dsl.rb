require 'tunit/test'

module Tunit
  class Spec < Test
    module DSL
      attr_reader :name

      def before &block
        define_method :setup do
          instance_eval(&block)
        end
      end

      def after &block
        define_method :teardown do
          instance_eval(&block)
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

      def let name, &block
        define_method(name) {
          @lazy ||= {}
          @lazy.fetch(name) {|method| @lazy[method] = instance_eval(&block) }
        }
      end

      def children
        @children ||= []
      end

      def create name
        klass = Class.new(self) {
          @name = name

          remove_test_methods!
        }

        children << klass

        klass
      end

      def remove_test_methods!
        runnable_methods.map { |test|
          send :undef_method, test
        }
      end
    end
  end
end
