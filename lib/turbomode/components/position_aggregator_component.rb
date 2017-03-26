module Turbomode
  module Components
    class PositionAggregatorComponent < Component
      attr_accessor :entities #{ entity => { :x, :y } }

      def initialize
        depends_upon :position

        @entities = {}
      end
    end
  end
end
