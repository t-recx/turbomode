require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components
include Turbomode::Helpers

describe InputLockedMovementSystem do
  let(:original_x) { 20 }
  let(:original_y) { 40 }
  let(:movement_unit) { 2 }
  let(:original_movement_left) { 10 }
  let(:milliseconds) { 100 }
  let(:wrapper_mock) { wm = Minitest::Mock.new; 100.times { wm.expect :milliseconds, milliseconds }; wm }
  let(:entity) do
    e = Entity.new

    e.add InputLockedMovementComponent.new
    e.add PositionComponent.new
    e.add DirectionComponent.new
    e.add StateComponent.new
    e.add DirectionComponent.new

    e
  end

  let(:entity_manager) { em = EntityManager.new; em.add entity; em }
  let(:entity_manager_mock) { Minitest::Mock.new }

  subject { InputLockedMovementSystem.new wrapper_mock }

  describe :initialize do
    it "should set allow_pause to true" do
      _(subject.allow_pause).must_equal true
    end
  end

  describe :update do
    it "should call select_with with appropriate parameters" do
      set_button_down_expect wrapper_mock, entity.input_locked_movement
      entity_manager_mock.expect :select_with, Set.new, [:input_locked_movement, :position, :direction]

      subject.update entity_manager_mock, []

      entity_manager_mock.verify
    end

    it "should set movement_range to 1 if movement_range is nil" do
      set_button_down_expect wrapper_mock, entity.input_locked_movement
      entity.input_locked_movement.movement_range = nil

      subject.update entity_manager, []

      _(entity.input_locked_movement.movement_range).must_equal 1
    end

    it "should set movement_range to size.width if entity has size" do
      set_button_down_expect wrapper_mock, entity.input_locked_movement
      entity.input_locked_movement.movement_range = nil
      entity.add SizeComponent.new
      entity.size.width = 123

      subject.update entity_manager, []

      _(entity.input_locked_movement.movement_range).must_equal entity.size.width
    end

    it 'should set state to idle if movement_left == 0' do
      assert_state_idle(0)
    end

    it 'should set state to idle if movement_left <= 0' do
      assert_state_idle(-10)
    end

    def assert_state_idle(movement_left)
      set_button_down_expect wrapper_mock, entity.input_locked_movement
      entity.state.state = :whatever
      entity.input_locked_movement.movement_left = movement_left

      subject.update entity_manager, []

      _(entity.state.state).must_equal :idle
    end

    describe "when multiple keys pressed" do
      before :each do
        set_button_down_expect wrapper_mock, entity.input_locked_movement, [:kbup, :kbdown]
      end

      it "should only take into account first key pressed" do
        subject.update entity_manager, []

        _(entity.direction.direction).must_equal :up
      end
    end

    describe "when key pressed" do
      before :each do
        set_button_down_expect wrapper_mock, entity.input_locked_movement, :kbup
      end  

      describe "if movement left = 0" do
        before :each do
          entity.input_locked_movement.movement_left = 0
        end
        
        it "should set state to moving" do
          subject.update entity_manager, []

          _(entity.state.state).must_equal :moving
        end

        it 'should set direction' do
          entity.direction.direction = :whatever

          subject.update entity_manager, []

          _(entity.direction.direction).must_equal :up
        end

        it 'should set movement_left' do
          entity.input_locked_movement.movement_range = 123

          subject.update entity_manager, []

          _(entity.input_locked_movement.movement_left).must_equal entity.input_locked_movement.movement_range - entity.input_locked_movement.movement_unit
        end

        it 'should record time when key was pressed' do
          subject.update entity_manager, []

          _(entity.input_locked_movement.keys_time_pressed[:kbup]).must_equal milliseconds
        end

        it 'should do nothing if not enough time passed' do
          entity.input_locked_movement.milliseconds_to_next = milliseconds + 1

          subject.update entity_manager, []

          _(entity.state.state).must_equal :idle
        end
      end
    end

    describe "when movement left > 0" do
      before :each do
        entity.input_locked_movement.movement_unit = movement_unit
        entity.input_locked_movement.movement_left = original_movement_left
        entity.position.x = original_x
        entity.position.y = original_y
      end

      it 'should decrease movement left' do
        subject.update entity_manager, []  

        _(entity.input_locked_movement.movement_left).must_equal original_movement_left - entity.input_locked_movement.movement_unit
      end  

      it 'should change coordinates accordingly when up' do
        assert_coordinates_change :up, ey: original_y - movement_unit
      end

      it 'should change coordinates accordingly when down' do
        assert_coordinates_change :down, ey: original_y + movement_unit
      end

      it 'should change coordinates accordingly when left' do
        assert_coordinates_change :left, ex: original_x - movement_unit
      end

      it 'should change coordinates accordingly when right' do
        assert_coordinates_change :right, ex: original_x + movement_unit
      end

      it 'should not change anything if not sufficient time has passed' do
        assert_coordinates_change :right, ex: original_x + movement_unit

        subject.update entity_manager, []

        _(entity.position.x).must_equal original_x + movement_unit
      end

      it 'should set movement_last_time' do
        subject.update entity_manager, []

        _(entity.input_locked_movement.movement_last_time).must_equal milliseconds
        
      end
    end
  end

  def assert_coordinates_change(direction, ex: nil, ey: nil)
    entity.direction.direction = direction

    subject.update entity_manager, []

    _(entity.position.x).must_equal ex if ex
    _(entity.position.y).must_equal ey if ey
  end

  def set_button_down_expect w, im, button_down_symbol = nil
    im.keys_action.each do |key, value|
      bds = nil

      if button_down_symbol != nil then
        bds = button_down_symbol if button_down_symbol.is_a? Symbol
        bds = key if button_down_symbol.is_a? Enumerable and button_down_symbol.include? key
      end

      return_value = (key == bds ? true : false)
      w.expect :button_down?, return_value, [key] 
    end
  end
end
