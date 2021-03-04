require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe PositionHomologatorSystem do
  let(:entity) { Entity.new PositionComponent.new, PositionHomologatorComponent.new }
  let(:entity_manager) { em = Minitest::Mock.new; em.expect :select_with, [entity], [:position, :position_homologator]; em } 
  
  subject { PositionHomologatorSystem.new }

  describe :update do
    it "should adjust position of entity when not conforming to grid" do
      entity.position_homologator.tile_width = 16
      entity.position_homologator.tile_height = 16
      entity.position.x = 15
      entity.position.y = 31

      subject.update entity_manager, []

      _([entity.position.x, entity.position.y]).must_equal [0, 16] 
    end
  end
end
