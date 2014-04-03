require_relative 'tunit/test_case'
require 'tunit'

class TunitTest < Tunit::TestCase
  def setup
    Tunit.io = io
    Tunit::Runnable.runnables = [PassingTest]
  end

  def test_run_gathers_reporters_under_compound_reporter
    Tunit.run
    assert_instance_of Tunit::CompoundReporter, Tunit.reporter
  end

  def test_run_dispatches_the_reporters_to_run
    Tunit.run
    assert Tunit.reporter.passed?
  end
end
