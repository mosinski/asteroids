# Deals with the logic of the asteroids bullet.
# @author Miłosz Osiński <milosz@icoded.com>
#
require 'ostruct'

class Asteroid
  DEFAULTS = { speed: 0.5 }.freeze

  attr_accessor :source, :speed, :direction, :window, :height, :width

  # @api public
  # @param speed [Integer, Float, nil] speed's speed
  # @param angle [Integer] ship's current angle
  # @return [Bullet]
  def initialize(window:)
    type = Square
    color = 'red'
    size = rand(10..50)
    x = rand(0..window.get(:width))
    y = rand(0..window.get(:height))

    @window = window
    @direction = coordinates
    @speed = DEFAULTS[:speed]
    @source = type.new(color: color, size: size, radius: size, x: x, y: y)
    @height = @width = source.size || source.radius
  end

  def move
    self.source.x += direction.x * speed
    self.source.y += direction.y * speed

    check_edge_collision
  end

  # @api private
  # @return [Symbol] edge side where ball has collided
  def check_edge_collision
    if source.x >= window.get(:width) || source.x <= 0
      self.source.x %= window.get(:width)
    elsif source.y >= window.get(:height) || source.y <= 0
      self.source.y %= window.get(:height)
    end
  end

  def coordinates
    OpenStruct.new(
      x: [-1, 1].sample,
      y: [-1, 1].sample
    )
  end
end
