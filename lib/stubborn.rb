begin
  require 'proxen' 
rescue LoadError
  puts "You need to install the proxen gem: sudo gem install nakajima-proxen -s http://gems.github.com"
  exit
end

require 'suggesters/rspec_suggester'
require 'missed_stub_exception'

module Stubborn
  def self.should_be_stubbed(object)
    if object.is_a?(Class)
      ProxyForClass.new(object)
    else
      ProxyForInstance.new(object)
    end
  end

  class ProxyForInstance
    attr_accessor :proxy_target
    proxy_to :proxy_target, :blank_slate => true

    def initialize(proxy_target, klass = proxy_target.class)
      @proxy_target = proxy_target
      @klass = klass
      @methods_to_skip = ["respond_to?", "is_a?"]
    end

    def class
      @klass
    end

    def method_missing(method_name, *args, &block)
      result = @proxy_target.send(method_name, *args, &block)
      return result if @methods_to_skip.include?(method_name.to_s)
      raise MissedStubException.new(@proxy_target, method_name, args, result, Suggesters::RSpecSuggester)
    end
  end

  class ProxyForClass < ProxyForInstance
    def initialize(proxy_target)
      super
      redefine_const(proxy_target.name, self) unless proxy_target.name.strip.empty?
    end

    def name
      @proxy_target.name
    end

    def new(*args, &block)
      new_instance = @proxy_target.new(*args, &block)
      ProxyForInstance.new(new_instance, self)
    end

  private
    def redefine_const(name, value)
      Object.__send__(:remove_const, name) if Object.const_defined?(name)
      Object.const_set(name, value)
    end
  end
end
