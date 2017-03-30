module Turbomode
  module Components
    class PlatformComponent < Component
      def initialize
        depends_upon :position, :position_aggregator, :collision
      end
    end
  end
end
