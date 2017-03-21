module Turbomode
  module Components
    class TimerComponent < Component
      attr_accessor :value
      attr_accessor :change
      attr_accessor :milliseconds_to_next
      attr_accessor :milliseconds_last
      attr_accessor :on

      def initialize
        @on = true
        @value = 0
        @change = -1
        @milliseconds_to_next = 1000
        @milliseconds_last = nil
      end
    end
  end
end
