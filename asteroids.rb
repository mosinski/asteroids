require 'ruby2d'

require './lib/ship'
require './lib/asteroid'

##
# Window
##

set title: 'Asteroids',
    background: 'black',
    with: 640,
    height: 480,
    resizable: false

##
# Bullets
##

bullets = []

##
# Asteroids
##

asteroids = []

##
# Ship
##

ship = Ship.new(
  x1: get(:width) / 2, y1: get(:height) / 2 - 20,
  x2: get(:width) / 2 + 10, y2: get(:height) / 2 + 12,
  x3: get(:width) / 2 - 10, y3: get(:height) / 2 + 12,
  window: get(:window),
  color: 'white'
)

# Ship move
on :key_held do |event|
  ship.move(event, left: 'left', right: 'right', up: 'up')
end

# Ship shoot
on :key_down do |event|
  if event.key == 'space'
    bullets << ship.shoot
  end
end

update do
  ship.fly

  (5 - asteroids.size).times do
    asteroids << Asteroid.new(window: get(:window))
  end

  bullets.each do |bullet|
    bullet.scored.each do |asteroid|
      asteroid.source.remove
      asteroids.delete(asteroid)
    end
    bullet.move(window: get(:window), asteroids: asteroids)
  end

  asteroids.each do |asteroid|
    asteroid.move
  end
end

show
