module Stubborn
  class ProxyForModule < ProxyForInstance
    def initialize(proxy_target, options = {})
      super
      redefine_const(proxy_target, self) unless proxy_target.name.strip.empty?
    end

    def name
      @proxy_target.name
    end

    def new(*args, &block)
      new_instance = @proxy_target.new(*args, &block)
      raise_missed_stub_exception("new", args, new_instance) if @only_methods.include?("new") && !@methods_to_skip.include?("new")
      options = {:class => self}

      if @instance_methods
        options[:only] = @instance_methods[:only]
        options[:except] = @instance_methods[:except]
      end

      ProxyForInstance.new(new_instance, options)
    end

    def redefine_const(const, value)
      const_parts = const.name.split('::')
      const_name = const_parts.pop
      parent_const = const_parts.inject(Object){|constant_chain, constant| constant_chain.const_get(constant) }

      parent_const.__send__(:remove_const, const_name) if parent_const.const_defined?(const_name)
      parent_const.const_set(const_name, value)
    end
  end
end
