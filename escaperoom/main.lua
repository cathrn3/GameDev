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
  Gamestate.registerEvents()
  Gamestate.switch(menu)
  hand_cursor = love.mouse.getSystemCursor("hand")
  arrow_cursor = love.mouse.getSystemCursor("arrow")
  
  -- alphnum
  alphnum = {}
  for i = 0, 35 do
    local new_image = love.graphics.newImage("resources/star_room/alphnum/" .. i .. ".png")
    table.insert(alphnum, new_image)
  end
end

function near_object(x1, y1, w1, h1, x2, y2, w2, h2, x_pad, y_pad)
  -- checks if object one is close to object two, allowing for a x and y padding
  x_pad = x_pad or 10
  y_pad = y_pad or 10
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