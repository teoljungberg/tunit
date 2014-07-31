require 'tunit/reporter'
require 'tunit/summary_reporter'
require 'tunit/progress_reporter'

module Tunit
  class GodReporter < Reporter
    def initialize *reporters
      super
      @reporters = reporters
    end
    attr_reader :reporters

    def << reporter
      reporters << reporter
    end

    def passed?
      reporters.all?(&:passed?)
    end

    def start
      reporters.each(&:start)
    end

    def record result
      reporters.each do |reporter|
        reporter.record result
      end
    end

    def report
      reporters.each(&:report)
    end
  end
end
