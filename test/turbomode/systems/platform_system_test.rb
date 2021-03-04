require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe PlatformSystem do
  let(:transported_entity) { Entity.new PositionComponent.new, CollisionComponent.new, PlatformTransportableComponent.new }
  let(:entity) { Entity.new PositionComponent.new, PlatformComponent.new, CollisionComponent.new, PositionAggregatorComponent.new }
  let(:entity_manager) do
    em = Minitest::Mock.new

    10.times do 
      em.expect :select_with, [entity], [:position, :collision, :position_aggregator, :platform] 
    end

    em
  end

  subject { PlatformSystem.new }

  describe :update do
    it "should add colliding entities to position aggregator" do
      collide entity, transported_entity

      subject.update entity_manager, []

      _(entity.position_aggregator.entities.count).must_equal 1
      _(entity.position_aggregator.entities[transported_entity]).must_equal(position_hash(entity, transported_entity))
    end

    it "should set first position on aggregator and stick with it" do
      collide entity, transported_entity
      original_position_hash = position_hash(entity, transported_entity)

      10.times do 
        subject.update entity_manager, []

        transported_entity.position.x = rand 100
        transported_entity.position.y = rand 100
      end

      _(entity.position_aggregator.entities[transported_entity]).must_equal original_position_hash
    end

    it "should have platforms ignoring entities that are not transportable or do not have position" do
      collide entity, transported_entity

      transported_entity.delete transported_entity.position
      transported_entity.delete transported_entity.platform_transportable

      subject.update entity_manager, []
    end

    it "should ignore entities that have a state that's exempted from platforming" do
      collide entity, transported_entity
      transported_entity.add StateComponent.new
      transported_entity.state.state = :dealbreaker
      transported_entity.platform_transportable.except_on_states.push :dealbreaker

      subject.update entity_manager, []

      _(entity.position_aggregator.entities.count).must_equal 0
    end

    it "should take entity out of aggregator if collision stops" do
      collide entity, transported_entity

      subject.update entity_manager, []

      stop_colliding entity, transported_entity

      subject.update entity_manager, []

      _(entity.position_aggregator.entities.count).must_equal 0
    end

    it "should take entity out of aggregator if it changes state to something exempted from platforming" do
      collide entity, transported_entity

      subject.update entity_manager, []

      transported_entity.add StateComponent.new
      transported_entity.state.state = :dealbreaker
      transported_entity.platform_transportable.except_on_states.push :dealbreaker

      subject.update entity_manager, []

      _(entity.position_aggregator.entities.count).must_equal 0
    end
  end

  def collide *entities
    entities.each do |e|
      e.position.x = rand 1000
      e.position.y = rand 1000

      e.collision.entities_colliding.merge entities.reject { |x| x == e } 
    end
  end

  def stop_colliding *entities
    entities.each do |e|
      e.collision.entities_colliding.subtract entities
    end
  end

  def position_hash e, te
    { x: (te.position.x - e.position.x), y: (te.position.y - e.position.y) }
  end
end
