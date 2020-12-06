Dial = Object.extend(Object)
--draw a dial at location x,y
function Dial:new(x,y, keypressright, keypressleft)
    self.keypressright = keypressright
    self.keypressleft = keypressleft
    self.angle = 0
    self.radius = 50
    self.x1 = x
    self.x2 = x + self.radius
    self.y1 = y
    self.y2 = y
    self.x3 = x
    self.y3 = y - self.radius
    self.x4 = x - self.radius
    self.y4 = y
    self.x5 = x
    self.y5 = y + self.radius
end

function Dial:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.circle("fill", self.x1, self.y1, self.radius)
  love.graphics.setLineWidth(1)
  love.graphics.setColor(0,0,0)
  love.graphics.line(self.x1,self.y1, self.x2, self.y2)
  love.graphics.line(self.x1, self.y1, self.x3, self.y3)
  love.graphics.line(self.x1, self.y1, self.x4, self.y4)
  love.graphics.line(self.x1, self.y1, self.x5, self.y5)
  --love.graphics.setColor(255,255,255)
end

function Dial:update()
  if love.keyboard.isDown(self.keypressleft) then
    self.y2 = self.y1 + 50 * math.sin(self.angle)
    self.x2 = self.x1 + 50 * math.cos(self.angle)
    self.y3 = self.y1 + 50 * math.sin(self.angle - math.pi/2)
    self.x3 = self.x1 + 50 * math.cos(self.angle - math.pi/2)
    self.y4 = self.y1 + 50 * math.sin(self.angle + math.pi)
    self.x4 = self.x1 + 50 * math.cos(self.angle + math.pi)
    self.y5 = self.y1 + 50 * math.sin(self.angle + math.pi/2)
    self.x5 = self.x1 + 50 * math.cos(self.angle + math.pi/2)
    self.angle = self.angle + math.pi / 48
  elseif love.keyboard.isDown(self.keypressright) then
    self.y2 = self.y1 + 50 * math.sin(self.angle)
    self.x2 = self.x1 + 50 * math.cos(self.angle)
    self.y3 = self.y1 + 50 * math.sin(self.angle - math.pi/2)
    self.x3 = self.x1 + 50 * math.cos(self.angle - math.pi/2)
    self.y4 = self.y1 + 50 * math.sin(self.angle + math.pi)
    self.x4 = self.x1 + 50 * math.cos(self.angle + math.pi)
    self.y5 = self.y1 + 50 * math.sin(self.angle + math.pi/2)
    self.x5 = self.x1 + 50 * math.cos(self.angle + math.pi/2)
    self.angle = self.angle - math.pi / 48
  end
end  