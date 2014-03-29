require 'rtest/reporter'

module Rtest
  class SummaryReporter < Reporter
    def start
      super

      io.puts "# Running:"
      io.puts
    end

    def report
      super

      io.puts
      io.puts
      io.puts statistics
      io.puts aggregated_results
      io.puts
      io.puts summary
    end

    private

    def statistics
      "Finished in %.6fs, %.4f runs/s, %.4f assertions/s." %
        [total_time, count / total_time, assertions / total_time]
    end

    def aggregated_results
      filtered_results = results.dup

      filtered_results.each_with_index.map do |result, index|
        "\n%3d) %s" % [index+1, result]
      end.join
    end

    def summary
      "%d runs, %d assertions, %d failures, %d skips" %
        [count, assertions, failures, skips]
    end
  end
end
