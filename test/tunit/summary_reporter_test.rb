require 'test_helper'
require 'tunit/summary_reporter'

module Tunit
  class SummaryReporterTest < TestCase
    def setup
      @reporter = SummaryReporter.new io
    end
    attr_reader :reporter

    def test_start_returns_run_msg
      reporter.start
      exp_msg = <<-EOS.strip_heredoc
        Run options: {}

        # Running:

      EOS

      assert_equal exp_msg, io.string
    end

    def test_report_gives_test_run_statistics
      reporter.start
      reporter.record PassingTest.new.run
      reporter.report

      stats = reporter.send :statistics

      assert_equal "Finished in 0.00", normalize_output(stats)
    end

    def test_report_returns_failed_assertions
      reporter.start
      reporter.record FailingTest.new.run
      reporter.report

      aggregated_results     = reporter.send :aggregated_results
      exp_aggregated_results = <<-EOS.strip_heredoc

        1) Failure:
        Tunit::FailingTest#test_fail [FILE:LINE]:
        Failed assertion, no message given.

      EOS

      assert_equal exp_aggregated_results, normalize_output(aggregated_results)
    end

    def test_report_returns_summary
      reporter.start
      reporter.record PassingTest.new.run
      reporter.report

      summary     = reporter.send :summary
      exp_summary = "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips"

      assert_equal exp_summary, summary
    end

    def test_report_considers_empty_test_failures
      reporter.start
      reporter.record FailingTest.new(:test_empty).run
      reporter.report

      summary     = reporter.send :summary
      exp_summary = /1 runs, 0 assertions, 0 failures, 0 errors, 1 skips/

      assert_match exp_summary, summary
    end

    def test_report_returns_errors_and_exceptions
      reporter.start
      reporter.record ErrorTest.new(:test_exception).run
      reporter.report

      summary     = reporter.send :summary
      exp_summary = /1 runs, 0 assertions, 0 failures, 1 errors, 0 skips/

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

      exp_report = /1\) Skipped:\nTunit::SkippedTest#test_skip \[(.*)\]/

      assert_match exp_report, io.string
      refute_match exp_report, reporter.io.string
    end
  end
end
