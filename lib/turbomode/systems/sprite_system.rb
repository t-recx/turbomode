require 'turbomode/systems/system'

module Turbomode
  module Systems
    class SpriteSystem < System
      attr_accessor :scrollable_entities
      attr_accessor :unscrollable_entities

      def initialize wrapper
        @wrapper = wrapper

        @scrollable_entities = Set.new
        @unscrollable_entities = Set.new

        super()
      end

      def update entity_manager, messages
        @scrollable_entities = entity_manager.select_with :sprite, :scrollable
        @unscrollable_entities = entity_manager.select with: [:sprite], without: [:scrollable]
      end

      def draw entity_manager, scrollable
        entities = scrollable ? @scrollable_entities : @unscrollable_entities
        
        entities.each do |e|
          sprite = e.sprite.sprite

          if e.has? :position then
            x = e.position.x
            y = e.position.y
            z = e.position.z
          else
            x, y, z = 0, 0, 0
          end

          if e.has? :rotation then
            angle = e.rotation.angle
            center_x = e.rotation.center_x
            center_y = e.rotation.center_y
          else
            angle, center_x, center_y = 0, 0, 0
          end

          if e.has? :color then
            color = e.color.color
          else
            color = @wrapper.get_color :white
          end

          if e.has? :scale then
            scale_x = e.scale.scale_x
            scale_y = e.scale.scale_y
          else
            scale_x, scale_y = 1, 1
          end

          @wrapper.draw_rot(sprite, x, y, z, angle, center_x, center_y, scale_x, scale_y, color)
        end
      end
    end
  end
end
