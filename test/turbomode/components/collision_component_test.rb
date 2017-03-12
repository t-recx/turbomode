require 'test_helper'
require 'turbomode'

include Turbomode
include Turbomode::Components

describe CollisionComponent do
  before do
    @collision = CollisionComponent.new
  end

  describe :with do
    describe "collision happening" do
      it "should return true if checking by class" do
        class WithTestClass; end;

        @collision.entities_colliding.add WithTestClass.new

        assert @collision.with WithTestClass
      end

      it "should return true if checking by component" do
        entity = Entity.new
        entity.add SizeComponent.new
        @collision.entities_colliding.add entity

        assert @collision.with :size
      end
    end

    describe "no collision occurring" do
      before do
        foil_entity = Entity.new
        foil_entity.add PositionComponent.new

        @collision.entities_colliding.add foil_entity
      end

      it "should return false when checking by class" do
        refute @collision.with String
      end

      it "should return false when checking by component" do
        refute @collision.with :size
      end
    end
  end
end
