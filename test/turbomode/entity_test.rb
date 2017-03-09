require 'test_helper'
require 'turbomode'
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

    it "should call callback" do
      called = false

      @entity.on_add_component = Proc.new { called = true }
      add_fake_component

      called.must_equal true
    end
  end

  describe "delete" do
    before do
      add_fake_component
    end

    it "should delete component" do
      delete_fake_component    

      @entity.components.count.must_equal 0
    end

    it "should delete method" do
      delete_fake_component

      refute @entity.methods.respond_to? :fake
    end

    it "should call callback" do
      called = false

      @entity.on_delete_component = Proc.new { called = true }
      delete_fake_component

      called.must_equal true
    end
  end

  def add_fake_component
    @entity.add @fake_component
  end

  def delete_fake_component
    @entity.delete @fake_component
  end
end
