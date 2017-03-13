require 'set'

module Turbomode
  class EntityManager
    attr_accessor :entities
    attr_accessor :selections

    def initialize
      @entities = Set.new
      @selections = Hash.new
    end

    def add entity
      entity.on_add_component = lambda { reevaluate entity  }
      entity.on_delete_component = lambda { reevaluate entity  }

      entities.add entity

      selections.each do |key, value|
        value[:to_evaluate].add entity
      end
    end

    def merge *entities
      entities.each do |entity|
        add entity
      end
    end

    def delete entity
      entities.delete entity

      selections.each do |key, value|
        value[:selection].delete entity
        value[:to_evaluate].delete entity
      end
    end

    def subtract *list
      list.each do |entity|
        delete entity
      end
    end

    def select with: nil, without: nil, type: nil
      tag = "with:#{with.to_s}|without:#{without.to_s}|type:#{type.to_s}"

      selections[tag] = { :selection => Set.new, :to_evaluate => entities.clone, :cached => Set.new } unless selections[tag]

      entities_to_evaluate = selections[tag][:to_evaluate]

      if entities_to_evaluate.length > 0 then
        selections[tag][:selection].merge _select entities_to_evaluate, with: with, without: without, type: type
        selections[tag][:cached] = selections[tag][:selection].clone

        entities_to_evaluate.clear
      end

      return selections[tag][:cached]
    end

    def _select entity_list, with: nil, without: nil, type: nil
      selection = entity_list.clone

      selection.select! { |e| with.all? { |c| e.respond_to? c } } if with

      selection.select! { |e| without.all? { |c| not e.respond_to? c } } if without

      selection.select! { |e| e.is_a? type } if type

      selection
    end

    def select_with *components
      select with: components
    end

    def select_without *components
      select without: components
    end

    def select_type type
      select type: type
    end

    def find with: nil, without: nil, type: nil
      select(with: with, without: without, type: type).first
    end

    def find_with *components
      find with: components
    end

    def find_without *components
      find without: components
    end

    def find_type type
      find type: type
    end

    def reevaluate entity
      selections.each do |key, value|
        value[:selection].delete entity

        value[:to_evaluate].add entity
      end
    end
  end
end
