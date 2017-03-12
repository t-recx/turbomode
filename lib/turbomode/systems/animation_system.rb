require 'turbomode/systems/system'

module Turbomode
  module Systems
    class AnimationSystem < System
      def initialize wrapper
        @wrapper = wrapper
        super()
      end

      def update entity_manager, messages
        entity_manager.select_with(:animation, :sprite).each do |e|
          state = e.state ? e.state.state : :other
          direction = e.direction ? e.direction.direction : :other

          e.animation.current_frame_position = 0 unless e.animation.current_frame(state, direction)

          if @wrapper.milliseconds > e.animation.last_time_frame_update + e.animation.current_frame(state, direction)[:duration] then
            e.animation.current_frame_position += 1
            e.animation.last_time_frame_update = @wrapper.milliseconds

            e.animation.current_frame_position = 0 unless e.animation.current_frame(state, direction)

            e.sprite.sprite = e.animation.current_frame(state, direction)[:sprite]
          end
        end
      end
    end
  end
end
