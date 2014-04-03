module Rtest
  class Assertion < Exception
    def error
      self
    end

    def location
      last_before_assertion = ""
      self.backtrace.reverse_each do |line|
        break if line =~ /in .(assert|refute|pass|raise)/
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

  class Empty < Assertion
    # Where was the empty test
    def location
      obj = message.match(/'(.*)'/)[1]
      klass, meth = obj.split("#")
      method_obj = eval(klass).new.method meth
      method_obj.source_location.join(":")
    end

    def result_code
      "_"
    end

    def result_label
      "Empty"
    end
  end

  class Skip < Assertion
    def result_label
      "Skipped"
    end
  end
end
