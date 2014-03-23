module Rtest
  class Runnable
    def self.runnable_methods
      raise NotImplementedError, "subclass responsibility"
    end

    def initialize name = nil
      self.name       = name
      self.assertions = 0
      self.failures   = []
    end
    attr_accessor :name, :assertions, :failures, :time

    def run
      raise NotImplementedError, "subclass responsibility"
    end

    private

    def self.methods_matching re
      public_instance_methods(true).grep(re).map(&:to_s)
    end
  end
end
