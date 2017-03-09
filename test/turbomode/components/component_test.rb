require 'test_helper'
require 'turbomode'

describe "Component" do
  before do
    @component = ReallyLongComponent.new
  end

  describe "method_name" do
    it "should get component name separated by spaces and truncated" do
      @component.method_name.must_equal "really_long"
    end
  end

  describe "depends_upon" do
    it "should set dependencies" do
      @component.depends_upon :position, :size

      @component.dependencies.must_equal [:position, :size]
    end
  end

  class ReallyLongComponent < Turbomode::Components::Component
  end
end
