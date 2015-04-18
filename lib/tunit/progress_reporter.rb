require 'tunit/reporter'

module Tunit
  class ProgressReporter < Reporter
    def record result
      io.print result.code
      print_progress result if options[:verbose]
    end

    private

    def print_progress result
      io.print " = %s#%s (%.2f s)" %
        [result.class, result.name, result.time]
      io.puts
    end
  end
end
