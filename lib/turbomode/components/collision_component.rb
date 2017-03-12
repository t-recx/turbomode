module Turbomode
  module Components
    class CollisionComponent < Component
      attr_accessor :entities_colliding
      attr_accessor :br_x
      attr_accessor :br_y
      attr_accessor :br_width
      attr_accessor :br_height

      def initialize
        depends_upon :position

        @entities_colliding = Set.new
        @br_x, @br_y, @br_width, @br_height = nil, nil, nil, nil
      end

      def with it
        @entities_colliding.any? { |e| (it.is_a? Class and e.is_a? it) or (it.is_a? Symbol and e.is? it) }
      end
    end
  end
end
