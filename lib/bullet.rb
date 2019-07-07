# Deals with the logic of the asteroids bullet.
# @author Miłosz Osiński <milosz@icoded.com>

require 'ostruct'
PATH = File.dirname(__FILE__)

class Bullet < Square
  DEFAULTS = { speed: 1 }.freeze

  attr_accessor :angle, :speed, :scored, :sounds

  # @api public
  # @param speed [Integer, Float, nil] speed's speed
  # @param angle [Integer] ship's current angle
  # @return [Bullet]
  def initialize(speed: DEFAULTS[:speed], angle:, **args)
    super(args)

    @scored = []
    @angle = (angle - 90) * Math::PI / 180
    @speed = speed
    @sounds = OpenStruct.new(
      fire: Sound.new(Dir.pwd + '/assets/sounds/fire.wav'),
      score: Sound.new(Dir.pwd + '/assets/sounds/bangLarge.wav')
    )

    fire
  end

  # @api public
  # @param window [Window] the game's window
  # @param asteroids [Array] the game's asteroids
  # @return [Hash] bullet's current position
  def move(window:, asteroids:)
    if edge_collision?(window)
      self.remove
      self.size = 0
    elsif asteroid_collision?(asteroids).any?
      self.scored = asteroid_collision?(asteroids)
      self.remove
      self.size = 0
      sounds.score.play
    end

    self.x += Math.cos(self.angle) * speed;
    self.y += Math.sin(self.angle) * speed;
  end

  def fire
    sounds.fire.play
  end

  private

  # @api private
  # @param window [Window] the game's window
  # @return [Boolean]
  def edge_collision?(window)
    if x >= window.get(:width) || x <= 0
      true
    elsif y >= window.get(:height) || y <= 0
      true
    end
  end

  # @api private
  # @param asteroids [Asteroid] the game's asteroids
  # @return [Boolean]
  def asteroid_collision?(asteroids)
    asteroids.select do |asteroid|
      asteroid.source.contains?(x,y)
    end
  end
end
