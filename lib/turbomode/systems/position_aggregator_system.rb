require 'turbomode/systems/system'

module Turbomode
  module Systems
    class PositionAggregatorSystem < System
      def update entity_manager, messages
        entity_manager.select_with(:position_aggregator, :position).each do |entity|
          entity.position_aggregator.entities.each do |aggregated_entity, location_offset|
            next unless aggregated_entity.has? :position

            aggregated_entity.position.x = entity.position.x + location_offset[:x]
            aggregated_entity.position.y = entity.position.y + location_offset[:y]
          end
        end
      end
    end
  end
end
