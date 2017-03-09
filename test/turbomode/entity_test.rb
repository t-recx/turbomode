require 'test_helper'
require 'turbomode'
require "#{File.dirname(File.expand_path(__FILE__))}/components/fake_component.rb"
include Turbomode

describe "Entity" do
  before do
    @entity = Entity.new
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

  describe "merge" do
    it "should add multiple components" do
      @entity.merge FakeComponent.new, AnotherFakeComponent.new

      @entity.components.count.must_equal 2
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

  describe "has?" do
    it "should alias responds_to?" do
      @entity.add @fake_component

      assert @entity.has? :fake
    end
  end

  describe "is?" do
    it "should alias responds_to?" do
      @entity.add @fake_component

      assert @entity.is? :fake
    end
  end

  describe "check_dependencies" do
    it "should spit out component dependencies" do
      @entity.add AdditionalFakeComponent.new 

      assert_output("\
(#{@entity}) Warning: AdditionalFakeComponent depends on another_fake\n\
(#{@entity}) Warning: AdditionalFakeComponent depends on fake\n") { @entity.check_dependencies }

      @entity.add AnotherFakeComponent.new

      assert_output("\
(#{@entity}) Warning: AdditionalFakeComponent depends on fake\n\
(#{@entity}) Warning: AnotherFakeComponent depends on fake\n") { @entity.check_dependencies }
    end
  end

  def add_fake_component
    @entity.add @fake_component
  end

  def delete_fake_component
    @entity.delete @fake_component
  end

  class AnotherFakeComponent < Component; def initialize; super; depends_upon :fake; end; end;
  class AdditionalFakeComponent < Component; def initialize; super; depends_upon :another_fake, :fake; end; end;
end
