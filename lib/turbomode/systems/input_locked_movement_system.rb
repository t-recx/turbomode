require 'turbomode/systems/system'

module Turbomode
  module Systems
    class InputLockedMovementSystem < System
      def initialize wrapper
        @wrapper = wrapper

        @allow_pause = true
      end

      def update entity_manager, messages
        entity_manager.select_with(:input_locked_movement, :position, :direction).each do |entity|
          ilm = entity.input_locked_movement
          p = entity.position

          unless ilm.movement_range
            if entity.has? :size
              ilm.movement_range = entity.size.width
            else
              ilm.movement_range = 1
            end
          end

          if ilm.movement_left <= 0 
            entity.state.state = :idle if entity.has? :state

            ilm.keys_movement.each do |key, direction|
              next unless @wrapper.button_down? key
              next if (@wrapper.milliseconds - ilm.keys_time_pressed[key]).abs < ilm.milliseconds_to_next

              entity.state.state = :moving if entity.has? :state
              entity.direction.direction = direction if entity.has? :direction
              ilm.movement_left = ilm.movement_range

              ilm.keys_time_pressed[key] = @wrapper.milliseconds
              break
            end
          end

          if ilm.movement_left > 0 and not ((@wrapper.milliseconds - ilm.movement_last_time).abs < ilm.movement_milliseconds_to_next)
            ilm.movement_left -= ilm.movement_unit

            p.x -= ilm.movement_unit if entity.direction.direction == :left
            p.x += ilm.movement_unit if entity.direction.direction == :right
            p.y -= ilm.movement_unit if entity.direction.direction == :up
            p.y += ilm.movement_unit if entity.direction.direction == :down

            ilm.movement_last_time = @wrapper.milliseconds
          end
        end
      end
    end
  end
end
