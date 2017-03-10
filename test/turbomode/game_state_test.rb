require 'test_helper'
require 'turbomode'
require 'set'

include Turbomode

describe "Game State" do
  MILLISECONDS = 123

  before do
    @system1 = Minitest::Mock.new
    @system2 = Minitest::Mock.new
    @systems = [@system1, @system2]
    @messages = Set.new
    @entity_manager = EntityManager.new
    @camera_helper = Object.new
    @wrapper = Object.new
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

      @systems.each { |s| s.last_time_updated.must_equal MILLISECONDS } 
    end

    it "should not update if time_to_next_update not ellapsed" do
      setup_default_behaviour @systems

      @system1.time_to_next_update = (MILLISECONDS + 1)
      setup_fail_if_update_called @system1

      @game_state.update
    end
  end

  def setup_default_behaviour systems
    set_bool @systems, :on, true
    set_bool @systems, :paused, false
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
