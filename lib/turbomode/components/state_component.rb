module Turbomode
  module Components
    class StateComponent < Component
      attr_accessor :state

      def initialize
        @state = :idle
      end
    end
  end
end
