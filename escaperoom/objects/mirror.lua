Mirror = Object:extend(Object)

function Mirror:new(img)
  self.img = img
end

function Mirror:cursor(mouse_x, mouse_y)
  
end

function Mirror:display(x, y, w, h)
  -- direct x,y and target w,h
  --love.graphics.draw(self.img, x, y, 0, w/self.img:getWidth(), h/self.img:getHeight())
  love.graphics.rectangle("fill", x, y, w, h)
end

function Mirror:int(x, y, w, h)
  --love.graphics.draw(self.img, x, y, 0, w/self.img:getWidth(), h/self.img:getHeight())
  love.graphics.rectangle("fill", x, y, w, h)
end

function Mirror:insp()
  -- centered
  --love.graphics.draw(self.img, window_x/2 - 150, window_y/2 - 200, 0, 300/self.img:getWidth(), 400/self.img:getHeight())
  love.graphics.rectangle("fill", window_x/2 - 150, window_y/2 - 200, 300, 400)
end

function Mirror:mousereleased(x, y, button)
  
end