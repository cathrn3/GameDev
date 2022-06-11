Lock = Object:extend(Object)

function Lock:new(dials, unopened, opened, code)
  self.open = false
  self.dials = dials
  -- unopened and opened should be a table of an image, the image x and y coords, the image width and height
  self.u_img, self.u_x, self.u_y, self.u_w, self.u_h = unopened[1], unopened[2], unopened[3], unopened[4], unopened[5]
  self.o_img, self.o_x, self.o_y, self.o_w, self.o_h = opened[1], opened[2], opened[3], opened[4], opened[5]
  -- should be a table of numbers/letters in the order of the correct combination
  self.code = code
end

function Lock:draw()
  love.graphics.setColor(1,1,1)
  if self.open then
    love.mouse.setCursor(arrow_cursor)
    -- TODO: improve this, lags after subsequent opens
    love.timer.sleep(1)
    love.graphics.draw(self.o_img, self.o_x - self.o_w/2, self.o_y - self.o_h/2, 0, self.o_w/self.o_img:getWidth(), self.o_h/self.o_img:getHeight())
  else 
    love.graphics.draw(self.u_img, self.u_x - self.u_w/2, self.u_y - self.u_h/2, 0, self.u_w/self.u_img:getWidth(), self.u_h/self.u_img:getHeight())
    local temp = true
    for i = 1, #self.dials do
      self.dials[i]:draw()
      if self.dials[i].current_index ~= self.code[i] then
        temp = false
      end
    end
    if temp then
      self.open = true
    end
  end
end

function Lock:update(mouse_x, mouse_y, dt)
  if not self.open then
    for i = 1, #self.dials do
      if self.dials[i]:update(mouse_x, mouse_y, dt) then
        break
      end
    end
  end
end

function Lock:mousereleased(x, y, button)
  for i = 1, #self.dials do
    self.dials[i]:mousereleased(x, y, button)
  end
end