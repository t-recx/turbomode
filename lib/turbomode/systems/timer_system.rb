require 'turbomode/systems/system'

module Turbomode
  module Systems
    class TimerSystem < System
      attr_accessor :time_paused

      def initialize wrapper
        @wrapper = wrapper

        super()

        @allow_pause = true

        @time_paused = nil
      end

      def update entity_manager, messages
        entity_manager.select_with(:timer).each do |entity|
          next unless entity.timer.on

          entity.timer.milliseconds_last = @wrapper.milliseconds unless entity.timer.milliseconds_last

          if @time_paused then
            entity.timer.milliseconds_last += @wrapper.milliseconds - @time_paused 
            @time_paused = nil
          end

          next if (@wrapper.milliseconds - entity.timer.milliseconds_last).abs < entity.timer.milliseconds_to_next

          entity.timer.value += entity.timer.change
          entity.timer.milliseconds_last = @wrapper.milliseconds
        end
      end

      def pause
        super()

        @time_paused = @wrapper.milliseconds
      end
    end
  end
end
