require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems

describe "System" do
  before do
    @system = System.new
  end

  describe "initialize" do
    it "should be properly initialized" do
      @system.on.must_equal true
      @system.auto_turn_off.must_equal false
      @system.time_elapsed.must_equal 0
      @system.time_to_next_update.must_equal 0
      @system.last_time_updated.must_equal 0
      @system.time_to_next_update.must_equal 0
      @system.allow_pause.must_equal false
      @system.paused.must_equal false
    end
  end

  describe "pause" do
    it "should pause system if system allows it" do
      @system.allow_pause = true
      @system.pause

      @system.paused.must_equal true
    end

    it "should not pause system if not allowed" do
      @system.allow_pause = false
      @system.pause

      @system.paused.must_equal false
    end
  end

  describe "resume" do
    it "should resume system" do
      @system.paused = true

      @system.resume

      @system.paused.must_equal false
    end
  end
end
