module Stubborn
  module Suggesters
    module RSpecSuggester
      def self.suggestions(object_label, method_name, args, result)
        with = args.strip.empty? ? nil : ".with(#{args})"
        and_return = result == "nil" ? nil : ".and_return(#{result})"
        suggestions = []
        suggestions << "#{object_label}.stub!(:#{method_name})#{with}#{and_return}"
        suggestions << "#{object_label}.stub!(:#{method_name})#{and_return}"
        suggestions.uniq
      end
    end
  end
end
