require 'tunit/test_case'
require 'tunit/spec'

module Tunit
  class SpecTest < TestCase
    def test_PREFIX
      exp_prefix = /^spec_/

      assert_equal exp_prefix, Spec::PREFIX
    end

    def test_runnable_methods
      spec = describe "blah" do
        it "does the thing" do end
      end

      assert_includes spec.runnable_methods, "spec_0001_does_the_thing"
    end
  end
end
