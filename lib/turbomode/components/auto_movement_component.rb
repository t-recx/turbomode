module Turbomode
  module Components
    class AutoMovementComponent < Component
      attr_accessor :offset_x
      attr_accessor :offset_y
      attr_accessor :milliseconds_to_next
      attr_accessor :milliseconds_last

      def initialize
        depends_upon :position

        @offset_x, @offset_y, @milliseconds_last = 0, 0, 0
      end
    end
  end
end

