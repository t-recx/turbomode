require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Components

describe Entity do
  before do
    @entity = Entity.new
    @position_component = PositionComponent.new
  end

  describe :initialize do
    it "should merge components if parameter supplied" do
      animation_component = AnimationComponent.new
      new_entity = Entity.new(@position_component, animation_component)

      new_entity.components.include? @position_component
      new_entity.components.include? animation_component
    end
  end

  describe :add do
    it "should add component" do 
      add_position_component

      _(@entity.components.count).must_equal 1
    end

    it "should create method on entity" do
      add_position_component     

      _(@entity.position).must_equal @position_component
    end

    it "should call callback" do
      called = false

      @entity.on_add_component = Proc.new { called = true }
      add_position_component

      _(called).must_equal true
    end
  end

  describe :merge do
    it "should add multiple components" do
      @entity.merge PositionComponent.new, AnotherFakeComponent.new

      _(@entity.components.count).must_equal 2
    end
  end

  describe :delete do
    before do
      add_position_component
    end

    it "should delete component" do
      delete_position_component    

      _(@entity.components.count).must_equal 0
    end

    it "should delete method" do
      delete_position_component

      refute @entity.methods.respond_to? :position
    end

    it "should call callback" do
      called = false

      @entity.on_delete_component = Proc.new { called = true }
      delete_position_component

      _(called).must_equal true
    end
  end

  describe :subtract do
    it "should delete components" do
      add_position_component
      @entity.add SizeComponent.new

      @entity.subtract @entity.position, @entity.size

      _(@entity.components.count).must_equal 0
    end
  end

  describe :has do
    it "should alias responds_to?" do
      @entity.add @position_component

      assert @entity.has? :position
    end
  end

  describe :is do
    it "should alias responds_to?" do
      @entity.add @position_component

      assert @entity.is? :position
    end
  end

  describe :check_dependencies do
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

  def add_position_component
    @entity.add @position_component
  end

  def delete_position_component
    @entity.delete @position_component
  end

  class AnotherFakeComponent < Component; def initialize; super; depends_upon :fake; end; end;
  class AdditionalFakeComponent < Component; def initialize; super; depends_upon :another_fake, :fake; end; end;
end
