require 'turbomode/systems/system'

module Turbomode
  module Systems
    class TextSystem < System
      attr_accessor :fixed_entities
      attr_accessor :scrollable_entities
      attr_accessor :camera_x
      attr_accessor :camera_y

      def initialize wrapper, camera_helper = nil
        @wrapper = wrapper
        @camera_helper = camera_helper

        @fixed_entities = Set.new
        @scrollable_entities = Set.new

        super()
      end

      def update entity_manager, messages
        if @camera_helper
          @camera_x, @camera_y = @camera_helper.position
        else
          @camera_x, @camera_y = 0, 0
        end

        @fixed_entities = entity_manager.select with: [:text], without: [:scrollable]
        @scrollable_entities = entity_manager.select_with :text, :scrollable
      end

      def draw entity_manager, scrollable
        (scrollable ? @scrollable_entities : @fixed_entities)
        .each do |e|
          x, y, z = 0, 0, 0
          rel_x, rel_y = e.text.rel_x, e.text.rel_y
          scale_x, scale_y = 1, 1
          color = :white
          font_size = 16

          if e.has? :position then
            x = e.position.x
            y = e.position.y
            z = e.position.z
          end

          if e.text.font_size then
            font_size = e.text.font_size
          else
            font_size = e.size.height if e.has? :size
          end

          next if x - @camera_x > @wrapper.screen_width
          next if y - @camera_y > @wrapper.screen_height
          next if y - @camera_y + font_size < 0

          if e.has? :scale
            scale_x = e.scale.scale_x
            scale_y = e.scale.scale_y
          end

          color = e.color.color if e.has? :color

          e.text.text = e.text.text_lambda.call if e.text.text_lambda

          @wrapper.draw_text e.text.text, x, y, z, rel_x, rel_y, scale_x, scale_y, color, font_size: font_size
        end
      end
    end
  end
end
