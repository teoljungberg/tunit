require_relative 'test_case'
require 'tunit/compound_reporter'

module Tunit
  class CompoundReporterTest < TestCase
    def setup
      self.reporter = CompoundReporter.new
      self.reporter << SummaryReporter.new(io)
      self.reporter << ProgressReporter.new(io)
    end
    attr_accessor :reporter

    def test_shuffle
      reporter = CompoundReporter.new
      assert_empty reporter.reporters

      reporter << dummy_reporter
      refute_empty reporter.reporters
    ensure
      reporter.reporters.clear
    end

    def test_start
      assert_empty reporter.reporters.map(&:start_time).compact
      reporter.start

      refute_empty reporter.reporters.map(&:start_time).compact
    end

    def test_reporters
      refute_empty reporter.reporters
    end

    def test_reporters_equals
      prev_reporters = reporter.reporters
      reporter.reporters = :omg
      assert_equal :omg, reporter.reporters
    ensure
      reporter.reporters = prev_reporters
    end

    def test_passed_eh
      reporter.record PassingTest.new.run
      assert reporter.passed?
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

Finished in 0.000000s, 00000.0000 runs/s, 00000.0000 assertions/s.

0 runs, 0 assertions, 0 failures, 0 skips
EOS

      assert_equal exp_report, zeroify_time(io.string)
    end
  end
end
