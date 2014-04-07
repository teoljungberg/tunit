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

  def test_run_gathers_reporters_under_compound_reporter
    Tunit.run

    assert_instance_of Tunit::CompoundReporter, Tunit.reporter
  end

  def test_run_dispatches_the_reporters_to_run
    Tunit.run
    assert Tunit.reporter.passed?
  end
end
