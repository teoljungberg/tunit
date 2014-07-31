require_relative 'test_case'
require 'tunit/summary_reporter'

module Tunit
  class SummaryReporterTest < TestCase
    def setup
      @reporter = SummaryReporter.new io
    end
    attr_reader :reporter

    def test_start_returns_run_msg
      reporter.start
      exp_msg = <<-EOS
Run options: {}

# Running:

      EOS

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
Tunit::TestCase::FailingTest#test_fail [test/tunit/test_case.rb:LINE]:
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

    def test_report_considers_empty_test_failures
      reporter.start
      reporter.record FailingTest.new(:test_empty).run
      reporter.report

      summary     = reporter.send :summary
      exp_summary = /1 runs, 0 assertions, 0 failures, 1 skips/

      assert_match exp_summary, summary
    end

    def test_report_summay_does_not_show_skip_message_if_verbose
      reporter = SummaryReporter.new io, verbose: true
      reporter.start
      reporter.record SkippedTest.new.run
      reporter.report

      summary          = reporter.send :summary
      summary_skip_msg = /#{SummaryReporter::SKIP_MSG}/

      refute_match summary_skip_msg, summary
    end

    def test_report_only_shows_skips_if_verbose
      unverbose_reporter    = self.reporter
      unverbose_reporter.io = StringIO.new ""
      verbose_reporter      = SummaryReporter.new io, verbose: true

      verbose_reporter.start
      verbose_reporter.record SkippedTest.new(:test_skip).run
      verbose_reporter.report

      reporter.start
      reporter.record SkippedTest.new(:test_skip).run
      reporter.report

      exp_report = /1\) Skipped:\nTunit::TestCase::SkippedTest#test_skip \[(.*)\]/

      assert_match exp_report, io.string
      refute_match exp_report, reporter.io.string
    end
  end
end
