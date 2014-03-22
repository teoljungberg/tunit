module Rtest
  class Runnable
    def self.runnable_methods
      raise NotImplementedError, "subclass responsibility"
    end

    private

    def self.methods_matching re
      public_instance_methods(true).grep(re).map(&:to_s)
    end
  end
end

