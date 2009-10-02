require 'suggesters/rspec_suggester'
require 'missed_stub_exception'

module Stubborn
  def self.should_be_stubbed(object, options = {})
    if object.is_a?(Class)
      ProxyForClass.new(object, options)
    else
      ProxyForInstance.new(object, options)
    end
  end

  class ProxyForInstance
    instance_methods.each do |sym|
      undef_method(sym) unless sym.to_s =~ /__/ || sym.to_s == "send"
    end

    def initialize(proxy_target, options = {})
      options = {:class => proxy_target.class}.merge(options)
      @label = options[:label]
      @proxy_target = proxy_target
      @klass = options[:class]
      @methods_to_skip = ["respond_to?", "is_a?", "kind_of?", "equal?", "eql?", "==", "==="]
    end

    def class
      @klass
    end

    def method_missing(method_name, *args, &block)
      result = @proxy_target.send(method_name, *args, &block)
      return result if @methods_to_skip.include?(method_name.to_s)
      raise MissedStubException.new(@label || @proxy_target, method_name, args, result, Suggesters::RSpecSuggester)
    end
  end

  class ProxyForClass < ProxyForInstance
    def initialize(proxy_target, options = {})
      super
      redefine_const(proxy_target, self) unless proxy_target.name.strip.empty?
    end

    def name
      @proxy_target.name
    end

    def new(*args, &block)
      new_instance = @proxy_target.new(*args, &block)
      ProxyForInstance.new(new_instance, :class => self)
    end

  private
    def redefine_const(const, value)
      const_parts = const.name.split('::')
      const_name = const_parts.pop
      parent_const = const_parts.inject(Object){|a, c| a.const_get(c) }

      parent_const.__send__(:remove_const, const_name) if parent_const.const_defined?(const_name)
      parent_const.const_set(const_name, value)
    end
  end
end
