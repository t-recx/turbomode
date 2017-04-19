module Turbomode
  module Components
    class InputLockedMovementComponent < Component
      attr_accessor :keys_time_pressed
      attr_accessor :milliseconds_to_next
      attr_accessor :keys_movement
      attr_accessor :sample_movement
      attr_accessor :movement_range
      attr_accessor :movement_left
      attr_accessor :movement_unit
      attr_accessor :movement_last_time
      attr_accessor :movement_milliseconds_to_next

      def initialize
        depends_upon :position, :direction

        @keys_time_pressed = Hash.new(0)
        @milliseconds_to_next = 20

        @movement_range = nil
        @movement_left = 0
        @movement_unit = 1
        @movement_last_time = 0
        @movement_milliseconds_to_next = 20

        @keys_movement = Hash.new

        @keys_movement[:kbup] = :up
        @keys_movement[:kbdown] = :down
        @keys_movement[:kbleft] = :left
        @keys_movement[:kbright] = :right

        @keys_movement[:gpup] = :up
        @keys_movement[:gpdown] = :down
        @keys_movement[:gpleft] = :left
        @keys_movement[:gpright] = :right

        @sample_movement = nil
      end

      def clone
        component = InputLockedMovementComponent.new

        component.keys_time_pressed = @keys_time_pressed.clone
        component.milliseconds_to_next = @milliseconds_to_next

        component.movement_range = @movement_range
        component.movement_left = @movement_left
        component.movement_unit = @movement_unit
        component.movement_last_time = @movement_last_time
        component.movement_milliseconds_to_next = @movement_milliseconds_to_next
        component.keys_movement = @keys_movement.clone
        component.sample_movement = @sample_movement

        component
      end
    end
  end
end
