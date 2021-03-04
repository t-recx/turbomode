require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components
include Turbomode::Helpers

describe MouseMovementSystem do
  let(:mouse_x) { 6 }
  let(:mouse_y) { 9 }
  let(:camera_x) { 3 }
  let(:camera_y) { 7 }
  let(:wrapper) { w = Minitest::Mock.new; w.expect :get_mouse_x, mouse_x; w.expect :get_mouse_y, mouse_y; w }
  let(:messages) { [] }
  let(:entity) { e = Entity.new; e.add PositionComponent.new; e }
  let(:entities) { [entity] }
  let(:entity_manager) { em = Minitest::Mock.new; em.expect :select_with, entities, [:mouse_movement, :position]; em }
  let(:camera_helper) { ch = Minitest::Mock.new; ch.expect :position, [camera_x, camera_y]; ch }
  let(:system) { MouseMovementSystem.new wrapper, camera_helper }

  describe :initialize do
    it "should allow system to be paused" do
      _(system.allow_pause).must_equal true
    end
  end

  describe :update do
    it "should call entity_manager's select_with with the right parameters" do
      system.update entity_manager, messages

      entity_manager.verify
    end

    it "should update entities with mouse's coordinates" do
      system.update entity_manager, messages

      _(entity.position.x).must_equal mouse_x
      _(entity.position.y).must_equal mouse_y
    end

    describe "when entities are scrollable" do
      it "should take camera position into account" do
        entity.add ScrollableComponent.new

        system.update entity_manager, messages

        _(entity.position.x).must_equal mouse_x + camera_x
        _(entity.position.y).must_equal mouse_y + camera_y
      end
    end
  end
end
