module Stubborn
  module Suggesters
    module RSpecSuggester
      def self.suggestions(object_or_label, method_name, args, result_object)
        object_label = object_or_label.respond_to?(:to_str) ? object_or_label : friendly_name(object_or_label)
        args = args.map{|a| friendly_name(a)}.join(", ")
        result = friendly_name(result_object)

        with = args.strip.empty? ? nil : ".with(#{args})"

        return_method = if result_object.is_a?(Exception)
                          ".and_raise(#{result_object.class})"
                        elsif result_object.nil?
                          nil
                        else
                          ".and_return(#{result})"
                        end

        suggestions = []
        suggestions << "#{object_label}.stub!(:#{method_name})#{with}#{return_method}"
        suggestions << "#{object_label}.stub!(:#{method_name})#{return_method}"
        suggestions.uniq
      end

    private
      def self.friendly_name(object)
        return "\"#{object}\"" if object.respond_to?(:to_str)
        return object.inspect if object.respond_to?(:to_int) || object.is_a?(Hash) || object.nil? || object == true || object == false

        if object.is_a?(Class)
          object.name
        else
          "#{object.class.name.downcase.gsub(/\W+/, '_')}_instance"
        end
      end
    end
  end
end
