Lock = Object:extend(Object)

function Lock:new()
  self.opened = false
  seven = love.graphics.newImage("resources/star_room/alphnum/7.png")
  self.d1 = Dial("alph", "vertical", window_x/2 - 175, window_y/2, 50, 100)
  self.d2 = Dial("alph", "vertical", window_x/2 - 105, window_y/2, 50, 100)
  self.d3 = Dial("alph", "vertical", window_x/2 - 35, window_y/2, 50, 100)
  self.d4 = Dial("alph", "vertical", window_x/2 + 35, window_y/2, 50, 100)
  self.d5 = Dial("alph", "vertical", window_x/2 + 105, window_y/2, 50, 100)
  self.d6 = Dial("alph", "vertical", window_x/2 + 175, window_y/2, 50, 100)
  self.dials = {self.d1, self.d2, self.d3, self.d4, self.d5, self.d6}
end

function Lock:draw()
  if self.opened then
    love.timer.sleep(1)
    love.graphics.setColor(.5, .5, .5)
    love.graphics.rectangle("fill", window_x/2 - 220, window_y/2 - 300, 440, 600)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(seven, window_x/2 - 25, window_y/2 - 25, 0, 50/seven:getWidth())
  else
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", window_x/2 - 220, window_y/2 - 300, 440, 600)
    for i = 1, #self.dials do
      self.dials[i]:draw()
    end
    love.graphics.setColor(shell_colors[5][1], shell_colors[5][2], shell_colors[5][3])
    love.graphics.rectangle("fill", window_x/2 - 175 - 25, window_y/2 + 70, 50, 20)
    love.graphics.setColor(shell_colors[6][1], shell_colors[6][2], shell_colors[6][3])
    love.graphics.rectangle("fill", window_x/2 - 105 - 25, window_y/2 + 70, 50, 20)
    love.graphics.setColor(shell_colors[1][1], shell_colors[1][2], shell_colors[1][3])
    love.graphics.rectangle("fill", window_x/2 - 35 - 25, window_y/2 + 70, 50, 20)
    love.graphics.setColor(shell_colors[2][1], shell_colors[2][2], shell_colors[2][3])
    love.graphics.rectangle("fill", window_x/2 + 35 - 25, window_y/2 + 70, 50, 20)
    love.graphics.setColor(shell_colors[4][1], shell_colors[4][2], shell_colors[4][3])
    love.graphics.rectangle("fill", window_x/2 + 105 - 25, window_y/2 + 70, 50, 20)
    love.graphics.setColor(shell_colors[3][1], shell_colors[3][2], shell_colors[3][3])
    love.graphics.rectangle("fill", window_x/2 + 175 - 25, window_y/2 + 70, 50, 20) 
  end
  if self.dials[1].current_index == 13 and self.dials[2].current_index == 35 and self.dials[3].current_index == 17 and self.dials[4].current_index == 24 and self.dials[5].current_index == 31 and self.dials[6].current_index == 29 then
      self.opened = true
  end
end

function Lock:update(dt)
  if not self.opened then
    for i = 1, #lock.dials do
      status = lock.dials[i]:update(dt, mouse_x, mouse_y)
      if status then
        break
      end
    end
  end
end