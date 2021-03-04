require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe SpriteSystem do
  before do
    @wrapper = Minitest::Mock.new
    @messages = []

    @entity1 = get_new_entity true
    @entity2 = get_new_entity true
    @entity3 = get_new_entity false

    @entity_manager = EntityManager.new
    @entity_manager.merge @entity1, @entity2, @entity3

    @sprite_system = SpriteSystem.new @wrapper
  end

  describe :initialize do
    it "should initialize entities" do
      _(@sprite_system.scrollable_entities).must_equal Set.new
      _(@sprite_system.unscrollable_entities).must_equal Set.new
    end
  end

  describe :update do
    it "should select_with :sprite, :scrollable" do
      @sprite_system.update @entity_manager, @messages 

      @sprite_system.scrollable_entities.include? @entity1 
      @sprite_system.scrollable_entities.include? @entity2
      _(@sprite_system.scrollable_entities.count).must_equal 2
    end

    it "should select with: [:sprite], without: [:scrollable]" do
      @sprite_system.update @entity_manager, @messages 

      @sprite_system.unscrollable_entities.include? @entity3
      _(@sprite_system.unscrollable_entities.count).must_equal 1
    end
  end

  describe :draw do
    before do
      @sprite_system.update @entity_manager, @messages
    end

    describe "scrollable = true" do
      it "should call draw_rot on appropriate sprites" do
        @wrapper.expect :draw_rot, nil, [@entity1.sprite.sprite, @entity1.position.x, @entity1.position.y, @entity1.position.z, @entity1.rotation.angle, @entity1.rotation.center_x, @entity1.rotation.center_y, @entity1.scale.scale_x, @entity1.scale.scale_y, @entity1.color.color]
        @wrapper.expect :draw_rot, nil, [@entity2.sprite.sprite, @entity2.position.x, @entity2.position.y, @entity2.position.z, @entity2.rotation.angle, @entity2.rotation.center_x, @entity2.rotation.center_y, @entity2.scale.scale_x, @entity2.scale.scale_y, @entity2.color.color]

        @sprite_system.draw @entity_manager, true

        @wrapper.verify
      end
    end

    describe "scrollable = false" do
      it "should call draw_rot on appropriate sprites" do
        @wrapper.expect :draw_rot, nil, [@entity3.sprite.sprite, @entity3.position.x, @entity3.position.y, @entity3.position.z, @entity3.rotation.angle, @entity3.rotation.center_x, @entity3.rotation.center_y, @entity3.scale.scale_x, @entity3.scale.scale_y, @entity3.color.color]

        @sprite_system.draw @entity_manager, false

        @wrapper.verify
      end

      it "should use default values if components are not available" do
        @entity3.subtract @entity3.position, @entity3.rotation, @entity3.color, @entity3.scale

        @wrapper.expect :get_color, 20, [Symbol]
        @wrapper.expect :draw_rot, nil, [@entity3.sprite.sprite, 0, 0, 0, 0, 0, 0, 1, 1, 20]

        @sprite_system.draw @entity_manager, false

        @wrapper.verify
      end

      it "should do nothing if sprite is nil" do
        @entity3.sprite.sprite = nil

        def @wrapper.draw_rot *p; raise "I shouldn't be called!"; end;

        @sprite_system.draw @entity_manager, false
      end
    end
  end

  def get_new_entity scrollable
    entity = Entity.new

    entity.add SpriteComponent.new
    entity.add PositionComponent.new
    entity.add RotationComponent.new
    entity.add ScrollableComponent.new if scrollable
    entity.add ColorComponent.new
    entity.add ScaleComponent.new

    entity.sprite.sprite = Object.new
    entity.position.x = rand(1..1000)
    entity.position.y = rand(1..1000)
    entity.rotation.angle = rand(1..100)
    entity.rotation.center_x = rand(1..100)
    entity.rotation.center_y = rand(1..100)
    entity.color.color = rand(1..100)
    entity.scale.scale_x = rand(1..100)
    entity.scale.scale_y = rand(1..100)

    entity
  end
end
