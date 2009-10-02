module Stubborn
  class MissedStubException < RuntimeError
    def initialize(object_or_label, method_name, args, result, suggester)
      object_label = object_or_label.respond_to?(:to_str) ? object_or_label : friendly_name(object_or_label)
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
      return object.inspect if object.respond_to?(:to_int) || object.is_a?(Hash)

      if object.is_a?(Class)
        object.name
      else
        "#{object.class.name.downcase.gsub(/\W+/, '_')}_instance"
      end
    end
  end
end
