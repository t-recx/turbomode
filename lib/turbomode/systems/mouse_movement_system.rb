require 'turbomode/systems/system'

module Turbomode
  module Systems
    class MouseMovementSystem < System
      def initialize wrapper, camera_helper
        @wrapper = wrapper
        @camera_helper = camera_helper

        super()

        @allow_pause = true
      end

      def update entity_manager, messages
        scroll_x, scroll_y = @camera_helper.position

        entity_manager.select_with(:mouse_movement, :position).each do |entity|
          entity.position.x = @wrapper.get_mouse_x
          entity.position.y = @wrapper.get_mouse_y

          if entity.is? :scrollable then
            entity.position.x += scroll_x
            entity.position.y += scroll_y
          end
        end
      end
    end
  end
end
