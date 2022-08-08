# Turbomode &middot; [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/t-recx/turbomode/blob/main/LICENSE)

Turbomode is a game development engine based on the entity-component-system pattern. In these type of engines, game objects (addressed as entities) are nothing more than buckets of data, with different components representing slices of entity state that are then processed by systems. It favours composition over inheritance and makes it much easier to prototype games, since changing an entity’s behaviour is as easy as adding or subtracting components.

It implements base classes for these entities and systems, managing their lifecycle and game loop. It also offers implementations for common systems in games like an animation or a collision system.

It sits on top of [gosu](https://www.libgosu.org/) - a ruby gem used to handle graphics, sound and input - abstracting some of its functionality away.

## Usage examples

### Components

```ruby
class PlayerComponent < Component
    attr_accessor :score
    attr_accessor :lives
end

def get_player_entity
    entity = Entity.new(PositionComponent.new, InputComponent.new, SpriteComponent.new,
      CollisionComponent.new, PlayerComponent.new, StateComponent.new,
      AnimationComponent.new, DeathComponent.new)

    entity.player.score = 0
    entity.player.lives = 3

    player_sprite = @gosu.get_image('./player.bmp')
    entity.animation.frames = {
      alive: [{sprite: player_sprite }],
      dead: [
        { sprite: @gosu.get_image('./player_dead1.bmp'), duration: 200 },
        { sprite: @gosu.get_image('./player_dead2.bmp'), duration: 200 } ]
    }

    entity.state.state = :alive

    entity.position.x = @gosu.screen_width / 2 - player_sprite.width / 2
    entity.position.y = @gosu.screen_height - 32

    entity.input.keys_action = { kbleft: { x: -1 }, kbright: { x: 1 }, kbup: { message: :fire } }

    return entity
end
```

Example player entity for a space invaders game.

### Systems

```ruby
class AnimationSystem < System
  def update entity_manager, messages
    entity_manager.select_with(:animation, :sprite).each do |e|
      state = e.state ? e.state.state : :other
      direction = e.direction ? e.direction.direction : :other

      e.animation.current_frame_position = 0 unless e.animation.current_frame(state, direction)

      if @wrapper.milliseconds > e.animation.last_time_frame_update + e.animation.current_frame(state, direction)[:duration] then
        e.animation.current_frame_position += 1
        e.animation.last_time_frame_update = @wrapper.milliseconds

        e.animation.current_frame_position = 0 unless e.animation.current_frame(state, direction)

        e.sprite.sprite = e.animation.current_frame(state, direction)[:sprite]
      end
    end
  end
end
```

Example animation system that handles entities with the Animation component and switches between sprites on them after a specific timespan ellapses

## Installing

### Install dependencies

Follow the (install instructions for gosu)[https://github.com/gosu/gosu/wiki/Getting-Started-on-Linux]

    $ bundle install

### Install gem locally

    $ bundle exec rake install
