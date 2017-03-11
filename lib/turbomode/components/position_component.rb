module Turbomode
  module Components
    class PositionComponent < Component
      attr_accessor :prev_x
      attr_accessor :prev_y
      attr_accessor :x
      attr_accessor :y
      attr_accessor :z

      def initialize
        @x, @y, @z = 0, 0, 0
        @prev_x, @prev_y = 0, 0
      end

      def x=(x)
        @prev_x = @x
        @x = x
      end

      def y=(y)
        @prev_y = @y
        @y = y
      end
    end
  end
end
