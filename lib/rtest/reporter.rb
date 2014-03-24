module Rtest
  class Reporter
    def initialize options = {}
      self.options    = {}
      self.assertions = 0
      self.count      = 0
      self.results    = []
    end
    attr_accessor :options, :assertions, :count, :results, :start_time

    def start
      self.start_time = Time.now
    end

    def record result
      self.count += 1
      self.assertions += result.assertions

      self.results << result if !result.passed? || result.skipped?
    end

    def passed?
      results.all?(&:skipped?)
    end
  end
end

