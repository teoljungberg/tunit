require_relative 'test_case'
require 'rtest/progress_reporter'

module Rtest
  class ProgressReporterTest < TestCase
    def setup
      self.reporter = ProgressReporter.new io
    end
    attr_accessor :reporter

    def test_record_passing_tests
      reporter.record PassingTest.new.run

      assert_equal ".", io.string
    end

    def test_record_skipped_tests
      reporter.record SkippedTest.new.run

      assert_equal "S", io.string
    end

    def test_record_failing_tests
      reporter.record FailingTest.new.run

      assert_equal "F", io.string
    end

    def test_record_empty_tests
      reporter.record FailingTest.new(:test_empty).run

      assert_equal "_", io.string
    end
  end
end
