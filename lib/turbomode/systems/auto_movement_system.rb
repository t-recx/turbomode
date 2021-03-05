require 'turbomode/systems/system'

module Turbomode
  module Systems
    class AutoMovementSystem < System
      attr_accessor :time_paused

      def initialize wrapper
        @wrapper = wrapper

        super()

        @allow_pause = true

        @time_paused = nil
      end

      def update entity_manager, messages
        entity_manager.select_with(:auto_movement).each do |entity|
          next unless entity.auto_movement.on

          entity.auto_movement.milliseconds_last = @wrapper.milliseconds unless entity.auto_movement.milliseconds_last

          if @time_paused then
            entity.auto_movement.milliseconds_last += @wrapper.milliseconds - @time_paused 
            @time_paused = nil
          end

          next if (@wrapper.milliseconds - entity.auto_movement.milliseconds_last).abs < entity.auto_movement.milliseconds_to_next

          entity.position.x += entity.auto_movement.offset_x
          entity.position.y += entity.auto_movement.offset_y
          entity.auto_movement.milliseconds_last = @wrapper.milliseconds
        end
      end

      def pause
        super()

        @time_paused = @wrapper.milliseconds
      end
    end
  end
end

