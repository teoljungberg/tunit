module Tunit
  class Assertion < Exception
    def error
      self
    end

    def location
      last_before_assertion = ""
      backtrace.reverse_each do |line|
        break if line =~ /in .(assert|refute|skip|raise|fail)/
        last_before_assertion = line
      end
      last_before_assertion.sub(/:in .*$/, "")
    end

    def result_code
      result_label[0, 1]
    end

    def result_label
      "Failure"
    end
  end

  class Skip < Assertion
    def result_label
      "Skipped"
    end
  end

  class Error < Assertion
    def result_label
      "Error"
    end
  end

  class NotAnAssertion < Error
  end

  class UnexpectedError < Error
    def initialize exception
      super
      @exception = exception
    end
    attr_reader :exception

    def location
      last_before_assertion = ""
      exception.backtrace.reverse_each do |line|
        break if line =~ /in .(assert|refute|skip|raise|fail)/
        last_before_assertion = line
      end
      last_before_assertion.sub(/:in .*$/, "")
    end
  end
end
