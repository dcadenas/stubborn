module Stubborn
  class MissedStubException < RuntimeError
    def initialize(object, method_name, args, result, suggester)
      object_label = friendly_name(object)
      args = args.map{|a| friendly_name(a)}.join(", ")
      result = friendly_name(result)

      @suggestions = suggester.suggestions(object_label, method_name, args, result)
    end

    def message
      "You've missed adding a stub. Consider this suggestion#{@suggestions.size > 1 ? "s" : ""}:\n#{@suggestions.join("\n")}"
    end
    
  private
    def friendly_name(object)
      return "\"#{object}\"" if object.respond_to?(:to_str)
      return object.inspect if object.respond_to?(:to_int)

      if object.is_a?(Class)
        object.name
      else
        "#{object.class.name.downcase}_instance"
      end
    end
  end
end
