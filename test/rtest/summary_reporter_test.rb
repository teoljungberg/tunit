require_relative 'test_case'
require 'rtest/summary_reporter'

module Rtest
  class SummaryReporterTest < TestCase
    def setup
      self.io       = StringIO.new ""
      self.reporter = SummaryReporter.new io
    end
    attr_accessor :io, :reporter

    def test_start_returns_run_msg
      reporter.start
      exp_msg = "# Running:\n"

      assert_equal exp_msg, io.string
    end

    def test_report_gives_test_run_statistics
      reporter.start
      reporter.record PassingTest.new.run
      reporter.report

      stats     = reporter.send :statistics
      exp_stats = %r(Finished in 0{1,}.0{1,}s, 0{1,}.0{1,} runs/s, 0{1,}.0{1,} assertions/s.)

      assert_match exp_stats, zeroify_time(stats)
    end

    def test_report_returns_errors
      reporter.start
      reporter.record FailingTest.new.run
      reporter.report

      aggregated_results     = reporter.send :aggregated_results
      exp_aggregated_results = <<-EOS

  1) Failure:
Rtest::TestCase::FailingTest#test_fail [test/rtest/test_case.rb:LINE]:
Failed assertion, no message given.
      EOS

      assert_equal exp_aggregated_results, remove_line_numbers(
        truncate_absolut_path(aggregated_results)
      )
    end

    def test_report_returns_summary
      reporter.start
      reporter.record PassingTest.new.run
      reporter.report

      summary     = reporter.send :summary
      exp_summary = "1 runs, 1 assertions, 0 failures, 0 skips"

      assert_equal exp_summary, summary
    end

    private

    def remove_line_numbers str
      str.gsub(/:\d{1,}/, ':LINE')
    end

    def zeroify_time str
      str.gsub(/\d/, '0')
    end
  end
end
