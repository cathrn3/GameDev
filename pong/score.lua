Score = Object:extend()
function Score:new(x, y, side)
  self.x = x
  self.y = y
  str = 0
  self.side = side
end

function Score:draw()
  love.graphics.setFont(love.graphics.newFont(50))
  love.graphics.print(tostring(str), self.x, self.y)
end

function Score:update(bx, by, bwidth)
  --print(love.graphics.getWidth())
  if self.side == 'r' and bx > love.graphics.getWidth() then
    str = str + 1
    print(str)
  elseif self.side == 'l' and bx + bwidth < 0 then
    str = str + 1
  end
  print(str)
end
  