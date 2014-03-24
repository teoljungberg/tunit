require_relative './test_case'
require 'rtest/reporter'

module Rtest
  class ReporterTest < TestCase
    def setup
      self.reporter = Reporter.new
    end
    attr_accessor :reporter

    def test_record_passing_test
      reporter.record PassingTest.new(:test_even_eh).run

      assert_equal 1, reporter.count
      assert_equal 1, reporter.assertions
    end

    def test_record_failing_test
      reporter.record FailingTest.new(:test_fail_even_eh).run

      assert_equal 1, reporter.results.size
    end

    def test_passed_eh
      reporter.record PassingTest.new(:test_even_eh).run

      assert reporter.passed?
    end

    def test_passed_eh_is_only_for_passing_tests
      reporter.record FailingTest.new(:test_fail_even_eh).run

      refute reporter.passed?
    end
  end
end
