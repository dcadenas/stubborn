require 'test_helper'

class AClass; end
class Api; end

include Stubborn

Expectations do
  expect "You've missed adding a stub. Consider this suggestions:\napi_instance.stub!(:method).with(123, AClass, \"hi\", {1=>2}).and_return(aclass_instance)\napi_instance.stub!(:method).and_return(aclass_instance)" do
    MissedStubException.new(Api.new, :method, [123, AClass,"hi", {1 => 2}], AClass.new, Suggesters::RSpecSuggester).message
  end

  expect "You've missed adding a stub. Consider this suggestion:\napi_instance.stub!(:method).and_return(aclass_instance)" do
    MissedStubException.new(Api.new, :method, [], AClass.new, Suggesters::RSpecSuggester).message
  end

  expect "You've missed adding a stub. Consider this suggestion:\nApi.singleton.stub!(:method).and_return(aclass_instance)" do
    MissedStubException.new("Api.singleton", :method, [], AClass.new, Suggesters::RSpecSuggester).message
  end

  expect "You've missed adding a stub. Consider this suggestion:\nApi.singleton.stub!(:method)" do
    MissedStubException.new("Api.singleton", :method, [], nil, Suggesters::RSpecSuggester).message
  end
end

