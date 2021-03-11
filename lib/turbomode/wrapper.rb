require 'gosu'

module Turbomode
  class Wrapper
    def initialize window
      @window = window
      @fonts = {}
    end

    def milliseconds
      Gosu::milliseconds
    end

    def translate(x, y, &block)
      Gosu::translate(x, y) { block.call }
    end

    def draw_rot(sprite, x, y, z, angle, center_x, center_y, scale_x, scale_y, color)
      sprite.draw_rot(x, y, z, angle, center_x, center_y, scale_x, scale_y, color)
    end

    def draw_text(text, x, y, z, rel_x, rel_y, scale_x, scale_y, color, font: nil, font_size: nil)
      if font.nil?
        unless @fonts[font_size]
          @fonts[font_size] = Gosu::Font.new(font_size || 12)
        end

        font = @fonts[font_size]
      end

      font.draw_text_rel(text, x, y, z, rel_x, rel_y, scale_x, scale_y, get_color(color)) 
    end

    def get_color symbol
      return symbol unless symbol.is_a? Symbol

      constant = "Gosu::Color::#{symbol.to_s.upcase}"

      return Object.const_get constant if Object.const_defined? constant

      return Gosu::Color::WHITE
    end

    def get_key symbol
      gosu_name = symbol.to_s.upcase
      constant = "Gosu::#{gosu_name[0..1]}_#{gosu_name[2..-1]}"

      return Object.const_get constant
    end

    def button_down? b
      Gosu::button_down? get_key(b)
    end

    def get_mouse_x
      @window.mouse_x
    end

    def get_mouse_y
      @window.mouse_y
    end

    def screen_width
      @window.width
    end

    def screen_height
      @window.height
    end

    def get_image filename
      Gosu::Image.new filename
    end
  end
end
