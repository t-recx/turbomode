require 'test_helper'
require 'turbomode'

include Turbomode
include Turbomode::Components

describe InputMovementComponent do
  let(:input_movement) { InputMovementComponent.new }

  describe :clone do
    it "should create new component with cloned data" do
      input_movement.keys_time_pressed[:kbup] = 123
      input_movement.keys_movement[:kbup] = { :stuff => 392 }

      cloned_component = input_movement.clone

      _(cloned_component).wont_equal input_movement
      _(cloned_component.keys_movement.object_id).wont_equal input_movement.keys_movement.object_id
      _(cloned_component.keys_time_pressed.object_id).wont_equal input_movement.keys_time_pressed.object_id
      _(cloned_component.keys_time_pressed).must_equal input_movement.keys_time_pressed
      _(cloned_component.keys_movement).must_equal input_movement.keys_movement
    end
  end
end
