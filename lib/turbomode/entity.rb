require 'set'

module Turbomode
  class Entity
    attr_reader :components
    attr_accessor :on_add_component
    attr_accessor :on_delete_component

    alias_method :is?, :respond_to?
    alias_method :has?, :respond_to?

    def initialize *component_list
      @components = Set.new

      @on_add_component = nil
      @on_delete_component = nil

      merge(*component_list)
    end

    def add component
      components.add component 

      (class << self; self; end).class_eval do
        if method_defined? component.method_name
          remove_method component.method_name 
        end

        define_method(component.method_name) { component }
      end

      @on_add_component.call(component) if @on_add_component
    end

    def delete component
      components.delete component

      (class << self; self; end).class_eval do
        remove_method component.method_name
      end

      @on_delete_component.call(component) if @on_delete_component
    end

    def merge *components
      components.each do |component|
        add component
      end
    end

    def subtract *components
      components.each { |component| delete component }
    end

    def check_dependencies
      components.each { |component| check_component_dependencies component }
    end

    def check_component_dependencies component
      return unless component.dependencies

      component
      .dependencies
      .select { |d| not self.has? d }
      .each do |d|
        puts "(#{self}) Warning: #{component.class.name} depends on #{d}" 
      end
    end
  end
end
