require 'test_helper'

def reset_test_api_class
  name = "TestApi"
  Object.__send__(:remove_const, name) if Object.const_defined?(name)
  klass =  Class.new do
    def plus_one(number)
      number + 1
    end

    def self.plus_two(number)
      number + 2
    end
  end
  Object.const_set(name, klass)
end

Expectations do
  expect 2 do
    reset_test_api_class
    TestApi.new.plus_one(1)
  end

  expect "TestApi" do
    reset_test_api_class
    api = TestApi.new
    api = Stubborn.should_be_stubbed(api)
    api.class.name
  end

  expect true do
    reset_test_api_class
    api = TestApi.new
    api = Stubborn.should_be_stubbed(api)
    api.respond_to?(:plus_one)
  end

  expect Stubborn::MissedStubException do
    reset_test_api_class
    api = TestApi.new
    api = Stubborn.should_be_stubbed(api)
    api.plus_one(1) 
  end

  expect 3 do
    reset_test_api_class
    api = TestApi.new
    api = Stubborn.should_be_stubbed(api)
    api.class.plus_two(1) 
  end

  expect "You've missed adding a stub. Consider this suggestions:\ntestapi_instance.stub!(:plus_one).with(0).and_return(1)\ntestapi_instance.stub!(:plus_one).and_return(1)" do
    reset_test_api_class
    api = TestApi.new
    api = Stubborn.should_be_stubbed(api)
    message = ""
    begin
      api.plus_one(0)
    rescue => e 
      message = e.message
    end
  end

  expect "You've missed adding a stub. Consider this suggestions:\nApi.singleton.stub!(:plus_one).with(0).and_return(1)\nApi.singleton.stub!(:plus_one).and_return(1)" do
    reset_test_api_class
    api = TestApi.new
    api = Stubborn.should_be_stubbed(api, :label => "Api.singleton")
    message = ""
    begin
      api.plus_one(0)
    rescue => e 
      message = e.message
    end
  end

  expect "TestApi" do
    reset_test_api_class
    Stubborn.should_be_stubbed(TestApi)
    api = TestApi.new
    api.class.name
  end

  expect true do
    reset_test_api_class
    Stubborn.should_be_stubbed(TestApi)
    api = TestApi.new
    api.respond_to?(:plus_one)
  end

  expect Stubborn::MissedStubException do
    reset_test_api_class
    Stubborn.should_be_stubbed(TestApi)
    api = TestApi.new
    api.plus_one(1) 
  end

  expect Stubborn::MissedStubException do
    reset_test_api_class
    Stubborn.should_be_stubbed(TestApi)
    api = TestApi.new
    api.class.plus_two(1) 
  end

  expect "You've missed adding a stub. Consider this suggestions:\ntestapi_instance.stub!(:plus_one).with(0).and_return(1)\ntestapi_instance.stub!(:plus_one).and_return(1)" do
    reset_test_api_class
    Stubborn.should_be_stubbed(TestApi)
    message = ""
    api = TestApi.new
    begin
      api.plus_one(0)
    rescue => e 
      message = e.message
    end
  end
end


