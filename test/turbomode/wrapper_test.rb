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
end
