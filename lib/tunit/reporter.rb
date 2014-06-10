module Tunit
  class Reporter
    def initialize io = $stdout, options = {}
      self.io         = io
      self.options    = options
      self.assertions = 0
      self.count      = 0
      self.results    = []
    end
    attr_accessor :io, :options, :assertions, :count, :results
    attr_accessor :start_time, :total_time
    attr_accessor :failures, :skips, :errors

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

    def report
      total           = results.group_by {|r| r.failure.class }
      total.default   = []

      self.total_time   = Time.now - start_time
      self.failures     = total[Assertion].size
      self.skips        = total[Skip].size
    end
  end
end
