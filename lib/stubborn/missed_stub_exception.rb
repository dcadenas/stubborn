module Stubborn
  class MissedStubException < RuntimeError
    def initialize(object_or_label, method_name, args, result, suggester)
      @suggestions = suggester.suggestions(object_or_label, method_name, args, result)
    end

    def message
      "You've missed adding a stub. Consider this suggestion#{@suggestions.size > 1 ? "s" : ""}:\n#{@suggestions.join("\n")}"
    end
  end
end
