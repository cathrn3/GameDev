local room2 = {}

function room2:enter()
  passed = false
end

function room2:draw()
  love.graphics.setBackgroundColor(0, 1, 0)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y/3)
  player:draw()
end

function room2:update(dt)
  player:update(dt)
end

function room2:keyreleased(key, code)

end

return room2