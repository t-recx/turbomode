require 'gosu'

module Turbomode
  class GameBase < Gosu::Window
    attr_accessor :current_state

    def initialize messages, messages_states, width = 640, height = 480, fullscreen = false
      super width, height, fullscreen

      @messages = messages
      @messages_states = messages_states

      @messages_actions = {}
      @messages_actions[:leave_game] = lambda { end_game }
      @messages_actions[:pause_game] = lambda { pause_game }
      @messages_actions[:resume_game] = lambda { resume_game }
    end

    def update
      read_messages

      @current_state.update if @current_state

      @messages.clear
    end

    def draw
      @current_state.draw if @current_state
    end

    def pause_game
      @current_state.pause if @current_state
    end

    def resume_game
      @current_state.resume if @current_state
    end

    def end_game
      close
      exit
    end

    def read_messages
      @messages.each do |message|
        @current_state = @messages_states[message[:message]].call if @messages_states[message[:message]]
        @messages_actions[message[:message]].call if @messages_actions[message[:message]]
      end
    end
  end
end
