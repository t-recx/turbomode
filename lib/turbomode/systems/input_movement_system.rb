require 'turbomode/systems/system'

module Turbomode
  module Systems
    class InputMovementSystem < System
      def initialize wrapper
        @wrapper = wrapper

        super()

        @allow_pause = true
      end

      def update entity_manager, messages
        entity_manager.select_with(:input_movement, :position).each do |entity|
          entity.state.state = :idle if entity.has? :state

          entity
          .input_movement
          .keys_movement
          .each do |key, value|
            next unless @wrapper.button_down? key

            entity.state.state = :moving if entity.has? :state
            entity.direction.direction = value[:direction] if entity.has? :direction

            next if entity.input_movement.keys_time_pressed[key] && (@wrapper.milliseconds - entity.input_movement.keys_time_pressed[key]).abs < entity.input_movement.milliseconds_to_next

            entity.position.x += value[:x]
            entity.position.y += value[:y]

            entity.input_movement.keys_time_pressed[key] = @wrapper.milliseconds
          end
        end
      end
    end
  end
end
