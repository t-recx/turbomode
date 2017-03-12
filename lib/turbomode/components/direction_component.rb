module Turbomode
  module Components
    class DirectionComponent < Component
      attr_accessor :direction

      def initialize
        @direction = :down
      end
    end
  end
end

