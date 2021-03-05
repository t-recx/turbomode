require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components
include Turbomode::Helpers

describe InputSystem do
  before do
    @milliseconds = 3
  end

  let(:entity_manager) { EntityManager.new }
  let(:wrapper_mock) { wm = Minitest::Mock.new; wm.expect :milliseconds, 3; wm }
  let(:entity_manager_mock) { Minitest::Mock.new }
  let(:messages) { [] }
  let(:position) { PositionComponent.new }
  let(:input) { InputComponent.new }
  let(:entity) { e = Entity.new; e.add position; e.add input; e }
  
  let(:input_system) { InputSystem.new wrapper_mock }

  describe :initialize do
    it "should set allow_pause to true" do
      _(input_system.allow_pause).must_equal true
    end
  end

  describe :update do
    it "should call entity_manager with appropriate arguments" do
      entity_manager_mock.expect :select_with, Set.new, [:input, :position]

      input_system.update entity_manager_mock, messages

      entity_manager_mock.verify
    end

    it "should change position if key pressed" do 
      entity_manager.add entity
      set_button_down_expect wrapper_mock, input, :kbdown

      input_system.update entity_manager, messages

      _(entity.position.x).must_equal 0
      _(entity.position.y).must_equal 1
    end

    it "should set state = idle on entity if has state" do
      entity.add StateComponent.new
      entity.state.state = :whatever
      entity_manager.add entity
      set_button_down_expect wrapper_mock, input

      input_system.update entity_manager, messages

      _(entity.state.state).must_equal :idle
    end

    it "should set state = moving on entity if key pressed" do
      entity.add StateComponent.new
      entity_manager.add entity
      set_button_down_expect wrapper_mock, input, :kbup

      input_system.update entity_manager, messages

      _(entity.state.state).must_equal :moving
    end

    it "should set direction accordingly if key pressed" do
      entity.add DirectionComponent.new
      entity.direction.direction = :left
      entity_manager.add entity
      set_button_down_expect wrapper_mock, input, :kbright

      input_system.update entity_manager, messages

      _(entity.direction.direction).must_equal :right
    end

    it "should set key press milliseconds" do
      entity_manager.add entity
      set_button_down_expect wrapper_mock, input, :kbdown

      input_system.update entity_manager, messages

      _(input.keys_time_pressed[:kbdown]).must_equal 3
    end

    it "should only acknowledge key press if sufficient time passed" do
      wrapper_mock.expect :milliseconds, 3
      entity_manager.add entity
      2.times do
        set_button_down_expect wrapper_mock, input, :kbdown

        input_system.update entity_manager, messages
      end 

      _(entity.position.y).must_equal 1
    end

    it "should allow another key press to change position when sufficient time passed" do
      entity_manager.add entity
      set_button_down_expect wrapper_mock, input, :kbdown
      input_system.update entity_manager, messages
      2.times { wrapper_mock.expect :milliseconds, 3 + input.milliseconds_to_next + 1 }
      set_button_down_expect wrapper_mock, input, :kbdown
      input_system.update entity_manager, messages

      _(entity.position.y).must_equal 2
    end

    def set_button_down_expect w, im, button_down_symbol = nil
      im.keys_action.each do |key, value|
        return_value = (key == button_down_symbol ? true : false)
        w.expect :button_down?, return_value, [key] 
      end
    end
  end
end
