require 'test_helper'
require 'turbomode'

include Turbomode
include Turbomode::Components

describe InputComponent do
  let(:input) { InputComponent.new }

  describe :clone do
    it "should create new component with cloned data" do
      input.keys_time_pressed[:kbup] = 123
      input.keys_action[:kbup] = { :stuff => 392 }

      cloned_component = input.clone

      _(cloned_component).wont_equal input
      _(cloned_component.keys_action.object_id).wont_equal input.keys_action.object_id
      _(cloned_component.keys_time_pressed.object_id).wont_equal input.keys_time_pressed.object_id
      _(cloned_component.keys_time_pressed).must_equal input.keys_time_pressed
      _(cloned_component.keys_action).must_equal input.keys_action
    end
  end
end
