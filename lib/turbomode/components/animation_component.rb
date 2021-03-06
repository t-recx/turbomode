module Turbomode
  module Components
    class AnimationComponent < Component
      attr_accessor :frames # hash of {STATE => { DIRECTION => [ {DURATION =>, SPRITE =>} ] } }
      attr_accessor :current_frame_position
      attr_accessor :last_time_frame_update

      def current_animation(state, direction)
        f = @frames

        if state
          f = f[state]
        end

        if direction
          f = f[direction]
        end

        return f
      end

      def current_frame(state, direction)
        current_animation(state, direction)[@current_frame_position]
      end

      def initialize
        depends_upon :sprite

        @frames = Hash.new
        @current_frame_position = 0
        @last_time_frame_update = 0
      end
    end
  end
end
