require 'turbomode/systems/system'

module Turbomode
  module Systems
    class InputSystem < System
      def initialize wrapper
        @wrapper = wrapper

        super()

        @allow_pause = true
      end

      def update entity_manager, messages
        entity_manager.select_with(:input, :position).each do |entity|
          entity.state.state = :idle if entity.has? :state

          entity
          .input
          .keys_action
          .each do |key, value|
            next unless @wrapper.button_down? key

            entity.state.state = :moving if entity.has? :state
            entity.direction.direction = value[:direction] if value[:direction] and entity.has? :direction

            next if entity.input.keys_time_pressed[key] && (@wrapper.milliseconds - entity.input.keys_time_pressed[key]).abs < (value[:milliseconds_to_next] || entity.input.milliseconds_to_next)

            entity.position.x += value[:x] if value[:x]
            entity.position.y += value[:y] if value[:y]

            messages.push({ message: value[:message], sender: entity }) if value[:message]

            entity.input.keys_time_pressed[key] = @wrapper.milliseconds
          end
        end
      end
    end
  end
end
