require 'test_helper'

module FilteringTest; end

def reset_FilteringTest_api_class
  name = "Api"
  FilteringTest.send(:remove_const, name) if FilteringTest.const_defined?(name)
  klass =  Class.new do
    def instance_method_1
      "instance_method_1 called"
    end

    def instance_method_2
      "instance_method_2 called"
    end

    def self.class_method_1
      "class_method_1 called"
    end

    def self.class_method_2
      "class_method_2 called"
    end
  end
  FilteringTest.const_set(name, klass)
end

Expectations do
  expect "instance_method_1 called" do
    reset_FilteringTest_api_class
    api = FilteringTest::Api.new   
    api = Stubborn.should_be_stubbed(api, :except => :instance_method_1)
    api.instance_method_1
  end

  expect Stubborn::MissedStubException do
    reset_FilteringTest_api_class
    api = FilteringTest::Api.new   
    api = Stubborn.should_be_stubbed(api, :except => :instance_method_1)
    api.instance_method_2
  end

  expect "instance_method_2 called" do
    reset_FilteringTest_api_class
    api = FilteringTest::Api.new   
    api = Stubborn.should_be_stubbed(api, :only => :instance_method_1)
    api.instance_method_2
  end

  expect Stubborn::MissedStubException do
    reset_FilteringTest_api_class
    api = FilteringTest::Api.new   
    api = Stubborn.should_be_stubbed(api, :only => :instance_method_1)
    api.instance_method_1
  end
end
