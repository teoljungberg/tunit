require_relative './test_case'
require 'tunit/reporter'

module Tunit
  class ReporterTest < TestCase
    def setup
      self.reporter = Reporter.new
    end
    attr_accessor :reporter

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

    def test_passed_eh
      reporter.record PassingTest.new.run

      assert reporter.passed?
    end

    def test_passed_eh_is_only_for_passing_tests
      reporter.record FailingTest.new.run

      refute reporter.passed?
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

    def test_report_collects_skips
      reporter.start
      reporter.record SkippedTest.new.run
      reporter.report

      assert_equal 1, reporter.skips
    end
  end
end
