require_relative 'rtest/test_case'
require 'rtest'

class RtestTest < Rtest::TestCase
  def setup
    Rtest.io = io
    Rtest::Runnable.runnables = [PassingTest]
  end

  def test_run_gathers_reporters_under_compound_reporter
    Rtest.run
    assert_instance_of Rtest::CompoundReporter, Rtest.reporter
  end

  def test_run_dispatches_the_reporters_to_run
    Rtest.run
    assert Rtest.reporter.passed?
  end
end
