require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe TimerSystem do
  let(:messages) { [] }
  let(:entity) { e = Entity.new; e.add TimerComponent.new; e }
  let(:entity_manager) { em = Minitest::Mock.new; 100.times { em.expect :select_with, [entity], [:timer] }; em }
  let(:wrapper) { Minitest::Mock.new; }

  subject { TimerSystem.new wrapper }

  before do
    def wrapper.milliseconds= v; @milliseconds = v; end
    def wrapper.milliseconds; @milliseconds; end
    wrapper.milliseconds = 10
  end

  describe :update do
    before do
      entity.timer.value = 0
      entity.timer.change = 3
    end

    it "should update milliseconds_last with current time if nil" do
      subject.update entity_manager, messages    

      entity.timer.milliseconds_last.must_equal wrapper.milliseconds
    end

    it "should do nothing if timer off" do
      entity.timer.on = false

      subject.update entity_manager, messages    

      entity.timer.milliseconds_last.must_be_nil
    end

    it "should update entity's value with change variable if enough time passed" do
      entity.timer.milliseconds_last = 0
      entity.timer.milliseconds_to_next = 9

      2.times do |t|
        wrapper.milliseconds += 10 * t 
        subject.update entity_manager, messages

        entity.timer.value.must_equal 3 + t * 3
      end
    end

    it "should not update entity's value if not enough time passed" do
      entity.timer.milliseconds_to_next = 1000

      subject.update entity_manager, messages

      entity.timer.value.must_equal 0
    end

    describe "when paused" do
      before do
        subject.update entity_manager, messages
        subject.pause
      end

      it "should increase milliseconds_last by the time ellapsed" do
        wrapper.milliseconds = 100

        subject.resume
        subject.update entity_manager, messages

        entity.timer.milliseconds_last.must_equal 100
      end

      it "should set time_paused to nil after update" do
        subject.update entity_manager, messages

        subject.time_paused.must_be_nil
      end
    end
  end

  describe :pause do
    it "should set time_paused to current time" do
      subject.pause

      subject.time_paused.must_equal wrapper.milliseconds
    end
  end
end
