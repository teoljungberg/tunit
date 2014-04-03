require 'tunit/reporter'

module Tunit
  class CompoundReporter < Reporter
    def initialize *reporters
      super()
      self.reporters = reporters
    end
    attr_accessor :reporters

    def << reporter
      self.reporters << reporter
    end

    def passed?
      self.reporters.all?(&:passed?)
    end

    def start
      self.reporters.each(&:start)
    end

    def record result
      self.reporters.each do |reporter|
        reporter.record result
      end
    end

    def report
      self.reporters.each(&:report)
    end
  end
end
