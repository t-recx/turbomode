module Turbomode
  module Components
    class InputMovementComponent < Component
      attr_accessor :keys_time_pressed
      attr_accessor :milliseconds_to_next
      attr_accessor :keys_movement
      attr_accessor :sample_movement

      UP = { x: 0, y: -1, direction: :up }
      DOWN = { x: 0, y: 1, direction: :down }
      LEFT = { x: -1, y: 0, direction: :left }
      RIGHT = { x: 1, y: 0, direction: :right }

      def initialize
        depends_upon :position

        @keys_time_pressed = Hash.new
        @milliseconds_to_next = 20

        @keys_movement = Hash.new

        @keys_movement[:kbup] = UP
        @keys_movement[:kbdown] = DOWN
        @keys_movement[:kbleft] = LEFT
        @keys_movement[:kbright] = RIGHT

        @keys_movement[:gpup] = UP
        @keys_movement[:gpdown] = DOWN
        @keys_movement[:gpleft] = LEFT
        @keys_movement[:gpright] = RIGHT

        @sample_movement = nil
      end 

      def clone
        component = InputMovementComponent.new

        component.keys_time_pressed = @keys_time_pressed.clone
        component.milliseconds_to_next = @milliseconds_to_next

        component.keys_movement = @keys_movement.clone
        component.sample_movement = @sample_movement

        component
      end
    end
  end
end
