Player = Object:extend(Object)

function Player:new()
  self.x = 0
  self.y = 0
  self.speed = 100
  front = {}
  back = {}
  left = {}
  right = {}
  for i=1,6 do
      table.insert(front, love.graphics.newImage("walking/front" .. i .. ".png"))
      table.insert(back, love.graphics.newImage("walking/back" .. i .. ".png"))
      table.insert(left, love.graphics.newImage("walking/left" .. i .. ".png"))
      table.insert(right, love.graphics.newImage("walking/right" .. i .. ".png"))
  end
  frontFrame = 1
  backFrame = 1
  leftFrame = 1
  rightFrame = 1
  var = front
  
end

function Player:draw()
  love.graphics.draw(var[1], self.x, self.y, 0, .5, .5 )
  if love.keyboard.isDown("down") then
    love.graphics.draw(front[math.floor(frontFrame)], self.x, self.y, 0, .5, .5 )
  elseif love.keyboard.isDown("up") then
    love.graphics.draw(back[math.floor(backFrame)], self.x, self.y, 0, .5, .5 )
  elseif love.keyboard.isDown("left") then
    love.graphics.draw(left[math.floor(leftFrame)], self.x, self.y, 0, .5, .5 )
  elseif love.keyboard.isDown("right") then
    love.graphics.draw(right[math.floor(rightFrame)], self.x, self.y, 0, .5, .5 )
  end
end

function Player:update(dt)
  if love.keyboard.isDown("down") then
    self.y = self.y + self.speed * dt
    frontFrame = frontFrame + 5 * dt
    if frontFrame >= 6 then
        frontFrame = 1
    end
    var = front
  end
  if love.keyboard.isDown("up") then
    self.y = self.y - self.speed * dt
      backFrame = backFrame + 5 * dt
    if backFrame >= 6 then
        backFrame = 1
    end
    var = back
  end
  if love.keyboard.isDown("left") then
    self.x = self.x - self.speed * dt
    leftFrame = leftFrame + 5 * dt
    if leftFrame >= 6 then
        leftFrame = 1
    end
    var = left
  end
  if love.keyboard.isDown("right") then
    self.x = self.x + self.speed * dt
    rightFrame = rightFrame + 5 * dt
    if rightFrame >= 6 then
        rightFrame = 1
    end
    var = right
  end
end