require 'rtest/reporter'

module Rtest
  class ProgressReporter < Reporter
    def record result
      io.print result.code
      io.print " = %s#%s (%.2f s)" % [result.class, result.name, result.time] if options[:verbose]
      io.puts if options[:verbose]
    end
  end
end
