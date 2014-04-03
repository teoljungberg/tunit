require 'tunit/test'

module Kernel
  # Override describe to avoid warnings and collisions with minitest/spec
  alias_method :_old_describe, :describe if defined? Minitest
  def describe desc, &block
    _old_describe desc, &block if defined? Minitest

    super_klass = if Class === self && is_a?(Tunit::Spec::DSL)
                    self
                  else
                    Tunit::Spec
                  end

    klass = super_klass.create desc
    klass.class_eval(&block)
    klass
  end
end

module Tunit
  class Spec < Test
    module DSL
      attr_reader :name

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
        self.runnable_methods.map { |test|
          self.send :undef_method, test
        }
      end
    end

    extend DSL
  end
end
