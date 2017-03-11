module Turbomode
  module Helpers
    class CameraHelper
      def initialize entity_manager
        @entity_manager = entity_manager
      end

      def camera
        @camera ||= @entity_manager.find_with(:camera)
      end

      def position
        return camera.position.x, camera.position.y if camera

        return 0, 0
      end
    end
  end
end
