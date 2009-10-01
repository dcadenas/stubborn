require 'test_helper'

def reset_test_api_class
  name = "TestApi"
  Object.__send__(:remove_const, name) if Object.const_defined?(name)
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
  Object.const_set(name, klass)
end

__END__
PENDING

Expectations do
  expect "instance_method_1 called" do
    api = TestApi.new   
    Stubborn.should_be_stubbed(api, :except => :instance_method_1)
    api.instance_method_1
  end

  expect Stubborn::MissedStubException do
    api = TestApi.new   
    Stubborn.should_be_stubbed(api, :except => :instance_method_1)
    api.instance_method_2
  end

  expect "instance_method_2 called" do
    api = TestApi.new   
    Stubborn.should_be_stubbed(api, :only => :instance_method_1)
    api.instance_method_2
  end

  expect Stubborn::MissedStubException do
    api = TestApi.new   
    Stubborn.should_be_stubbed(api, :only => :instance_method_1)
    api.instance_method_1
  end
end
