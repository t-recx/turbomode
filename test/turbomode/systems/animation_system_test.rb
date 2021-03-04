require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe AnimationSystem do
  before do
    @frame_duration = 100
    @sprite1 = Object.new
    @sprite2 = Object.new
    @sprite3 = Object.new
    @wrapper = Minitest::Mock.new
    
    @frames = { 
      other: { 
        other: [ 
          { duration: @frame_duration, sprite: @sprite1 },
          { duration: @frame_duration, sprite: @sprite2 } ],
        another_direction: [
          { duration: @frame_duration, sprite: @sprite3 } ]},
      another_state: { 
        other: [
          {duration: @frame_duration, sprite: @sprite3 } ] }}

    @animation_component = AnimationComponent.new
    @animation_component.frames = @frames

    @entity = Entity.new
    @entity.add @animation_component
    @entity.add SpriteComponent.new
    @entity.add StateComponent.new
    @entity.add DirectionComponent.new
    @entity.state.state = :other
    @entity.direction.direction = :other

    @entity_manager = EntityManager.new
    @entity_manager.add @entity

    @messages = []

    @animation_system = AnimationSystem.new @wrapper
  end

  describe :update do
    it "should do nothing if not enough time passed" do
      setup_milliseconds @frame_duration - 1

      @animation_system.update @entity_manager, @messages

      _(@animation_component.current_frame_position).must_equal 0
    end

    it "should change to next frame if it's time to do it" do
      setup_milliseconds @frame_duration + 1 

      @animation_system.update @entity_manager, @messages

      _(@animation_component.current_frame_position).must_equal 1
      _(@entity.sprite.sprite).must_equal @sprite2
    end

    it "should update last_time_frame_update" do
      setup_milliseconds @frame_duration + 1 

      @animation_system.update @entity_manager, @messages

      _(@animation_component.last_time_frame_update).must_equal @frame_duration + 1
    end

    it "should reset animation from beginning if no frames left in sequence" do
      setup_milliseconds @frame_duration + 1 
      @animation_component.current_frame_position = 1

      @animation_system.update @entity_manager, @messages

      _(@animation_component.current_frame_position).must_equal 0
    end

    it "should reset animation from beginning if state changed and no frames for state on current position" do
      @animation_component.current_frame_position = 1
      @entity.state.state = :another_state
      setup_milliseconds @frame_duration - 1

      @animation_system.update @entity_manager, @messages

      _(@animation_component.current_frame_position).must_equal 0
    end

    it "should reset animation from beginning if direction changed and no frames for direction on current position" do
      @animation_component.current_frame_position = 1
      @entity.direction.direction = :another_direction
      setup_milliseconds @frame_duration - 1

      @animation_system.update @entity_manager, @messages

      _(@animation_component.current_frame_position).must_equal 0
    end
  end

  def setup_milliseconds milliseconds
    2.times { @wrapper.expect :milliseconds, milliseconds }
  end
end
