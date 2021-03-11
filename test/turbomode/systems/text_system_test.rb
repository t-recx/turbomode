require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe TextSystem do
  let(:fixed_entity) { Entity.new TextComponent.new }
  let(:scrollable_entity) { Entity.new TextComponent.new, ScrollableComponent.new }
  let(:camera_x) { 1 }
  let(:camera_y) { 2 }
  let(:camera_helper) { ch = Minitest::Mock.new; ch.expect :position, [camera_x, camera_y]; ch }
  let(:actual_wrapper) { Wrapper.new nil }

  let(:entity_manager) do 
    em = Minitest::Mock.new

    em.expect :select, [fixed_entity], [with: [:text], without: [:scrollable]]
    em.expect :select_with, [scrollable_entity], [:text, :scrollable]

    em 
  end
  
  let(:screen_width) { 320 }
  let(:screen_height) { 240 }
  let(:wrapper) do
    w = Minitest::Mock.new

    w.expect :screen_width, screen_width
    w.expect :screen_height, screen_height

    w 
  end

  subject { TextSystem.new wrapper, camera_helper }

  describe :update do
    it "should ask for and store the correct entities" do
      subject.update entity_manager, []

      _(subject.fixed_entities).must_equal [fixed_entity]
      _(subject.scrollable_entities).must_equal [scrollable_entity]
    end

    it "should ask for and store camera's position" do
      subject.update entity_manager, []

      _(subject.camera_x).must_equal camera_x
      _(subject.camera_y).must_equal camera_y
    end
  end

  describe :draw do
    before do
      subject.update entity_manager, []
    end

    it "should call draw_text on wrapper" do
      fixed_entity.text.text = "abc"

      setup_expectation "abc"
      subject.draw entity_manager, false

      wrapper.verify
    end

    it "should call draw_text on wrapper with appropriate parameters when other components are present" do
      fixed_entity.merge PositionComponent.new, ColorComponent.new, SizeComponent.new, ScaleComponent.new
      fixed_entity.size.height = 200
      fixed_entity.position.x = 10
      fixed_entity.position.y = 20
      fixed_entity.position.z = 30
      fixed_entity.color.color = :purple
      fixed_entity.text.text = "zyx"
      fixed_entity.text.rel_x = 1
      fixed_entity.text.rel_y = 10
      fixed_entity.scale.scale_x = 300
      fixed_entity.scale.scale_y = 400

      setup_expectation "zyx", x: 10, y: 20, z: 30, color: :purple, font_size: 200, rel_x: 1, rel_y: 10, scale_x: 300, scale_y: 400
      subject.draw entity_manager, false

      wrapper.verify
    end

    it "should draw appropriate entities according to the scrollable parameter" do
      scrollable_entity.text.text = "123"
      
      setup_expectation "123"
      subject.draw entity_manager, true

      wrapper.verify
    end

    it "should evaluate expression when present and put it on text" do
      fixed_entity.text.text_lambda = -> { (2+2).to_s }

      setup_expectation "4"
      subject.draw entity_manager, false

      wrapper.verify
    end

    it "should not draw when out of screen to the right" do
      assert_no_draw(screen_width + 1 + camera_x, 0)
    end

    it "should not draw when out of screen to the bottom" do
      assert_no_draw(0, screen_height + 1 + camera_y)
    end

    it "should not draw when out of screen to the top" do
      assert_no_draw(0, -16 - 1)
    end

    def assert_no_draw(x, y)
      scrollable_entity.add PositionComponent.new
      scrollable_entity.position.x = x
      scrollable_entity.position.y = y

      def wrapper.draw_text(text, x, y, z, rel_x, rel_y, scale_x, scale_y, color, font: nil, font_size: nil); raise "should not be called"; end
      subject.draw entity_manager, true
    end
  end

  def setup_expectation(text, x: 0, y: 0, z: 0, rel_x: 0, rel_y: 0, scale_x: 1, scale_y: 1,  color: :white, font_size: 16)
    wrapper.expect :draw_text, nil, [text, x, y, z, rel_x, rel_y, scale_x, scale_y, color, font_size: font_size]
  end
end
