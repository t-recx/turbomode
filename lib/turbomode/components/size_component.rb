module Turbomode
  module Components
    class SizeComponent < Component
      attr_accessor :width
      attr_accessor :height

      def initialize
        @width, @height = 0, 0
      end
    end
  end
end
