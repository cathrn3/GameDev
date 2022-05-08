Object = require "classic"

function love.load()
  window_x, window_y = love.graphics.getDimensions()
  player_x, player_y = window_x/2, window_y/2
  player_w, player_h = 40, 40
  base_thickness = 8
  light_x, light_y = window_x/2, window_y/6
  light_on = true
  inventory_on = false
  require "inventory"
  inventory = Inventory()
  -- love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
end

function love.draw()
  -- floor 
  love.graphics.setColor(40/255, 40/255, 40/255)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y)
  -- wall
  love.graphics.setColor(60/255, 60/255, 80/255)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y/4)
  love.graphics.setColor(30/255, 30/255, 40/255)
  love.graphics.rectangle("fill", 0, window_y/4, window_x, base_thickness)
  -- character (placeholder)
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("fill", player_x, player_y, player_w, player_h)
  -- light switch
  love.graphics.rectangle("fill", light_x, light_y, 7, 10)
  if player_x < light_x + player_w and player_x > light_x - player_w*2 and player_y < window_y/6 + player_h + 10 then 
    love.graphics.print("[E]", light_x - 5, light_y - 20)
  end
  if not light_on then 
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill", 0,0,window_x,window_y)
  end
  -- inventory
  inventory:draw(inventory_on)
end

function love.update(dt)
  -- player movement
  if love.keyboard.isDown("down") and not collision(player_x, player_y + 5) then
    player_y = player_y + 5
  elseif love.keyboard.isDown("up") and not collision(player_x, player_y - 5) then
    player_y = player_y - 5
  elseif love.keyboard.isDown("left") and not collision(player_x - 5, player_y) then
    player_x = player_x - 5
  elseif love.keyboard.isDown("right") and not collision(player_x + 5, player_y) then
    player_x = player_x + 5
  end  
end

function collision(x, y)
  if x < 0  or x > window_x - player_w or y < window_y/4 - player_h + base_thickness or y > window_y - player_h then
    return true
  else 
    return false
  end
end

function love.keypressed(key)
  if key == "i" then
    inventory_on = not inventory_on 
  end
  if key == "e" then
    if player_x < light_x + player_w and player_x > light_x - player_w*2 and player_y < window_y/6 + player_h + 10 then
      light_on = not light_on
    end
  end
end