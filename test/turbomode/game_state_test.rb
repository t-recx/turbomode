require 'test_helper'
require 'turbomode'
require 'set'

include Turbomode
include Turbomode::Components
include Turbomode::Helpers

describe "Game State" do
  MILLISECONDS = 123

  before do
    @system1 = Minitest::Mock.new
    @system2 = Minitest::Mock.new
    @systems = [@system1, @system2]
    @messages = Set.new
    @entity_manager = EntityManager.new
    @wrapper = Minitest::Mock.new
    @camera_helper = CameraHelper.new @entity_manager
    @game_state = GameState.new @wrapper, @systems, @messages, @entity_manager, @camera_helper

    def @wrapper.milliseconds; MILLISECONDS; end;
  end

  describe "update" do
    before do
      setup_last_time_updated @systems
      setup_time_to_next_update @systems

      @systems.each { |s| s.last_time_updated = 0; s.time_to_next_update = 0 }
    end

    it "should call update on system" do
      setup_default_behaviour @systems
      expect_update @system1

      @game_state.update

      @system1.verify
    end

    it "should be OK with no update provided on system too" do
      setup_default_behaviour @systems

      @game_state.update
    end

    it "should skip system if system not on" do
      @system1.expect :on, false
      @system2.expect :on, true
      expect_update @system2
      set_bool @systems, :paused, false

      setup_fail_if_update_called @system1 

      @game_state.update
    end

    it "should skip system if system is paused" do
      set_bool @systems, :on, true
      @system1.expect :paused, false
      @system2.expect :paused, true

      setup_fail_if_update_called @system2
      
      @game_state.update
    end

    it "should set last_time_updated with wrapper value" do
      setup_default_behaviour @systems

      @game_state.update

      @systems.each { |s| _(s.last_time_updated).must_equal MILLISECONDS } 
    end

    it "should not update if time_to_next_update not ellapsed" do
      setup_default_behaviour @systems

      @system1.time_to_next_update = (MILLISECONDS + 1)
      setup_fail_if_update_called @system1

      @game_state.update
    end
  end

  describe "draw" do
    it "should call draw on every system" do
      setup_systems_on @systems
      setup_systems_draw @systems
      setup_wrapper_translate

      @game_state.draw

      @systems.each { |s| s.verify }
    end

    it "should call translate on wrapper with camera coordinates" do
      setup_camera
      setup_systems_on @systems
      setup_systems_draw @systems
      setup_wrapper_translate(-@camera.position.x, -@camera.position.y)

      @game_state.draw

      @wrapper.verify
    end

    it "should call draw with scrollable = true if we have a camera" do
      setup_camera
      setup_systems_on @systems
      setup_systems_draw @systems, expect_scroll: true
      def @wrapper.translate(x,y); yield; end;

      @game_state.draw

      @systems.each { |s| s.verify }
    end

    it "should skip system if system not on" do
      @system1.expect :on, false
      @system2.expect :on, true
      setup_systems_draw [@system2]
      setup_wrapper_translate

      def @system1.draw(em, s); raise "Method should not be called here!"; end;

      @game_state.draw
    end
  end

  describe "pause" do
    it "should call pause on every system" do
      @systems.each { |s| s.expect :pause, nil }

      @game_state.pause

      @systems.each { |s| s.verify }
    end
  end

  describe "resume" do
    it "should call resume on every system" do
      @systems.each { |s| s.expect :resume, nil }

      @game_state.resume

      @systems.each { |s| s.verify }
    end
  end

  def setup_wrapper_translate sx = 0, sy = 0
    @systems.count.times { @wrapper.expect :translate, nil, [sx, sy] }
  end

  def setup_camera
    @camera = Entity.new
    @camera.add CameraComponent.new
    @camera.add PositionComponent.new
    @camera.position.x = 10
    @camera.position.y = 20
    @entity_manager.add @camera
  end

  def setup_systems_on systems
    set_bool systems, :on, true
  end

  def setup_default_behaviour systems
    setup_systems_on systems
    set_bool systems, :paused, false
  end

  def setup_systems_draw systems, expect_scroll: false
    systems.each do |s| 
      s.expect :draw, nil, [@entity_manager, true] if expect_scroll
      s.expect :draw, nil, [@entity_manager, false]
    end
  end

  def setup_last_time_updated systems
    systems.each do |system|
      def system.last_time_updated; return @last_time_updated; end;
      def system.last_time_updated=(v); @last_time_updated = v; end;
    end
  end

  def setup_time_to_next_update systems
    systems.each do |system|
      def system.time_to_next_update; return @ttnu; end;
      def system.time_to_next_update=(v); @ttnu= v; end;
    end
  end

  def setup_fail_if_update_called system
    def system.update(em, m)
      raise "Update called, but shouldn't"
    end
  end

  def expect_update *systems
    systems.each do |system|
      system.expect :update, nil, [@entity_manager, @messages]
    end
  end

  def set_bool systems, method, value
    systems.each do |system|
      system.expect method, value
    end
  end
end
