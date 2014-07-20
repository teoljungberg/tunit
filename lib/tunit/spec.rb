require 'tunit/spec/dsl'
require 'tunit/spec/expect'

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
    extend DSL
    include Expect::Expectations

    PREFIX = /^spec_/

    def self.runnable_methods
      spec_methods = methods_matching PREFIX
      set_test_order spec_methods
    end
  end
end
