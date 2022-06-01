Gamestate = require "hump.gamestate"
Object = require "objects.classic"
Timer = require "hump.timer"
local menu = require "states.menu"

function love.load()
  require "objects.moveable"
  require "objects.inventory"
  require "objects.dial"
  require "objects.lock"
  Gamestate.registerEvents()
  Gamestate.switch(menu)
  love.window.setFullscreen(true, "desktop")
  window_x, window_y = love.graphics.getDimensions()
  player = Moveable(window_x/2 - 20, window_y/2 - 35, 40, 70, 200, {1,1,1})
  clicked = false
end

function near_object(x1, y1, w1, h1, x2, y2, w2, h2, x_pad, y_pad)
  -- checks if object one is close to object two, allowing for a x and y padding
  if x1 < x2 + w2 + x_pad and x1 + w1 > x2 - x_pad and y1 < y2 + h2 + y_pad and y1 + h1 > y2 - y_pad then
    return true
  else
    return false  
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end 
end