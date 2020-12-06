Gamestate = require "hump.gamestate"
Timer = require "hump.timer"
local menu = {}
local game = {}

function love.load()
  lume = require "lume"
  Gamestate.registerEvents()
  Gamestate.switch(menu)
  --colors
  red = {1, 0, 0}
  orange = {1, 90/255, 30/255}
  yellow = {1, 1, 0}
  green = {0, 128/255, 0}
  blue = {0, 0, 1}
  purple = {75/255, 0,130/255}
  black = {0,0,0}
  white = {1, 1, 1}
  
  --game properties
  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()
  penx = 70
  peny = 80
  penSize = 6
  penColor = black
  penbeen = {}
  screenColor = white
  screenLeft = 60
  screenRight = windowWidth - 2*screenLeft
  screenTop = 70
  screenBottom = windowHeight - 150 
  --button coordinates
  colorStartX = screenLeft + 100
  colorStartY = screenBottom + 30
  colorBoxHeight = 40
  colorBoxWidth = 40
  clearX= colorStartX + 270
  clearY = colorStartY + 60
  backx = colorStartX + 60
  backy = clearY
  buttonWidth = 140
  buttonHeight = 50
  -- on menu
  playX = windowWidth / 2 - buttonWidth/2
  playY = windowHeight / 3
  exitX = playX
  exitY = playY + 120
  
  --dial class
  Object = require "classic"
  require "dial"
  d1 = Dial(screenLeft, screenBottom + 70,'a','d')
  d2 = Dial(screenRight, screenBottom + 70, 'j', 'l')
  require "button"
  -- color button
  b1 = Button('fill', colorStartX, red, (function () changecolor(red) end))
  b2 = Button('fill', colorStartX + 70, orange, (function () changecolor(orange) end))
  b3 = Button('fill', colorStartX + 140, yellow, (function () changecolor(yellow) end))
  b4 = Button('fill', colorStartX + 210, green, (function () changecolor(green) end))
  b5 = Button('fill', colorStartX + 280, blue, (function () changecolor(blue) end))
  b6 = Button('fill', colorStartX + 350, purple, (function () changecolor(purple) end))
  b7 = Button('line', colorStartX + 420, white, (function() changecolor(black) end))
end


function menu:draw()
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle('fill', playX, playY, buttonWidth, buttonHeight)
  love.graphics.rectangle("fill", exitX, exitY, buttonWidth, buttonHeight)
  love.graphics.setNewFont(40)
  love.graphics.setColor(0,0,0)
  love.graphics.print('PLAY', playX + 10, playY)
  love.graphics.print('EXIT', exitX + 10, exitY)
end

function menu:update()
  local mx, my = love.mouse.getPosition()
  if insideBox(mx, my, playX, playY, buttonWidth, buttonHeight) and love.mouse.isDown(1) then
    return Gamestate.switch(game)
  end
  if insideBox(mx, my, exitX, exitY, buttonWidth, buttonHeight) and love.mouse.isDown(1) then
    love.event.quit()
  end
end

function game:draw()
    --title
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.print("~Etch-a-Sketch~",270,30)
    --draw screen
    love.graphics.setColor(screenColor[1], screenColor[2],screenColor[3])
    love.graphics.rectangle("fill", screenLeft, screenTop, screenRight, screenBottom-screenTop)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", clearX, clearY, buttonWidth, buttonHeight)
    love.graphics.rectangle("line", backx, backy, buttonWidth, buttonHeight)
    love.graphics.newFont(20)
    love.graphics.print("CLEAR", clearX + 20, clearY + 5)
    love.graphics.print("BACK", backx + 30, backy + 5)
    --draw dials and color buttons
    d1:draw()
    d2:draw()
    b1:draw()
    b2:draw()
    b3:draw()
    b4:draw()
    b5:draw()
    b6:draw()
    b7:draw()
    --etch a sketch part
    love.graphics.rectangle("fill", penx, peny, penSize, penSize)
    if love.filesystem.getInfo("savedata.txt") then
      file = love.filesystem.read("savedata.txt")
      data = lume.deserialize(file)
      --love.graphics.rectangle("fill", data.pen[1], data.pen[2], penSize, penSize)
      for i,v in ipairs(data.penbeen) do
        penbeen[i] = data.penbeen[i]
      end
    end
    for i = 1, #penbeen do
      love.graphics.setColor(penbeen[i][3])
      love.graphics.rectangle("fill", penbeen[i][1], penbeen[i][2], penSize, penSize)
    end
end

function game:update()
  d1:update()
  d2:update()
  if love.mouse.isDown(1) then
    mx,my = love.mouse.getPosition()
    b1:update(mx, my)
    b2:update(mx, my)
    b3:update(mx, my)
    b4:update(mx, my)
    b5:update(mx, my)
    b6:update(mx, my)
    b7:update(mx, my)
    if insideBox(mx, my, clearX, clearY, buttonWidth, buttonHeight) then
      penbeen = {}
      penx = 70
      peny = 80
      love.filesystem.remove("savedata.txt")
      game:draw()
    end
    if insideBox (mx, my, backx, backy, buttonWidth, buttonHeight) then
      saveGame()
      Gamestate.switch(menu)
    end
  end
  -- a goes to the left and d goes to the right
  if love.keyboard.isDown('a') then
    penx = penx - 1
  elseif love.keyboard.isDown('d') then
    penx = penx + 1
  end
  -- j goes down and l goes up
  if love.keyboard.isDown('j') then
    peny = peny + 1
  elseif love.keyboard.isDown('l') then
    peny = peny - 1
  end
  --border collision
  if penx == screenLeft then
    penx = penx + 1
  end
  if penx == screenRight then
    penx = penx - 1
  end
  if peny == screenTop then
    peny = peny + 1
  end
  if peny == screenBottom then
    peny = peny - 1
  end
  if penbeen == {} then
    table.insert(penbeen,{penx, peny, penColor})
  end
  
  --if new location is not already in penbeen, add it to penbeen
  table.insert(penbeen, {penx, peny, penColor})
  newloc = {penx,peny, penColor}
  found = false
  for i = 1, #penbeen do
    if comparetable(penbeen[i], newloc) == true then
      found = true
    end
  end
  if found == false then
    table.insert(penbeen, newloc)
  end
end

--compares two tables
function comparetable(t1,t2)
    if #t1 == #t2 then
      for i = 1, #t1 do
        if t1[i] ~= t2[i] then
          return false
        end
      end
      return true
    else
      return false
    end
end

function changecolor(color)
  penColor = color
end

function saveGame()
  data = {}
  data.penbeen = {}
  --data.pen = {penx, peny}
  for i,v in ipairs(penbeen) do
    data.penbeenin = {}
    for j,v in ipairs(penbeen[i]) do
      table.insert(data.penbeenin, penbeen[i][j])
    end
    table.insert(data.penbeen, data.penbeenin)
  end
  serialized = lume.serialize(data)
  love.filesystem.write("savedata.txt", serialized)
end

function insideBox(mx, my, x,y,width,height)
  if mx >= x and mx <= x + width and my >= y and my <= y + height then
    return true
  end
end
  