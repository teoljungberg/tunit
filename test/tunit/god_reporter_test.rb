require 'test_helper'
require 'tunit/god_reporter'

module Tunit
  class GodReporterTest < TestCase
    def setup
      @reporter = GodReporter.new
      @reporter << SummaryReporter.new(io)
      @reporter << ProgressReporter.new(io)
    end
    attr_reader :reporter

    def test_shuffle_operator
      reporter = GodReporter.new
      assert_empty reporter.reporters

      reporter << :some_reporter
      refute_empty reporter.reporters
    end

    def test_start
      assert_empty reporter.reporters.map(&:start_time).compact
      reporter.start

      refute_empty reporter.reporters.map(&:start_time).compact
    end

    def test_reporters
      refute_empty reporter.reporters
    end

    def test_passed_eh
      reporter.record PassingTest.new.run

      assert_predicate reporter, :passed?
    end

    def test_passed_eh_fails_of_any_reporter_failed
      reporter.record FailingTest.new.run
      refute reporter.passed?
    end

    def test_record
      reporter.record PassingTest.new.run
      reporter_count = reporter.reporters.map(&:count).inject(:+)

      assert_equal 1, reporter_count
    end

    def test_report
      reporter.start
      reporter.record PassingTest.new.run
      reporter.report
      exp_report = <<-EOS
Run options: {}

# Running:

.

Finished in 0.00

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
EOS

      assert_equal exp_report, normalize_output(io.string)
    end
  end
end
