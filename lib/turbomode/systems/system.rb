module Turbomode
  module Systems
    class System
      attr_accessor :on
      attr_accessor :time_elapsed
      attr_accessor :last_time_updated
      attr_accessor :time_to_next_update
      attr_accessor :allow_pause
      attr_accessor :paused

      def initialize
        @on = true
        @time_elapsed = 0
        @last_time_updated = 0
        @time_to_next_update = 0
        @allow_pause = false
        @paused = false
      end

      def pause
        @paused = true if @allow_pause
      end

      def resume
        @paused = false
      end

      def process messages, filter, &block
        messages
        .select { |m| m[:message] == filter}
        .each do |m| 
          yield(m) 
          messages.delete m
        end
      end
    end
  end
end
