require 'gosu'

module Turbomode
  class GameBase < Gosu::Window
    attr_accessor :current_state

    def initialize messages, messages_states, width = 640, height = 480, fullscreen = false
      super width, height, fullscreen

      @messages = messages
      @messages_states = messages_states

      @messages_actions = {}
      @messages_actions[Messages::LEAVE_GAME] = lambda { end_game }
      @messages_actions[Messages::PAUSE_GAME] = lambda { pause_game }
      @messages_actions[Messages::RESUME_GAME] = lambda { resume_game }
    end

    def update
      read_messages

      @current_state.update
    end

    def draw
      @current_state.draw
    end

    def pause_game
      @current_state.pause
    end

    def resume_game
      @current_state.resume
    end

    def end_game
      close
      exit
    end

    def read_messages
      @messages.each do |message|
        @current_state = @messages_states[message].call if @messages_states[message]
        @messages_actions[message].call if @messages_actions[message]
      end
    end
  end
end
