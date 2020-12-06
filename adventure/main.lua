Gamestate = require "hump.gamestate"
Object = require "classic"

-- new states
local menu = {}
local room1 = {}
local room2 = {}

function love.load()
  require "player"
  require "inventory"
  
  sword = love.graphics.newImage("sword.png")
  sword2 = love.graphics.newImage("sword.png")
  swordw, swordh = sword:getDimensions()
  swordx = 300
  swordy = 100
  
  playerw, playerh = love.graphics.newImage("walking/front1.png"):getDimensions()
  player = Player()
  inventory = Inventory()
  Gamestate.registerEvents()
  Gamestate.switch(room1)
  
  window_height = love.graphics.getHeight()
  window_width = love.graphics.getWidth()
  
  bool = true
end

function love.draw()
  player:draw()
  inventory:draw()
end

function love.update(dt)
  player:update(dt)
  inventory:update(player.x, player.y)
end

function room1:draw()
  love.graphics.setBackgroundColor(0,0,0)
  if bool then
    love.graphics.draw(sword, swordx, swordy, 0, .1, .1)
  end
end

function room1:update()
  if player.y > window_height then
    Gamestate.switch(room2)
    player.y = 0
  elseif player.y < 0 then
    player.y = 0
  elseif player.x < 0 or player.x > window_width then
    player.x = 0
  end
end

function room2:draw()
  love.graphics.setBackgroundColor(1,0,0)
  if player.y < 0 then
    Gamestate.switch(room1)
    player.y = window_height
  end
end
  
  
