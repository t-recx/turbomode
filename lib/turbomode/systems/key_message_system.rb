module Turbomode
  module Systems
    class KeyMessageSystem
      def initialize wrapper
        @wrapper = wrapper
        super()
      end

      def update entity_manager, messages
        entity_manager.select_with(:key_message).each do |entity|
          next unless entity.key_message.message

          messages.push(entity.key_message.message) if entity.key_message.keys.any? { |k| @wrapper.button_down? k }
        end
      end
    end
  end
end
