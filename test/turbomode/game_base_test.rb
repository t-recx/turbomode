require 'test_helper'
require 'turbomode'
include Turbomode

describe "Game Base" do
  before do
    @messages = []
    @messages_states = {}
    @current_state = Minitest::Mock.new
    @game_base = GameBase.new @messages, @messages_states
    @game_base.current_state = @current_state
  end

  describe "update" do
    it "should call current state's update" do
      @current_state.expect :update, nil

      @game_base.update

      @current_state.verify
    end

    it "should change state according to message" do
      @another_state = Minitest::Mock.new
      @another_state.expect :update, nil
      @messages_states["A"] = lambda { @another_state }
      @messages.push({ message: "A" })

      @game_base.update

      @another_state.verify
    end

    it "should pause state if appropriate message sent" do
      @messages.push({ message: :pause_game })
      @current_state.expect :pause, nil
      @current_state.expect :update, nil

      @game_base.update

      @current_state.verify 
    end

    it "should resume if appropriate message sent" do
      @messages.push({ message: :resume_game })
      @current_state.expect :resume, nil
      @current_state.expect :update, nil

      @game_base.update

      @current_state.verify 
    end
  end

  describe "draw" do
    it "should call draw on current state" do
      @current_state.expect :draw, nil

      @game_base.draw

      @current_state.verify
    end
  end
end
