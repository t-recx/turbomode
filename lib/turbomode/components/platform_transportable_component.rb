module Turbomode
  module Components
    class PlatformTransportableComponent < Component
      attr_accessor :except_on_states

      def initialize
        depends_upon :position

        @except_on_states = [:moving]
      end
    end
  end
end
