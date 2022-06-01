Object = require "classic"

function love.load()
  window_x, window_y = love.graphics.getDimensions()
  player_x, player_y = window_x/2, window_y/2
  player_w, player_h = 40, 40
  print(window_x, window_y/4)
  base_thickness = 8
  light_x, light_y = window_x/2, window_y/6
  light_on = true
  inventory_on = false
  grab_chair = false
  climb_chair = false
  read_note = false
  require "inventory"
  inventory = Inventory(8)
  star_radius = 1
  bomb_radius = 10
  chair_w, chair_h = 30, 50
  chair_x, chair_y = window_x - 40, window_y/4 - chair_h + base_thickness
  background_transparency = 1
  -- love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
end

function love.draw()
  if not light_on then
    background_transparency = .7
  else
    background_transparency = 1
  end
  -- floor 
  love.graphics.setColor(40/255, 40/255, 40/255, background_transparency)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y)
  -- wall
  if light_on then
    love.graphics.setColor(.8,.8,1,1)
    wall_stars = love.graphics.newImage("wall_stars.jpg")
    love.graphics.draw(wall_stars,0,0)
  else     
    love.graphics.setColor(1,1,1,1)
    stars = love.graphics.newImage("stars.jpg")
    love.graphics.draw(stars, 0, 0)
  end
  -- wall base
  love.graphics.setColor(30/255, 30/255, 40/255, background_transparency)
  love.graphics.rectangle("fill", 0, window_y/4, window_x, base_thickness)
  -- character (placeholder)
  love.graphics.setColor(1,1,1, background_transparency)
  love.graphics.rectangle("fill", player_x, player_y, player_w, player_h)
  -- star hint
  love.graphics.rectangle("fill", window_x - 40, window_y/4 - 20, 30, 10)
  if near_note() then
    love.graphics.print("[E]", window_x - 35, window_y/4 - 40)
  end
  -- chair
  love.graphics.setColor(139/255, 69/255,19/255, background_transparency)
  love.graphics.rectangle("fill", chair_x, chair_y, chair_w, chair_h)
  if near_chair() then
    love.graphics.setColor(1,1,1)
    love.graphics.print("[M]", chair_x - 6, chair_y - 20)
    love.graphics.print("[C]", chair_x + 14, chair_y - 20)
  end
  -- light switch
  love.graphics.setColor(1,250/255, 180/255)
  love.graphics.rectangle("fill", light_x, light_y, 7, 10)
  if near_light() then 
    love.graphics.setColor(1,1,1)
    love.graphics.print("[E]", light_x - 5, light_y - 20)
  end
  --display hint
  if read_note then
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill", 0,0,window_x, window_y)
    love.graphics.setColor(1,1,1)
    note_image = love.graphics.newImage("note.jpg")
    love.graphics.draw(note_image, window_x/2 - 300, window_y/2 - 75)
  end
  -- inventory
  inventory:draw(inventory_on)
end

function love.update(dt)  
  if grab_chair then 
    chair_x = player_x + player_w
    chair_y = player_y - (chair_h - player_h)
  end
  if not climb_chair and not read_note then
    -- player movement
    if love.keyboard.isDown("down") and not collision(player_x, player_y + 5) then
      player_y = player_y + 5
    elseif love.keyboard.isDown("up") and not collision(player_x, player_y - 5) then
      player_y = player_y - 5
    elseif love.keyboard.isDown("left") and not collision(player_x - 5, player_y) then
      player_x = player_x - 5
    elseif love.keyboard.isDown("right") and not collision(player_x + 5, player_y) then
      if (grab_chair and chair_x + 5 < window_x - chair_w) or not grab_chair then
        player_x = player_x + 5
      end
    end
  end  
end

function collision(x, y)
  -- collide with wall
  if x <= 0  or x > window_x - player_w or y <= window_y/4 - player_h + base_thickness or y > window_y - player_h then 
    return true
  -- collide with chair
  elseif (x >= chair_x - chair_w - 6 and x < chair_x + chair_w and y >= chair_y - chair_h - 6 and y < chair_y + chair_h) and not grab_chair then
    return true
  else 
    return false
  end
end

function near_note()
  if player_x > window_x - 100 and player_y < window_y/4 + 5 and (chair_x < window_x - 60 or chair_y > window_y/4 + 20) then
    return true
  else 
    return false
  end
end

function near_light()
  if player_x < light_x + (player_w/2) and player_x > light_x - player_w and player_y < window_y/6 + player_h + 10 then
    return true
  else 
    return false
  end
end

function near_chair()
  if player_x >= chair_x - chair_w - 15 and player_x < chair_x + chair_w + 10 and player_y >= chair_y - chair_h - 15 and player_y < chair_y + chair_h + 10 then
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
    if near_light() then
      light_on = not light_on
    end
    if near_note() then
      read_note = not read_note
    end
  end
  if near_chair() and not read_note then 
    if key == "m" and not climb_chair then
      grab_chair = not grab_chair
    end
    if key == "c" then
      climb_chair = not climb_chair
      grab_chair = false
      if climb_chair then
        player_x = chair_x - (player_w - chair_w)/2
        player_y = chair_y - player_h
      else
        player_x = chair_x - chair_w - 15
        player_y = chair_y + (chair_h - player_h) 
      end
    end
  end
end