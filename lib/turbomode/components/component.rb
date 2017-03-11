module Turbomode
  module Components
    class Component
      attr_accessor :dependencies

      def depends_upon *list
        @dependencies = list
      end

      def method_name
        underscore (self.class.name.split('::').last || '').gsub("Component", "")
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
end
