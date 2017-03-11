module Turbomode
  module Components
    class CameraComponent < Component
      def initialize
        depends_upon :position
      end
    end
  end
end
