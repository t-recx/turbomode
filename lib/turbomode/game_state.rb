module Turbomode
  class GameState
    def initialize wrapper, systems, messages, entity_manager, camera_helper = nil
      @wrapper = wrapper
      @systems = systems
      @messages = messages
      @entity_manager = entity_manager
      @camera_helper = camera_helper
    end

    def update
      @systems.each do |s|
        next unless s.on
        next if s.paused

        next unless s.time_to_next_update == 0 or @wrapper.milliseconds > s.last_time_updated + s.time_to_next_update

        s.update @entity_manager, @messages if s.respond_to? :update

        s.last_time_updated = @wrapper.milliseconds
      end
    end
    
    def draw
      if @camera_helper
        scroll_x, scroll_y = @camera_helper.position
      else
        scroll_x, scroll_y = 0, 0
      end

      @systems.each do |s|
        next unless s.on
        next unless s.respond_to? :draw

        @wrapper.translate(-scroll_x, -scroll_y) { s.draw(@entity_manager, true) }

        s.draw(@entity_manager, false) 
      end
    end

    def pause
      @systems.map(&:pause)
    end

    def resume
      @systems.map(&:resume)
    end
  end
end
