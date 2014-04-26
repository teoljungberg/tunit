require 'tunit/spec/dsl'

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
  end
end
