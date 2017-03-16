module Turbomode
  module Components
    class KeyMessageComponent < Component
      attr_accessor :keys
      attr_accessor :message

      def initialize
        @keys = Set.new
        @message = nil
      end  
    end
  end
end
