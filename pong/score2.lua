Score2 = Object:extend()
function Score2:new(x, y, score)
  self.x = x
  self.y = y
  self.score = score
end

function Score2:draw()
  love.graphics.setFont(love.graphics.newFont(50))
  love.graphics.print(tostring(self.score), self.x, self.y)
end

function Score2:update(bx, bwidth)
  if b.x + b.width < 0 then
    self.score = self.score + 1
  end
end
  