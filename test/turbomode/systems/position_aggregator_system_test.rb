require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe PositionAggregatorSystem do
  let(:aggregated_entity1) { Entity.new PositionComponent.new }
  let(:aggregated_entity2) { Entity.new PositionComponent.new }

  let(:entity) { Entity.new PositionComponent.new, PositionAggregatorComponent.new }

  let(:entity_manager) do
    em = MiniTest::Mock.new
    em.expect :select_with, [entity], [:position_aggregator, :position]
    em
  end

  subject { PositionAggregatorSystem.new }

  describe :update do
    it "should set position of aggregated entities to aggregator entity, respecting the offsets" do
      aggregated_entity1.position.x = rand 200
      aggregated_entity1.position.y = rand 200
      entity1_offset_x = -10
      entity1_offset_y = -20
      entity2_offset_x = 30
      entity2_offset_y = 40
      entity.position_aggregator.entities = { aggregated_entity1 => { x: entity1_offset_x, y: entity1_offset_y }, aggregated_entity2 => { x: entity2_offset_x, y: entity2_offset_y } }
      entity.position.x = 50
      entity.position.y = 70

      subject.update entity_manager, []

      _([aggregated_entity1.position.x, aggregated_entity1.position.y]).must_equal [entity.position.x + entity1_offset_x, entity.position.y + entity1_offset_y]
      _([aggregated_entity2.position.x, aggregated_entity2.position.y]).must_equal [entity.position.x + entity2_offset_x, entity.position.y + entity2_offset_y]
    end

    it "should be okay if one of the aggregated entities doesn't have a position component" do
      entity.position_aggregator.entities = { Entity.new => { x: 0, y: 0 } } 

      subject.update entity_manager, []
    end
  end
end
