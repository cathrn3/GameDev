function love.draw()
  love.graphics.circle("line", 50, 50, 50)
  love.graphics.line(50, 50, x2, y2)
end

function love.load()
  angle = 0
  x1 = 0
  y1 = 0
  y2 = 0
  x2 = 0
end

function love.update(dt)
  y2 = 50 + 50 * math.sin(angle)
  x2 = 50 + 50 * math.cos(angle)
  angle = angle + math.pi / 36
end
    
