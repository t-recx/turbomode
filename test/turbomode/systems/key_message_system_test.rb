require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe KeyMessageSystem do
  let(:entity) { e = Entity.new; e.add KeyMessageComponent.new; e } 
  let(:entity_manager_mock) { m = Minitest::Mock.new; m.expect :select_with, [entity], [:key_message]; m }
  let(:wrapper_mock) { Minitest::Mock.new }
  let(:messages) { [] }
  let(:system) { KeyMessageSystem.new wrapper_mock }

  describe :update do
    before do
      entity.key_message.keys.add :kbright
      entity.key_message.message = "abc"
    end

    it "should put message inside message array if key pressed" do
      wrapper_mock.expect :button_down?, true, [:kbright]

      system.update entity_manager_mock, messages

      messages.must_equal ["abc"]
    end

    it "should do nothing if no key pressed" do
      wrapper_mock.expect :button_down?, false, [:kbright]

      system.update entity_manager_mock, messages

      messages.count.must_equal 0
    end

    it "should do nothing if message is nil" do
      entity.key_message.message = nil
      wrapper_mock.expect :button_down?, true, [:kbright]

      system.update entity_manager_mock, messages

      messages.count.must_equal 0
    end
  end
end
