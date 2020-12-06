Paddle = Object:extend()
function Paddle:new(x,y, width, height, up, down)
  self.x = x
  self.y = y
  self.height = height
  self.width = width
  self.up = up
  self.down = down
  speed = 300
end

function Paddle:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Paddle:update(dt, by)
  --self.y = by - self.width
  if love.keyboard.isDown(self.up) then
    self.y = self.y - speed * dt
  end
  if love.keyboard.isDown(self.down) then
    self.y = self.y + speed * dt
  end
  --dont go off screen
  if self.y < 0 then
    self.y = 0
  end
  if self.y + self.height > window_height then
    self.y = window_height - self.height
  end
end