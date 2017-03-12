require 'turbomode/systems/system'

module Turbomode
  module Systems
    class CollisionSystem < System
      def update entity_manager, messages
        entities = entity_manager.select_with(:collision, :position)
          
        entities.each do |e|
          check_collision e, entities
        end
      end

      def check_collision entity, entities
        entity.collision.entities_colliding.clear

        set_bounding_defaults_when_empty entity

        entities.each do |another_entity|
          next if entity == another_entity

          if another_entity.collision.entities_colliding.include? entity
            entity.collision.entities_colliding.add another_entity
            next
          end

          entity.collision.entities_colliding.add(another_entity) if colliding entity, another_entity
        end
      end

      def set_bounding_defaults_when_empty entity
        collision = entity.collision

        collision.br_x = 0 unless collision.br_x
        collision.br_y = 0 unless collision.br_y

        return unless entity.has? :size

        size = entity.size

        collision.br_width = size.width unless collision.br_width
        collision.br_height = size.height unless collision.br_height
      end

      def colliding first, second
        pc = first.position
        cc = first.collision
        oe_pc = second.position
        oe_cc = second.collision

        return true if not (left(oe_pc, oe_cc) > right(pc, cc) || right(oe_pc, oe_cc) < left(pc, cc) || top(oe_pc, oe_cc) > bottom(pc, cc) || bottom(oe_pc, oe_cc) < top(pc, cc))

        return false
      end

      def left(pc, cc)
        pc.x + cc.br_x 
      end

      def right(pc, cc)
        pc.x + cc.br_x + cc.br_width - 1
      end

      def top(pc, cc)
        pc.y + cc.br_y 
      end

      def bottom(pc, cc)
        pc.y + cc.br_y + cc.br_height - 1
      end
    end
  end
end
