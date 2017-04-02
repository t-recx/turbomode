module Turbomode
  module Components
    class PositionHomologatorComponent < Component
      attr_accessor :tile_width
      attr_accessor :tile_height

      def initialize
        depends_upon :position

        @tile_width, @tile_height = 1, 1
      end
    end
  end
end
