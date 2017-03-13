require 'gosu'

module Turbomode
  class Wrapper
    def milliseconds
      Gosu::milliseconds
    end

    def translate(x, y, &block)
      Gosu::translate(x, y) { block.call }
    end

    def draw_rot(sprite, x, y, z, angle, center_x, center_y, scale_x, scale_y, color)
      sprite.draw_rot(sprite, x, y, z, angle, center_x, center_y, scale_x, scale_y, color)
    end

    def get_color symbol
      constant = "Gosu::Color::#{symbol.to_s.upcase}"

      return Object.const_get constant if Object.const_defined? constant

      return Gosu::Color::WHITE
    end
  end
end
