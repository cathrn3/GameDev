Shell = Object:extend(Object)

function Shell:new(color, code)
  self.color = color
  self.code = code
end

function Shell:cursor(mouse_x, mouse_y)
  
end

function Shell:display(x, y, w, h)
  -- direct x,y and target w,h
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", x, y, w, h)
  love.graphics.draw(alphnum[self.code], x + w/4, y + h/4, 0, w/alphnum[self.code]:getWidth()/2, h/alphnum[self.code]:getHeight()/2)
end

function Shell:int(x, y, w, h)
  
end

function Shell:insp()
  -- centered
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", window_x/2 - 150, window_y/2 - 150, 300, 300)
  love.graphics.draw(alphnum[self.code], window_x/2 - 75, window_y/2 - 75, 0, 150/alphnum[self.code]:getWidth(), 150/alphnum[self.code]:getHeight())
end

function Shell:mousereleased(x, y, button)
  
end