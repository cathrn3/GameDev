Moveable = Object:extend(Object)

function Moveable:new(x, y, w, h, speed, color)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.speed = speed
  self.color_r, self.color_g, self.color_b = color
end

function Moveable:draw()
  love.graphics.setColor(self.color_r, self.color_g, self.color_b)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Moveable:update(dt)
  if love.keyboard.isDown("down") then
    self.y = self.y + self.speed * dt
  elseif love.keyboard.isDown("up") then
    self.y = self.y - self.speed * dt
  elseif love.keyboard.isDown("right") then
    self.x = self.x + self.speed * dt
  elseif love.keyboard.isDown("left") then
    self.x = self.x - self.speed * dt
  end
  
  -- wall_collision
  if self.x < 0 then
    self.x = 0
  elseif self.x + self.w > window_x then
    self.x = window_x - self.w
  end
  
  if self.y < window_y/3 - self.h then 
    self.y = window_y/3 - self.h
  elseif self.y + self.h > window_y then
    self.y = window_y - self.h
  end
end