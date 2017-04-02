require 'turbomode/systems/system'

module Turbomode
  module Systems
    class PositionHomologatorSystem < System
      def update entity_manager, messages
        entity_manager.select_with(:position, :position_homologator).each do |e|
          e.position.x = (e.position.x / e.position_homologator.tile_width).floor * e.position_homologator.tile_width 
          e.position.y = (e.position.y / e.position_homologator.tile_height).floor * e.position_homologator.tile_height
        end
      end
    end
  end
end
