require 'stubborn/suggesters/rspec_suggester'
require 'stubborn/proxy_for_instance'
require 'stubborn/proxy_for_class'

module Stubborn
  def self.should_be_stubbed(object, options = {})
    if object.is_a?(Class)
      ProxyForClass.new(object, options)
    else
      ProxyForInstance.new(object, options)
    end
  end

  def self.suggester=(suggester)
    @suggester = suggester
  end

  def self.suggester
    @suggester ||= Suggesters::RSpecSuggester
  end
end
