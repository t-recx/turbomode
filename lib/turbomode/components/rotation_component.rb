module Turbomode
  module Components
    class RotationComponent < Component
      attr_accessor :angle
      attr_accessor :center_x
      attr_accessor :center_y

      def initialize
        @angle = 0
        @center_x = 0.5
        @center_y = 0.5
      end
    end
  end
end
