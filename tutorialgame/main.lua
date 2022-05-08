function love.load()
  xCloud = 0
  imageCloud = love.graphics.newImage("textures/cloud.png")
  imageGrass = love.graphics.newImage("textures/grass.png")
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  require ("ents")
end

function love.draw()
  love.graphics.setColor(.7, .9, 1)
  love.graphics.rectangle('fill',0, 0, width, height)
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(imageCloud, xCloud - 220, 100, 0, 1.5, 1, 0,0)
  love.graphics.setColor(1,0,0)
  love.graphics.draw(imageGrass, (width - 256*4)/2, height - 64*4, 0, 4, 4, 0,0)
end

function love.update(dt)
    xCloud = xCloud + 80*dt
    if xCloud >= (love.graphics.getWidth() + 220) then
      xCloud = 0
    end
end
