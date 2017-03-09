require 'set'

module Turbomode
  class Entity
    attr_reader :components
    attr_accessor :on_add_component
    attr_accessor :on_delete_component

    def initialize
      @components = Set.new
    end

    def add(component)
      components.add(component) 

      (class << self; self; end).class_eval do
        define_method(component.method_name) { component }
      end

      @on_add_component.call if @on_add_component
    end

    def delete(component)
      components.delete(component)

      (class << self; self; end).class_eval do
        remove_method component.method_name
      end

      @on_delete_component.call if @on_delete_component
    end
  end
end
