require 'turbomode/systems/system'

module Turbomode
  module Systems
    class PlatformSystem < System
      def update entity_manager, messages
        entity_manager.select_with(:position, :collision, :position_aggregator, :platform).each do |e|
          pae = e.position_aggregator.entities
          ec = e.collision.entities_colliding

          pae.reject! { |k, v| not_present(k, on: ec) or ec.any? { |x| state_does_not_allow_transport(x) } }

          ec
          .reject { |x| already_aggregated(x, pae) }
          .select { |x| can_be_transported(x) } 
          .reject { |x| state_does_not_allow_transport(x) }
          .map { |x| pae[x] = position_hash(e, x) }
        end
      end

      def already_aggregated e, entities
        entities.any? { |k, v| e == k }
      end

      def not_present e, on:
        !on.any? { |y| y == e } 
      end

      def state_does_not_allow_transport e
        e.has? :state and e.is? :platform_transportable and e.platform_transportable.except_on_states.any? { |s| s == e.state.state } 
      end

      def position_hash e, te
        { x: (te.position.x - e.position.x), y: (te.position.y - e.position.y) }
      end

      def can_be_transported e
        e.is? :platform_transportable and e.has? :position 
      end
    end
  end
end
