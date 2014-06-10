require_relative 'tunit/test_case'
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
    self.class.send :const_set, :ARGV,  ["--verbose", "-n", "test_pass"]
    Tunit.run ARGV

    assert Tunit.reporter.reporters.first.options[:verbose]
    assert_equal "test_pass", Tunit.reporter.reporters.first.options[:filter]
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
