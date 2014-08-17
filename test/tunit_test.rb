require 'test_helper'
require 'tunit'

class TunitTest < Tunit::TestCase
  def setup
    Tunit::Runnable.runnables = [PassingTest]
    Tunit.io                  = io
  end

  def test_autorun_sets_installed_at_exit
    refute Tunit.installed_at_exit
    Tunit.autorun

    assert Tunit.installed_at_exit
  end

  def test_run_processes_arguments
    options = ["--verbose", "-n", "test_pass"]
    Tunit.run options
    reporter = Tunit.reporter

    assert reporter.options[:verbose]
    assert_equal "test_pass", reporter.options[:filter]
  end

  def test_run_gathers_reporters_under_the_god_reporter
    Tunit.run

    assert_instance_of Tunit::GodReporter, Tunit.reporter
  end

  def test_run_is_happy_with_passes
    assert Tunit.run
  end

  def test_run_is_sad_with_failures
    Tunit::Runnable.runnables = [FailingTest]

    refute Tunit.run
  end

  def test_run_is_meh_with_skipps
    Tunit::Runnable.runnables = [SkippedTest]

    assert Tunit.run
  end
end
