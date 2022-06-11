Notebook = Object:extend(Object)

function Notebook:new(pages)
  self.pages = pages
  self.current = 1
  self.interact = true
end

function Notebook:cursor(mouse_x, mouse_y)
  if self.current == 1 and near_object(mouse_x, mouse_y, 0, 0, window_x/2 - 200, window_y/2 - 200, 400, 400, 0, 0) then
    love.mouse.setCursor(hand_cursor)
  elseif self.current ~= 1 and near_object(mouse_x, mouse_y, 0, 0, window_x/2 - 300, window_y/2 - 200, 600, 400, 0, 0) then
    love.mouse.setCursor(hand_cursor)
  else
    love.mouse.setCursor(arrow_cursor)
  end
end

function Notebook:display(x, y, w, h)
  -- direct x,y and target w,h
  love.graphics.draw(self.pages[1], x, y, 0, w/self.pages[1]:getWidth(), h/self.pages[1]:getHeight())
end

function Notebook:int(x, y, w, h)
  
end

function Notebook:insp()
  -- centered
  if self.current == 1 then
    love.graphics.draw(self.pages[self.current], window_x/2 - 200, window_y/2 - 200, 0, 400/self.pages[self.current]:getWidth(), 400/self.pages[self.current]:getHeight())
  else
    love.graphics.draw(self.pages[self.current], window_x/2 - 300, window_y/2 - 200, 0, 600/self.pages[self.current]:getWidth(), 400/self.pages[self.current]:getHeight())
  end
end

function Notebook:mousereleased(x, y, button)
  if self.current == 1 then
    if near_object(x, y, 0, 0, window_x/2 - 200, window_y/2 - 200, 400, 400, 0, 0) then
      self.current = 2
    end
  else
    if near_object(x, y, 0, 0, window_x/2 - 300, window_y/2 - 200, 300, 400, 0, 0) then
      self.current = self.current - 1
    elseif near_object(x, y, 0, 0, window_x/2, window_y/2 - 200, 300, 400, 0, 0) then
      if self.current ~= #self.pages then
        self.current = self.current + 1
      end
    end
  end
end