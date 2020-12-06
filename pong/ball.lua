Ball = Object:extend() 

function Ball:new(x, y, width, height, pwidth, pheight)
  self.x = x 
  self.y = y
  self.width = width
  self.height = height
  startspeed = 1
  startx = -110
  starty = 20
  self.pwidth = pwidth
  self.pheight = pheight
end

function Ball:draw()
  love.graphics.setColor(1,0,0)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(1,1,1)
end

function Ball:update(dt, p1x, p1y, p2x, p2y)
  if self.x + self.width < 0 or self.x > love.graphics.getWidth() then
    self.x = window_width/2
    self.y = window_height/2
    startspeed = 1
  end
  --print (self.p1y)
  self.x = self.x - (startspeed* startx *dt)
  self.y = self.y + startspeed * starty *dt
  --if it hits the right paddle
  if self.x <= p1x + self.pwidth and self.y <= p1y + self.pheight and self.y + self.height >= p1y then
    startx = -1 * startx
    startspeed = startspeed + .5
  end
  --if it hits the left paddle
  if self.x + self.width >= p2x and self.y <= p2y + self.pheight and self.y + self.height >= p2y then
    startx = -1 * startx
    startspeed = startspeed + .5
  end
  --if it hits a wall
  if self.y <= 0 or self.y + self.height >= love.graphics.getHeight() then
    starty = -1 * starty
  end
end 