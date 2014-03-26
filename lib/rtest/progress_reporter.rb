require 'rtest/reporter'

module Rtest
  class ProgressReporter < Reporter
    def record result
      io.print result.code
    end
  end
end
