module Turbomode
  module Components
    class MouseMovementComponent < Component
      def initialize
        depends_upon :position
      end  
    end
  end
end
