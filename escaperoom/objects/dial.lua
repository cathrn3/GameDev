Dial = Object:extend(Object)

function Dial:new(lock_type, orientation, x, y, w, h)
  -- type is a str: "num" or "alph"
  self.lock_type = lock_type
  -- orientation is a str: "horizontal" or "vertical"
  self.orientation = orientation
  -- shift origin to center
  self.x, self.y, self.w, self.h = x - w/2, y - h/2, w, h
  alphnum = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
  if self.lock_type == "num" then
    self.current_index = 1 
  else
    self.current_index = 11
  end
end

function Dial:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(.8, .8, .8)
  if self.orientation == "horizontal" then
    love.graphics.rectangle("fill", self.x, self.y, self.w/4, self.h)
    love.graphics.rectangle("fill", self.x + 3*self.w/4, self.y, self.w/4, self.h)
  else
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h/4)
    love.graphics.rectangle("fill", self.x, self.y + 3*self.h/4, self.w, self.h/4)
  end
  
  test = love.graphics.newImage("resources/star_room/alphnum/" .. alphnum[self.current_index] .. ".png")
  love.graphics.draw(test, self.x + self.w/2 - self.w/8, self.y + self.h/2 - 1.2*(self.w/8), 0, self.w/4/test:getWidth(), 1.2*(self.w/4)/test:getHeight())
end

function Dial:update(dt, mouse_x, mouse_y)
  if self.orientation == "horizontal" and (near_object(mouse_x, mouse_y, 0, 0, self.x, self.y, self.w/4, self.h, 0, 0) or near_object(mouse_x, mouse_y, 0, 0, self.x + 3*self.w/4, self.y, self.w/4, self.h, 0, 0)) then
    love.mouse.setCursor(hand_cursor)
    return true
  elseif self.orientation == "vertical" and (near_object(mouse_x, mouse_y, 0, 0, self.x, self.y, self.w, self.h/4, 0, 0) or near_object(mouse_x, mouse_y, 0, 0, self.x, self.y + 3*self.h/4, self.w, self.h/4, 0, 0)) then
    love.mouse.setCursor(hand_cursor)
    return true
  else
    love.mouse.setCursor(arrow_cursor)
    return false
  end
end

function Dial:update_down()
  if self.lock_type == "num" and self.current_index == 1 then
    self.current_index = 10
  elseif self.lock_type == "alph" and self.current_index == 11 then
    self.current_index = 36
  else
    self.current_index = self.current_index - 1
  end
end

function Dial:update_up()
  if self.lock_type == "num" and self.current_index == 10 then
    self.current_index = 1
  elseif self.lock_type == "alph" and self.current_index == 36 then
    self.current_index = 11
  else
    self.current_index = self.current_index + 1
  end
end
