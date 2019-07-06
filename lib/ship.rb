# Deals with the logic of the asteroids ship.
# @author Miłosz Osiński <milosz@icoded.com>

require './lib/bullet'
require 'ostruct'

class Ship < Triangle
  DEFAULTS = { speed: 0 }.freeze

  attr_accessor :background, :speed, :angle, :rotation, :args

  # @api public
  # @param speed [Integer, Float, nil] ship's initialize speed
  # @param constraints [Hash] ship's constraints (e.g. max "y")
  # @return [Ship]
  def initialize(speed: DEFAULTS[:speed], **args)
    @args = args
    @angle = 0
    @rotation = 0
    @speed = speed

    super(args)
  end

  # @api public
  # @param event [Ruby2D::Window::KeyEvent] event captured from keyboard
  def move(event, left:, right:, up:)
    if move_up?(event, up)
      radians = (angle - 90) * Math::PI / 180
      self.speed += 0.1 if speed < 4
      self.rotation = 0
      accelerate(radians)
    elsif move_left?(event, left)
      self.angle = (angle - 3) % 360
      self.rotation = (rotation - 3) % 360
      rotate(rotation)
    elsif move_right?(event, right)
      self.angle = (angle + 3) % 360
      self.rotation = (rotation + 3) % 360
      rotate(rotation)
    end
  end

  # @api public
  # @return [Bullet] ship's bullet object
  def shoot
    Bullet.new(
      size: 3,
      speed: 5,
      x: self.x1,
      y: self.y1,
      angle: self.angle
    )
  end

  # @api public
  # @return [Bullet] ship's bullet object
  def fly
    check_edge_collision

    radians = (angle - 90) * Math::PI / 180
    self.rotation = 0

    if speed > 0
      self.speed -= 0.03
    else
      self.speed = 0
    end

    accelerate(radians)
  end

  private

  # @api private
  # @param event [Ruby2D::Window::KeyEvent] event captured from keyboard
  # @param up [String] expected keyboard key for the up movement
  # @return [Boolean] is it allowed to move up?
  def move_up?(event, up)
    event.key == up
  end

  # @api private
  # @param event [Ruby2D::Window::KeyEvent] event captured from keyboard
  # @param up [String] expected keyboard key for the up movement
  # @return [Boolean] is it allowed to move up?
  def move_left?(event, left)
    event.key == left
  end

  # @api private
  # @param event [Ruby2D::Window::KeyEvent] event captured from keyboard
  # @param down [String] expected keyboard key for the down movement
  # @return [Boolean] is it allowed to move down?
  def move_right?(event, right)
    event.key == right
  end

  def accelerate(radians)
    self.args[:x1] = self.x1 += Math.cos(radians) * speed
    self.args[:y1] = self.y1 += Math.sin(radians) * speed
    self.args[:x2] = self.x2 += Math.cos(radians) * speed
    self.args[:y2] = self.y2 += Math.sin(radians) * speed
    self.args[:x3] = self.x3 += Math.cos(radians) * speed
    self.args[:y3] = self.y3 += Math.sin(radians) * speed
  end

  def rotate(degrees)
    radians = degrees * Math::PI / 180

    self.x1 = center.x + (args[:x1] - center.x) * Math.cos(radians) - (args[:y1] - center.y) * Math.sin(radians)
    self.y1 = center.y + (args[:x1] - center.x) * Math.sin(radians) + (args[:y1] - center.y) * Math.cos(radians)

    self.x2 = center.x + (args[:x2] - center.x) * Math.cos(radians) - (args[:y2] - center.y) * Math.sin(radians)
    self.y2 = center.y + (args[:x2] - center.x) * Math.sin(radians) + (args[:y2] - center.y) * Math.cos(radians)

    self.x3 = center.x + (args[:x3] - center.x) * Math.cos(radians) - (args[:y3] - center.y) * Math.sin(radians)
    self.y3 = center.y + (args[:x3] - center.x) * Math.sin(radians) + (args[:y3] - center.y) * Math.cos(radians)
  end

  def center
    x = (args[:x1] + args[:x2] + args[:x3]).to_f / 3.0
    y = (args[:y1] + args[:y2] + args[:y3]).to_f / 3.0

    OpenStruct.new(x: x, y: y)
  end

  # @api private
  # @param axis [Symbol] which axis to check the collision
  # @param window [Window] the game's window
  # @return [Symbol] edge side where ball has collided
  def check_edge_collision(window: args[:window])
    if [x1, x2, x3].all? { |x| x >= window.get(:width) } ||  [x1, x2, x3].all? { |x| x <= 0 }
      self.x1 = self.args[:x1] %= window.get(:width)
      self.x2 = self.args[:x2] %= window.get(:width)
      self.x3 = self.args[:x3] %= window.get(:width)
    elsif [y1, y2, y3].all? { |y| y >= window.get(:height) } || [y1, y2, y3].all? { |y| y <= 0 }
      self.y1 = self.args[:y1] %= window.get(:height)
      self.y2 = self.args[:y2] %= window.get(:height)
      self.y3 = self.args[:y3] %= window.get(:height)
    end
  end
end
