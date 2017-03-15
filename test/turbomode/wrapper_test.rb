require 'test_helper'
require 'turbomode'
include Turbomode

describe Wrapper do
  before do
    @wrapper = Wrapper.new
  end
  
  describe :get_color do
    it "should return gosu constant when available" do
      @wrapper.get_color(:aqua).must_equal Gosu::Color::AQUA
    end

    it "should return white if color not available" do
      @wrapper.get_color(:bla).must_equal Gosu::Color::WHITE
    end
  end

  describe :get_key do
    it "should return gosu value when available" do
      @wrapper.get_key(:kba).must_equal Gosu::KbA
      @wrapper.get_key(:gpdown).must_equal Gosu::GpDown
    end

    it "should raise exception if value not available" do
      -> { @wrapper.get_key(:whatever) }.must_raise NameError
    end
  end
end
