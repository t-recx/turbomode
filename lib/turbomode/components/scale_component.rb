module Turbomode
  module Components
    class ScaleComponent < Component
      attr_accessor :scale_x
      attr_accessor :scale_y

      def initialize
        @scale_x, @scale_y = 1, 1
      end
    end
  end
end
