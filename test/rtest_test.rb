require_relative 'rtest/test_case'
require 'rtest'

class RtestTest < Rtest::TestCase
  def options
    { io: io }
  end

  def setup
    Rtest::Runnable.runnables = [PassingTest]
    self.io                   = StringIO.new ""
  end
  attr_accessor :io

  def test_run_gathers_reporters
    Rtest.run options
    assert_instance_of Rtest::CompoundReporter, Rtest.reporter
  end

  def test_dispatches_the_reporters_to_run
    Rtest.run options
    assert Rtest.reporter.passed?
  end
end
