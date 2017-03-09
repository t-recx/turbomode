require 'set'

module Turbomode
  class Entity
    attr_reader :components
    attr_accessor :on_add_component

    def initialize
      @components = Set.new
    end

    def add(component)
      @components.add(component) 

      (class << self; self; end).class_eval do
        define_method(component_method_name(component)) { component }
      end

      @on_add_component.call if @on_add_component
    end

private
    def self.component_method_name(component)
      underscore component.class.name.gsub("Component", "")
    end

    def self.underscore(text)
      text
        .gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
        .tr("-", "_")
        .downcase
    end
  end
end
