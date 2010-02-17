require 'stubborn/missed_stub_exception'

module Stubborn
  class ProxyForInstance
    instance_methods.each do |sym|
      undef_method(sym) unless sym.to_s =~ /__/ || sym.to_s == "send"
    end

    def initialize(proxy_target, options = {})
      @proxy_target = proxy_target

      options[:except] = [options[:except]].flatten.compact.map{|m| m.to_s}
      options[:only] = [options[:only]].flatten.compact.map{|m| m.to_s}
      options = {:class => proxy_target.class}.merge(options)
      @label = options[:label]
      @class = options[:class]
      @methods_to_skip = ["respond_to?", "is_a?", "kind_of?", "equal?", "eql?", "==", "==="] + options[:except]
      @only_methods = options[:only]
    end

    def class
      @class
    end

    def method_missing(method_name, *args, &block)
      were_we_already_processing_a_missed_stub = Thread.current["inside_missed_stub"]
      Thread.current["inside_missed_stub"] = true
      result = @proxy_target.send(method_name, *args, &block)
      return result if !@only_methods.include?(method_name.to_s) && !@only_methods.empty? || @methods_to_skip.include?(method_name.to_s) || were_we_already_processing_a_missed_stub
      raise_missed_stub_exception(method_name, args, result)
    ensure
      Thread.current["inside_missed_stub"] = false unless were_we_already_processing_a_missed_stub
    end

    private
    def raise_missed_stub_exception(method_name, args, result)
      raise MissedStubException.new(@label || @proxy_target, method_name, args, result, Stubborn.suggester)
    end
  end
end
