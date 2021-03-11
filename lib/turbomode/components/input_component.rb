module Turbomode
  module Components
    class InputComponent < Component
      attr_accessor :keys_time_pressed
      attr_accessor :milliseconds_to_next
      attr_accessor :keys_action
      attr_accessor :default_state

      UP = { x: 0, y: -1, direction: :up }
      DOWN = { x: 0, y: 1, direction: :down }
      LEFT = { x: -1, y: 0, direction: :left }
      RIGHT = { x: 1, y: 0, direction: :right }

      def initialize
        depends_upon :position

        @keys_time_pressed = Hash.new
        @milliseconds_to_next = 20

        @keys_action = Hash.new

        @keys_action[:kbup] = UP
        @keys_action[:kbdown] = DOWN
        @keys_action[:kbleft] = LEFT
        @keys_action[:kbright] = RIGHT

        @keys_action[:gpup] = UP
        @keys_action[:gpdown] = DOWN
        @keys_action[:gpleft] = LEFT
        @keys_action[:gpright] = RIGHT
      end 

      def clone
        component = InputComponent.new

        component.keys_time_pressed = @keys_time_pressed.clone
        component.milliseconds_to_next = @milliseconds_to_next

        component.keys_action = @keys_action.clone

        component
      end
    end
  end
end
