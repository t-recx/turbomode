module Turbomode
  module Components
    class TextComponent < Component
      attr_accessor :text_eval
      attr_accessor :text
      attr_accessor :rel_x
      attr_accessor :rel_y
      attr_accessor :offset_x
      attr_accessor :offset_y
      attr_accessor :font_size

      def initialize
        @text_eval = nil
        @text = ''
        @rel_x, @rel_y = 0.0, 0.0
        @offset_x, @offset_y = 0, 0
        @font_size = nil
      end
    end
  end
end
