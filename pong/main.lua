function love.load()
  Object = require "classic"
  require "paddles"
  require "ball"
  require "score"
  window_width = love.graphics.getWidth()
  window_height = love.graphics.getHeight()
  paddlewidth = 20
  paddleheight = 70
  bwidth = 12
  bheight = 12
  p1x = 10
  p1y = window_height/2 - paddleheight/2
  p2x = window_width - paddlewidth - 10
  p2y = window_height/2 - paddleheight/2
  p1 = Paddle(p1x, p1y, paddlewidth, paddleheight, 'w', 's')
  p2 = Paddle(p2x, p2y, paddlewidth, paddleheight, 'i', 'k')
  b = Ball(window_width/2, window_height/2, bwidth, bheight, paddlewidth, paddleheight)
  s1 = Score(50, 50, 'l')
  s2 = Score(window_width - 100, 50, 'r')
end

function love.draw()
  p1:draw()
  p2:draw()
  love.graphics.setLineWidth(10)
  love.graphics.line(window_width/2, 0, window_width/2, window_height)
  b:draw()
  s1:draw()
  s2:draw()
end

function love.update(dt)
  p1:update(dt,b.y)
  p2:update(dt, b.y)
  s1:update(b.x, b.y, b.width)
  s2:update(b.x, b.y, b.width)
  b:update(dt, p1.x, p1.y, p2.x, p2.y)
end