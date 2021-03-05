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

        entity.collision.entities_colliding = entities
          .reject { |x| x == entity }
          .select { |e| colliding(entity, e)}
      end

      def colliding first, second
        pc = first.position
        cc = first.collision
        oe_pc = second.position
        oe_cc = second.collision

        pc_x = pc.x
        pc_y = pc.y
        cc_br_x = cc.br_x || 0
        cc_br_width = cc.br_width || first.size.width
        cc_br_y = cc.br_y || 0
        cc_br_height = cc.br_height || first.size.height
        oe_pc_x = oe_pc.x
        oe_pc_y = oe_pc.y
        oe_cc_br_x = cc.br_x || 0
        oe_cc_br_width = oe_cc.br_width || second.size.width
        oe_cc_br_y = oe_cc.br_y || 0
        oe_cc_br_height = oe_cc.br_height || second.size.height

        return true if not (
          left(oe_pc_x, oe_cc_br_x) > right(pc_x, cc_br_x, cc_br_width) || 
          right(oe_pc_x, oe_cc_br_x, oe_cc_br_width) < left(pc_x, cc_br_x) || 
          top(oe_pc_y, oe_cc_br_y) > bottom(pc_y, cc_br_y, cc_br_height) || 
          bottom(oe_pc_y, oe_cc_br_y, oe_cc_br_height) < top(pc_y, cc_br_y))

        return false
      end

      def left(x, br_x)
        x + br_x 
      end

      def right(x, br_x, br_width)
        x + br_x + br_width - 1
      end

      def top(y, br_y)
        y + br_y 
      end

      def bottom(y, br_y, br_height)
        y + br_y + br_height - 1
      end
    end
  end
end
