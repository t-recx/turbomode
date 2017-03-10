module Turbomode
  class GameState
    def initialize wrapper, systems, messages, entity_manager, camera_helper
      @wrapper = wrapper
      @systems = systems
      @messages = messages
      @entity_manager = entity_manager
      @camera_helper = camera_helper
    end

    def update
      @systems.each do |system|
        next unless system.on
        next if system.paused

        next unless system.time_to_next_update == 0 or @wrapper.milliseconds > system.last_time_updated + system.time_to_next_update

        system.update @entity_manager, @messages if system.respond_to? :update

        system.last_time_updated = @wrapper.milliseconds
      end
    end
  end
end
