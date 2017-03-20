require 'test_helper'
require 'turbomode'
include Turbomode

describe Wrapper do
  let(:window) { Minitest::Mock.new }
  let(:wrapper) { Wrapper.new window }
 
  describe :get_mouse_x do 
    it "should return window's mouse_x" do
      window.expect :mouse_x, 123

      wrapper.get_mouse_x.must_equal 123
      window.verify
    end
  end

  describe :get_mouse_y do 
    it "should return window's mouse_y" do
      window.expect :mouse_y, 321

      wrapper.get_mouse_y.must_equal 321
      window.verify
    end
  end

  describe :get_color do
    it "should return gosu constant when available" do
      wrapper.get_color(:aqua).must_equal Gosu::Color::AQUA
    end

    it "should return white if color not available" do
      wrapper.get_color(:bla).must_equal Gosu::Color::WHITE
    end
  end

  describe :get_key do
    it "should return gosu value when available" do
      wrapper.get_key(:kba).must_equal Gosu::KbA
      wrapper.get_key(:gpdown).must_equal Gosu::GpDown
    end

    it "should raise exception if value not available" do
      -> { wrapper.get_key(:whatever) }.must_raise NameError
    end
  end
end
