require 'gosu'

module Turbonovo
  class Wrapper
    def milliseconds
      Gosu::milliseconds
    end

    def translate(x, y, &block)
      Gosu::translate(x, y) { block.call }
    end
  end
end
