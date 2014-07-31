require 'test_helper'
require 'tunit/progress_reporter'

module Tunit
  class ProgressReporterTest < TestCase
    def setup
     @reporter = ProgressReporter.new io
    end
    attr_reader :reporter

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

      assert_equal "S", io.string
    end

    def test_record_can_be_very_verbose
      reporter = ProgressReporter.new io, verbose: true
      reporter.record PassingTest.new(:test_pass).run

      exp_verbosity = <<-EOS
. = Tunit::TestCase::PassingTest#test_pass (0.00 s)
      EOS

      assert_equal exp_verbosity, io.string
    end
  end
end
