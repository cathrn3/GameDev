Gamestate = require "hump.gamestate"
Object = require "objects.classic"
Timer = require "hump.timer"
local menu = require "states.menu"
love.window.setMode(1536, 864,{resizable = true, highdpi = true, fullscreen = true}) -- Just to make the screen resizable, and this method works with HighDpi
push = require "push"
window_x, window_y = 1536, 864 --fixed game resolution
cur_x, cur_y = love.window.getDesktopDimensions()
push:setupScreen(window_x, window_y, cur_x, cur_y, {fullscreen = true})


function love.load()
  require "objects.inventory"
  require "objects.dial"
  require "objects.lock"
  require "objects.moveable"
  Gamestate.registerEvents()
  Gamestate.switch(menu)
  hand_cursor = love.mouse.getSystemCursor("hand")
  arrow_cursor = love.mouse.getSystemCursor("arrow")
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