module Turbomode
  module Components
    class ColorComponent < Component
      attr_accessor :color

      def initialize
        @color = 0xff_ffffff
      end
    end
  end
end
