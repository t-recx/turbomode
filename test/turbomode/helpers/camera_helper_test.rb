require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Helpers
include Turbomode::Components

describe "Camera Helper" do
  before do
    @entity_manager = EntityManager.new
    @camera = Entity.new
    @camera.add CameraComponent.new
    @camera.add PositionComponent.new
    @camera.position.x = 20
    @camera.position.y = 40
    @entity_manager.add @camera
    @camera_helper = CameraHelper.new @entity_manager
  end

  describe "camera" do
    it "should cache camera" do
      def @entity_manager.times_called= v; @times_called = v; end;
      def @entity_manager.times_called; @times_called; end;
      def @entity_manager.find_with *x; @times_called += 1; return Object.new; end;

      @entity_manager.times_called = 0

      @camera_helper.camera
      @camera_helper.camera

      _(@entity_manager.times_called).must_equal 1
    end
  end

  describe "position" do
    it "should get camera position" do
      _(@camera_helper.position).must_equal [@camera.position.x, @camera.position.y]
    end

    it "should be 0, 0 if no camera" do
      @entity_manager.delete @camera

      _(@camera_helper.position).must_equal [0, 0]
    end
  end
end
