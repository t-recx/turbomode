require 'test_helper'
require 'turbomode/entity'
require "#{File.dirname(File.expand_path(__FILE__))}/fake_component.rb"

describe "Entity" do
  before do
    @entity = Turbomode::Entity.new
    @fake_component = FakeComponent.new
  end

  describe "add" do
    it "should add component" do 
      add_fake_component

      @entity.components.count.must_equal 1
    end

    it "should create method on entity" do
      add_fake_component     

      @entity.fake.must_equal @fake_component
    end

    it "should call on_add_component callback" do
      called = false

      @entity.on_add_component = Proc.new { called = true }
      add_fake_component

      called.must_equal true
    end
  end

  def add_fake_component
    @entity.add @fake_component
  end
end
