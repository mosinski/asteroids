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
# Score
##

score = 0

score_text = Text.new(
  "%03d" % score,
  x: 10,
  y: 10,
  font: 'assets/fonts/Audiowide.ttf',
  color: 'white',
  size: 20,
  opacity: 1
)

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
    if asteroid = bullet.scored.first
      asteroid.source.remove
      asteroids.delete(asteroid)
      score += 20
      score_text.text = "%03d" % score
      bullets.delete(bullet)
    else
      bullet.move(window: get(:window), asteroids: asteroids)
    end
  end

  asteroids.each do |asteroid|
    asteroid.move
  end
end

show
