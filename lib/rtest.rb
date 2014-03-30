require "rtest/compound_reporter"
require "rtest/summary_reporter"
require "rtest/progress_reporter"
require "rtest/test"
require "rtest/version"

module Rtest
  meta_klass = (class << self; self; end)
  meta_klass.send :attr_accessor, :reporter
  meta_klass.send :attr_accessor, :options

  # Let io be override-able in tests
  meta_klass.send :attr_accessor, :io
  self.io = $stdout

  # Make sure that autorun is loaded after each test class has been loaded
  meta_klass.send :attr_accessor, :installed_at_exit
  self.installed_at_exit ||= false

  def self.autorun
    at_exit {
      next if $! and not ($!.kind_of? SystemExit and $!.success?)

      exit_code = nil

      at_exit {
        exit exit_code || false
      }

      exit_code = Rtest.run
    } unless self.installed_at_exit
    self.installed_at_exit = true
  end

  def self.run options = {}
    self.options = options
    process_options!

    self.reporter = CompoundReporter.new
    reporter << SummaryReporter.new(self.options[:io], self.options)
    reporter << ProgressReporter.new(self.options[:io], self.options)

    reporter.start
    dispatch! reporter
    reporter.report

    reporter.passed?
  end

  private

  def self.dispatch! reporter
    Runnable.runnables.each do |runnable|
      runnable.runnable_methods.map { |test| reporter.record runnable.new(test).run }
    end
  end

  def self.process_options!
    io           = options.fetch(:io) { $stdout }
    self.options = { :io => io }
  end
end
