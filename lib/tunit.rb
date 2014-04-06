require "tunit/compound_reporter"
require "tunit/summary_reporter"
require "tunit/progress_reporter"
require "tunit/version"

require 'optparse'

module Tunit
  meta_klass = (class << self; self; end)
  meta_klass.send :attr_accessor, :reporter

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

      exit_code = Tunit.run ARGV
    } unless self.installed_at_exit
    self.installed_at_exit = true
  end

  def self.run args = []
    options = process_args! args

    self.reporter = CompoundReporter.new
    reporter << SummaryReporter.new(options[:io], options)
    reporter << ProgressReporter.new(options[:io], options)

    reporter.start
    dispatch! reporter, options
    reporter.report

    reporter.passed?
  end

  private

  def self.dispatch! reporter, options
    Runnable.runnables.each do |runnable|
      runnable.run reporter, options
    end
  end

  def self.process_args! args = []
    options = { io: io }

    OptionParser.new do |opts|
      opts.banner  = "Tunit options:"
      opts.version = Tunit::VERSION

      opts.on "-h", "--help", "Display this help." do
        puts opts
        exit
      end

      opts.on "-n", "--name PATTERN", "Filter run on /pattern/ or string." do |pattern|
        options[:filter] = pattern
      end

      opts.on "-v", "--verbose", "Verbose. Show progress processing files." do
        options[:verbose] = true
      end

      opts.parse! args
    end

    options
  end
end
