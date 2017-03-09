module Turbomode
  class Component
    attr_accessor :dependencies

    def depends_upon(*dependencies)
      @dependencies = dependencies
    end

    def method_name
      underscore self.class.name.gsub("Component", "")
    end

    def underscore(text)
      text
        .gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
        .tr("-", "_")
        .downcase
    end
  end
end
