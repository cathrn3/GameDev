Dial = Object:extend(Object)

function Dial:new(lock_type, x, y, w, h)
  -- type is a str: "num" or "alph"
  self.lock_type = lock_type
  -- shift origin to center
  self.x, self.y, self.w, self.h = x - w/2, y - h/2, w, h
  self.current_index = 0
end

function Dial:draw()
  -- background
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  
  -- top and bottom side, a quarter of dial
  love.graphics.setColor(.8, .8, .8)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h/4)
  love.graphics.rectangle("fill", self.x, self.y + 3*self.h/4, self.w, self.h/4)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", self.x + self.w/2 - (self.w*.2)/2, self.y + self.h/8 - (self.h*.05)/2, self.w * .2, self.h * .05)
  love.graphics.rectangle("fill", self.x + self.w/2 - (self.w*.05)/2, self.y + self.h/8 - (self.h*.15)/2, self.w * .05, self.h * .15)
  love.graphics.rectangle("fill", self.x + self.w/2 - (self.w*.2)/2, self.y + 3*self.h/4 + self.h/8 - (self.h*.05)/2, self.w * .2, self.h * .05)
  
  -- scale and center number/letter
  if self.current_index ~= 0 then
    image = alphnum[self.current_index]
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(image, self.x + self.w/2 - 1.2*(self.h/8), self.y + self.h/2 - self.h/8, 0, 1.2*(self.h/4)/image:getWidth(), self.h/4/image:getHeight())
  end
end

function Dial:update(mouse_x, mouse_y, dt)
  if (near_object(mouse_x, mouse_y, 0, 0, self.x, self.y, self.w, self.h/4, 0, 0) or near_object(mouse_x, mouse_y, 0, 0, self.x, self.y + 3*self.h/4, self.w, self.h/4, 0, 0)) then
    love.mouse.setCursor(hand_cursor)
    return true
  else
    love.mouse.setCursor(arrow_cursor)
    return false
  end
end

function Dial:update_down()
  if self.lock_type == "num" and self.current_index == 0 then
    self.current_index = 10
  elseif self.lock_type == "alph" and self.current_index == 11 then
    self.current_index = 0
  elseif self.lock_type == "alph" and self.current_index == 0 then
    self.current_index = 36
  else
    self.current_index = self.current_index - 1
  end
end

function Dial:update_up()
  if self.lock_type == "num" and self.current_index == 10 then
    self.current_index = 0
  elseif self.lock_type == "alph" and self.current_index == 36 then
    self.current_index = 0
  elseif self.lock_type == "alph" and self.current_index == 0 then
    self.current_index = 11
  else
    self.current_index = self.current_index + 1
  end
end

function Dial:mousereleased(x, y, button)
  if button == 1 then
    if near_object(x, y, 0, 0, self.x, self.y, self.w, self.h/4, 0, 0) then
      self:update_up()
    elseif near_object(x, y, 0, 0, self.x, self.y + 3*self.h/4, self.w, self.h/4, 0, 0) then
      self:update_down()
    end
  end
end
