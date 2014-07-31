require 'tunit/reporter'

module Tunit
  class SummaryReporter < Reporter
    SKIP_MSG = "\n\nYou have skipped tests. Run with --verbose for details."

    def start
      super

      io.puts "Run options: #{options.inspect}"
      io.puts
      io.puts "# Running:"
      io.puts
    end

    def report
      super

      io.puts unless options[:verbose]
      io.puts
      io.puts statistics
      io.puts aggregated_results
      io.puts summary
    end

    private

    def statistics
      "Finished in %.6fs, %.4f runs/s, %.4f assertions/s." %
        [total_time, count / total_time, assertions / total_time]
    end

    def aggregated_results
      filtered_results = results.dup
      filtered_results.reject!(&:skipped?) unless options[:verbose]

      filtered_results.each_with_index.map do |result, index|
        "\n%3d) %s" % [index + 1, result]
      end.join + "\n"
    end

    def summary
      extra = ""
      extra << SKIP_MSG if results.any?(&:skipped?) && !options[:verbose]

      "%d runs, %d assertions, %d failures, %d errors, %d skips%s" %
        [count, assertions, failures, errors, skips, extra]
    end
  end
end
