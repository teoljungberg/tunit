module Tunit
  class Runnable
    def self.runnable_methods
      fail NotImplementedError, "subclass responsibility"
    end

    def self.runnables
      @@runnables ||= []
    end

    def self.runnables= runnable
      @@runnables = Array(runnable)
    end

    def self.inherited klass
      runnables << klass
      super
    end

    # Randomize tests by default
    def self.order
      @order ||= :random
    end

    def self.order= new_order
      @order = new_order
    end

    def self.randomize_off
      self.order = :alpha
    end

    def self.run reporter, options = {}
      filter = options.fetch(:filter) { '/./' }
      filter = Regexp.new $1 if filter =~ /\/(.*)\//

      filtered_methods = runnable_methods.select { |m|
        filter === m || filter === "#{self}##{m}"
      }

      filtered_methods.each { |test|
        reporter.record self.new(test).run
      }
    end

    def initialize name
      self.name       = name
      self.assertions = 0
      self.failures   = []
    end
    attr_accessor :name, :assertions, :failures, :time

    def run
      fail NotImplementedError, "subclass responsibility"
    end

    private

    def self.methods_matching re
      public_instance_methods(true).grep(re).map(&:to_s)
    end
  end
end
