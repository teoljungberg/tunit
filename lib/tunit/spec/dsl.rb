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

    klass = super_klass.create_sub_klass desc
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
          instance_eval(&block)
        end
      end

      def after &block
        define_method :teardown do
          instance_eval(&block)
        end
      end

      def it desc = "blank", &block
        block ||= -> { skip "(no tests defined)" }

        @specs ||= 0
        @specs += 1

        test_name = desc.gsub " ", "_"
        name      = "#{prefix}_%04d_%s" % [ @specs, test_name ]

        define_method name, &block
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

      def create_sub_klass name
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

      private

      def prefix
        prefix_without_regexp = /\^(.*?)_/
        PREFIX.source.match(prefix_without_regexp)[1]
      end
    end
  end
end
