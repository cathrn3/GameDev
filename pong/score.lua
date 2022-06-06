Score = Object:extend()
function Score:new(x, y, score)
  self.x = x
  self.y = y
  self.score = score
end

function Score:draw()
  love.graphics.setFont(love.graphics.newFont(50))
  love.graphics.print(tostring(self.score), self.x, self.y)
end

function Score:update()
  self.score = self.score + 1
end
  