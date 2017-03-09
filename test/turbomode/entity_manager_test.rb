require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Components

describe "Entity Manager" do

  before do
    @entity_manager = EntityManager.new
    @entity = Entity.new

    @entity1 = FirstTypeEntity.new
    @entity2 = FirstTypeEntity.new
    @entity3 = SecondTypeEntity.new
  end

  describe "add" do
    it "should add entity to set" do
      add_entity  

      @entity_manager.entities.count.must_equal 1
      assert @entity_manager.entities.include? @entity
    end

    it "should add entity to evaluation list on all cached selections" do
      @entity_manager.select with: FirstFakeComponent.new
      @entity_manager.select without: FirstFakeComponent.new

      add_entity

      @entity_manager.selections.each do |key, value|
        assert value[:to_evaluate].include? @entity
      end
    end

    it "should reevaluate entity when adding component" do
      @entity.add FirstFakeComponent.new

      add_entity

      @entity_manager.select with: [:first_fake]
      @entity_manager.select without: [:first_fake]

      @entity.add SecondFakeComponent.new

      @entity_manager.selections.each do |key, value|
        refute value[:selection].include? @entity
        assert value[:to_evaluate].include? @entity
      end
    end

    it "should reevaluate entity when deleting component" do
      @entity.add FirstFakeComponent.new

      add_entity

      @entity_manager.select with: [:first_fake]
      @entity_manager.select without: [:first_fake]

      @entity.delete @entity.first_fake

      @entity_manager.selections.each do |key, value|
        refute value[:selection].include? @entity
        assert value[:to_evaluate].include? @entity
      end
    end
  end

  describe "delete" do
    before do
      add_entity
    end

    it "should delete entity from set" do
      @entity_manager.delete @entity

      @entity_manager.entities.count.must_equal 0
    end

    it "should delete entity from selections" do
      @entity_manager.select with: [:first_fake]
      @entity_manager.select without: [:first_fake]

      @entity_manager.delete @entity

      @entity_manager.selections.each do |key, value|
        refute value[:selection].include? @entity
        refute value[:to_evaluate].include? @entity
      end
    end
  end

  describe "merge" do
    it "should add multiple entities" do
      @entity_manager.merge Entity.new, Entity.new, Entity.new

      @entity_manager.entities.count.must_equal 3
    end
  end

  describe "subtract" do
    it "should delete multiple entities" do
      a = Entity.new
      b = Entity.new
      c = Entity.new

      @entity_manager.merge a, b, c

      @entity_manager.subtract a, b

      @entity_manager.entities.count.must_equal 1
      @entity_manager.entities.include? c
    end
  end

  describe "select" do
    before do
      @entity_manager.merge @entity1, @entity2, @entity3
    end

    describe "using with" do
      it "should return entities with specific component" do
        @entity1.add FirstFakeComponent.new
        @entity1.add SecondFakeComponent.new

        @entity2.add FirstFakeComponent.new

        @entity3.add FirstFakeComponent.new
        @entity3.add SecondFakeComponent.new

        selection = @entity_manager.select with: [:first_fake, :second_fake]

        selection.count.must_equal 2
        assert selection.include? @entity1
        assert selection.include? @entity3
      end
    end

    describe "using without" do
      it "should return entities without specific component" do
        @entity2.add FirstFakeComponent.new
        @entity3.add SecondFakeComponent.new

        selection = @entity_manager.select without: [:first_fake, :second_fake]

        selection.count.must_equal 1
        assert selection.include? @entity1
      end
    end

    describe "using type" do
      it "should return entities of type" do
        selection = @entity_manager.select type: FirstTypeEntity

        selection.count.must_equal 2
        assert selection.include? @entity1
        assert selection.include? @entity2
      end
    end

    describe "using multiple parameters" do
      it "should return entities correctly" do
        @entity1.add FirstFakeComponent.new
        @entity2.add SecondFakeComponent.new
        @entity3.add FirstFakeComponent.new

        selection = @entity_manager.select with: [:first_fake], without: [:second_fake], type: FirstTypeEntity

        selection.count.must_equal 1
        assert selection.include? @entity1
      end
    end

    describe "caching" do
      it "should cache results" do 
        @entity1.add FirstFakeComponent.new

        selection = @entity_manager.select with: [:first_fake]
        new_selection = @entity_manager.select with: [:first_fake]

        @entity_manager.selections.count.must_equal 1
        @entity_manager.selections.keys.first.must_equal "with:[:first_fake]|without:|type:"

        selection.object_id.must_equal new_selection.object_id
      end

      it "should evaluate entities on to_evaluate lists on new selection" do
        @entity_manager.select_with :first_fake
        @entity_manager.select_without :first_fake

        @entity1.add Component.new
        @entity3.add Component.new

        @entity_manager.selections.each do |key, value|
          value[:to_evaluate].count.must_equal 2
        end

        @entity_manager.select_with :first_fake
        @entity_manager.select_without :first_fake
      
        @entity_manager.selections.each do |key, value|
          value[:to_evaluate].count.must_equal 0
        end
      end
    end
  end

  describe "find" do
    it "should return first matching object" do
      a = Entity.new
      b = Entity.new

      a.add FirstFakeComponent.new
      b.add FirstFakeComponent.new

      @entity_manager.merge a, b

      (@entity_manager.find with: [:first_fake]).must_equal a
    end
  end

  describe "idiomatic selections" do
    before do
      @entity1.add FirstFakeComponent.new
      @entity3.add FirstFakeComponent.new
      @entity3.add SecondFakeComponent.new

      @entity_manager.merge @entity1, @entity2, @entity3
    end

    describe "select_with" do 
      it "should select correctly" do
        selection = @entity_manager.select_with :first_fake, :second_fake

        selection.count.must_equal 1
        selection.first.must_equal @entity3
      end
    end

    describe "select_without" do
      it "should select correctly" do
        selection = @entity_manager.select_without :first_fake

        selection.count.must_equal 1
        selection.first.must_equal @entity2
      end
    end

    describe "select_type" do
      it "should select correctly" do
        selection = @entity_manager.select_type SecondTypeEntity

        selection.count.must_equal 1
        selection.first.must_equal @entity3
      end
    end

    describe "find_with" do
      it "should find correctly" do
        item = @entity_manager.find_with :first_fake

        item.must_equal @entity1
      end
    end

    describe "find_without" do
      it "should find correctly" do
        item = @entity_manager.find_without :first_fake

        item.must_equal @entity2
      end
    end

    describe "find_type" do
      it "should find correctly" do
        item = @entity_manager.find_type FirstTypeEntity

        item.must_equal @entity1
      end
    end
  end

  def add_entity
    @entity_manager.add(@entity)  
  end

  class FirstTypeEntity < Entity; end;
  class SecondTypeEntity < Entity; end;
  class FirstFakeComponent < Component; end;
  class SecondFakeComponent < Component; end;
end
