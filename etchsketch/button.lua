Button = Object.extend(Object)

function Button:new(mode, x, color, callback)
  -- x,y is coordinates for the upper left corner of the palette block
  self.x = x
  self.callback = callback
  self.color = color
  self.mode = mode
end

function Button:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle(self.mode, self.x, colorStartY, colorBoxWidth, colorBoxHeight)
end

function Button:update(mx, my)
  if mx >= self.x and mx <= self.x+colorBoxWidth and my>= colorStartY and my <= colorStartY+colorBoxHeight then
    self.callback()
  end
end