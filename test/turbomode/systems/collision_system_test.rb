require 'test_helper'
require 'turbomode'
include Turbomode
include Turbomode::Systems
include Turbomode::Components

describe CollisionSystem do
  before do
    @entity_manager = EntityManager.new
    @messages = []

    @collision_system = CollisionSystem.new
  end

  describe :update do
    it "should fill entities_colliding on entities if colliding testcase 1" do
      collision_testcase 0, 0, 10, 20, 9, 19, 2, 2
    end

    it "should fill entities_colliding on entities if colliding testcase 2" do
      collision_testcase 9, 19, 2, 2, 0, 0, 10, 20
    end

    it "should fill entities_colliding on entities if colliding testcase 3" do
      collision_testcase 20, 30, 10, 10, 25, 35, 100, 100
    end

    it "should do nothing if entities not colliding testcase 1" do
      no_collision_testcase 0, 0, 10, 10, 10, 10, 10, 10 
    end

    it "should do nothing if entities not colliding testcase 2" do
      no_collision_testcase 10, 10, 10, 10, 0, 0, 10, 10
    end

    it "should do nothing if entities not colliding testcase 2" do
      no_collision_testcase 100, 200, 300, 400, 1000, 300, 100, 100
    end

    it "should set bounding x, y defaults on nil" do
      entity = get_entity br_x: nil, br_y: nil 
      @entity_manager.add entity

      @collision_system.update @entity_manager, @messages

      entity.collision.br_x.must_equal 0
      entity.collision.br_y.must_equal 0
    end

    it "should set bounding width, height using size on nil" do
      entity = get_entity br_width: nil, br_height: nil 
      entity.add SizeComponent.new
      entity.size.width = 10
      entity.size.height = 20
      @entity_manager.add entity

      @collision_system.update @entity_manager, @messages

      entity.collision.br_width.must_equal entity.size.width
      entity.collision.br_height.must_equal entity.size.height
    end

    def collision_testcase(x1, y1, w1, h1, x2, y2, w2, h2)
      assert_collision setup_collision_testcase(x1, y1, w1, h1, x2, y2, w2, h2)
    end

    def no_collision_testcase(x1, y1, w1, h1, x2, y2, w2, h2)
      assert_no_collision setup_collision_testcase(x1, y1, w1, h1, x2, y2, w2, h2)
    end

    def setup_collision_testcase(x1, y1, w1, h1, x2, y2, w2, h2)
      entity1 = get_entity x: x1, y: y1, br_width: w1, br_height: h1
      entity2 = get_entity x: x2, y: y2, br_width: w2, br_height: h2
      @entity_manager.merge entity1, entity2

      @collision_system.update @entity_manager, @messages

      return entity1, entity2
    end
  end

  def assert_collision entities
    entities.each do |e|
      e.collision.entities_colliding.count.must_equal entities.count - 1
      assert entities.select { |y| y != e }.all? { |y| e.collision.entities_colliding.any? { |x| x == y } }
    end
  end

  def assert_no_collision entities
    entities.each do |e|
      e.collision.entities_colliding.count.must_equal 0
    end
  end

  def get_entity x: 0, y: 0, br_x: 0, br_y: 0, br_width: 0, br_height: 0
    entity = Entity.new

    entity.add CollisionComponent.new
    entity.add PositionComponent.new

    entity.position.x, entity.position.y = x, y

    entity.collision.br_x = br_x
    entity.collision.br_y = br_y
    entity.collision.br_width = br_width
    entity.collision.br_height = br_height

    entity
  end
end
