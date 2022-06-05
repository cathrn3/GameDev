local menu = {}
local star_room = require "states.star_room"

function menu:enter()
-- many lines of code
end

function menu:draw()
  push:start()
  love.graphics.print("Press Enter to continue", 10, 10)
  push:finish()
end

function menu:update(dt)
-- many lines of code
end

function menu:keyreleased(key, code)
  if key == 'return' then
    return Gamestate.switch(star_room)
  end
end

return menu