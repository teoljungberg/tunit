require 'test_helper'
require 'tunit/reporter'

module Tunit
  class ReporterTest < TestCase
    def setup
      @reporter = Reporter.new
    end
    attr_reader :reporter

    def test_start_time
      reporter.start

      assert_instance_of Time, reporter.start_time
    end

    def test_record_passing_test
      reporter.record PassingTest.new.run

      assert_equal 1, reporter.count
      assert_equal 1, reporter.assertions
    end

    def test_record_failing_test
      reporter.record FailingTest.new.run

      assert_equal 1, reporter.results.size
    end

    def test_record_skipped_test
      reporter.record SkippedTest.new.run

      assert_equal 1, reporter.results.size
    end

    def test_passed_eh
      reporter.record PassingTest.new.run

      assert_predicate reporter, :passed?
      assert_empty reporter.results
    end

    def test_passed_eh_accepts_skipped_tests
      reporter.record SkippedTest.new.run

      assert_predicate reporter, :passed?
    end

    def test_passed_eh_rejects_failing_tests
      reporter.record FailingTest.new.run

      refute_predicate reporter, :passed?
    end

    def test_report_collects_total_time
      reporter.start
      reporter.record PassingTest.new.run
      reporter.report

      assert_instance_of Float, reporter.total_time
    end

    def test_report_collects_failures
      reporter.start
      reporter.record FailingTest.new.run
      reporter.report

      assert_equal 1, reporter.failures
    end

    def test_report_considers_empty_tests_a_failures
      reporter.start
      reporter.record FailingTest.new(:test_empty).run
      reporter.report

      assert_equal 1, reporter.skips
    end

    def test_report_collects_skips
      reporter.start
      reporter.record SkippedTest.new.run
      reporter.report

      assert_equal 1, reporter.skips
    end

    def test_reporter_collects_exceptions_as_errors
      reporter.start
      reporter.record ErrorTest.new(:test_exception).run
      reporter.report

      assert_equal 1, reporter.errors
    end
  end
end
