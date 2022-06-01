local star_room = {}
local room2 = require "states.room2"

function star_room:enter()
  -- initialize
  passed, paused, moon, display_dial, move_chair, climb_chair = false
  display_lock = false
  sun = true
  current_dial = nil
  -- cursors
  hand_cursor = love.mouse.getSystemCursor("hand")
  arrow_cursor = love.mouse.getSystemCursor("arrow")
  -- images
  sun_image = love.graphics.newImage("resources/star_room/sun.png")
  moon_image = love.graphics.newImage("resources/star_room/moon.png")
  cygnus = love.graphics.newImage("resources/star_room/cygnus.png")
  shell = love.graphics.newImage("resources/star_room/shell.png")
  -- position and dimesions
  celest_r = 80
  celest_x, celest_y = window_x/2 - celest_r/2, window_y/8 - celest_r/2
  star_y, star_w = 20, 150
  -- objects
  chair = Moveable(1000, 400, 60, 50, 200, {69/255, 0, 0})
  -- dials
  d_y = window_y/4 - 20
  d_w, d_h = 30, 10
  wall_pos = {60, 240, 420, 600, 906, 1086, 1266, 1446}
  d1, d2, d3, d4, d5, d6, d7, d8 = Dial("num", "horizontal", window_x/2, window_y/2, 600, 200), Dial("num", "horizontal", window_x/2, window_y/2, 600, 200), Dial("num", "horizontal", window_x/2, window_y/2, 600, 200), Dial("num", "horizontal", window_x/2, window_y/2, 600, 200), Dial("num",       "horizontal", window_x/2, window_y/2, 600, 200), Dial("num", "horizontal", window_x/2, window_y/2, 600, 200), Dial("num", "horizontal", window_x/2, window_y/2, 600, 200), Dial("num", "horizontal", window_x/2, window_y/2, 600, 200)
  dials = {d1, d2, d3, d4, d5, d6, d7, d8}
  -- shells
  shell_colors = {{241/255, 145/255, 155/255}, {152/255, 102/255, 199/255}, {82/255, 189/255, 1}, {1, 1, 153/255}, {0, 240/255, 120/255}, {.9, .9, .9}}
  shell_pos = {{120, window_y/3 + 10}, {360, window_y/3 + 50}, {550, window_y/3 + 20}, {910, window_y/3 + 30}, {1110, window_y/3 + 20}, {1400, window_y/3 + 40}}
  shell_code = {"G", "N", "S", "U", "C", "Y"}
  display_shell = false
  current_shell = nil
  -- lock
  lock = Lock()
  lock_w, lock_h = 22, 30
  lock_x, lock_y = window_x/2 - lock_w/2, window_y/3 + 25
  -- inventory
  inventory = Inventory()
  inventory:update("add", moon_image)
end

function star_room:draw()
  -- love.mouse.setCursor(arrow_cursor)
  -- draw background
  love.graphics.setBackgroundColor(194/255, 178/255, 128/255)
  love.graphics.setColor(183/255, 226/255, 252/255)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y/3)
  love.graphics.setColor(0, 84/255, 119/255)
  love.graphics.rectangle("fill", 0, window_y/3 - 80, window_x, 80)
  love.graphics.setColor(144/255, 246/255, 215/255)
  love.graphics.rectangle("fill", 0, window_y/3, window_x, 60)
  
  -- beach shells
  for i = 1, 6 do
    love.graphics.setColor(shell_colors[i][1], shell_colors[i][2], shell_colors[i][3])
    love.graphics.circle("fill", shell_pos[i][1], shell_pos[i][2], 15)
    if near_object(player.x, player.y, player.w, player.h, shell_pos[i][1], shell_pos[i][2], 15, 15, 10, 10) then
      love.graphics.setColor(shell_colors[i][1] * .7, shell_colors[i][2] * .7, shell_colors[i][3] * .7)
      love.graphics.circle("line", shell_pos[i][1], shell_pos[i][2], 15)
    end
  end
  
  -- lock
  love.graphics.setColor(.7, .7, .7)
  love.graphics.rectangle("fill", lock_x, lock_y, lock_w, lock_h)
  if near_object(player.x, player.y, player.w, player.h, lock_x, lock_y, lock_w, lock_h, 10, 10) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", lock_x, lock_y, lock_w, lock_h)
  end
  
  -- chair
  chair:draw()
  if near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, 5, 5) then
    love.graphics.setColor(139/255, 0, 0)
    love.graphics.rectangle("fill", chair.x, chair.y, chair.w, chair.h)
  end
  
  -- wall dials
  for i = 1, 8 do
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", wall_pos[i], d_y, d_w, d_h)
    if near_object(player.x, player.y, player.w, player.h, wall_pos[i], d_y, d_w, d_h, 20, 20) then
      love.graphics.setColor(.4, .4, .4)
      love.graphics.rectangle("line", wall_pos[i], d_y, d_w, d_h)
    end
  end
  
    -- player
  player:draw()
  
  -- dayttime vs nighttime
  if sun then 
    love.graphics.setColor(1,1,1)
    love.graphics.draw(sun_image, celest_x, celest_y, 0, celest_r/sun_image:getWidth(), celest_r/sun_image:getHeight())
    love.graphics.setColor(1, 131/255,0)
    if near_object(player.x, player.y, player.w, player.h, celest_x, celest_y, celest_r, celest_r, 40, 40) then
      love.graphics.circle("line", window_x/2, window_y/8, 40)
    end
  elseif moon then
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle("fill", 0, 0, window_x, window_y)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(moon_image, celest_x, celest_y, 0, celest_r/moon_image:getWidth(), celest_r/moon_image:getHeight())
    love.graphics.draw(cygnus, wall_pos[2] - 40, star_y, 0, star_w/cygnus:getWidth())
    love.graphics.setColor(0, 0, 0)
    if near_object(player.x, player.y, player.w, player.h, celest_x, celest_y, celest_r, celest_r, 40, 40) then
      love.graphics.circle("line", window_x/2, window_y/8, 40)
    end
  else
    love.graphics.setColor(0, 0, 0, .2)
    love.graphics.rectangle("fill", 0, 0, window_x, window_y)
    love.graphics.setColor(.7, .7, .7)
    cur_index = inventory.clicked_index
    if near_object(player.x, player.y, player.w, player.h, celest_x, celest_y, celest_r, celest_r, 40, 40) and (inventory.items[cur_index] == moon_image or inventory.items[cur_index] == sun_image) then
      love.graphics.circle("line", window_x/2, window_y/8, 40)
    end
  end
  -- draw opened dial
  if display_dial then
    for i = 1, 8 do 
      if current_dial == i then
        love.graphics.setColor(0, 0, 0, .8)
        love.graphics.rectangle("fill", 0, 0, window_x, window_y)
        dials[i]:draw()
        break
      end
    end
  end
  
  -- display seashell
  if display_shell then
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle("fill", 0, 0, window_x, window_y)
    love.graphics.setColor(shell_colors[current_shell][1], shell_colors[current_shell][2], shell_colors[current_shell][3])
    love.graphics.draw(shell, window_x/2 - 350, window_y/2 - 300, 0, 600/shell:getHeight())
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(shell_code[current_shell], window_x/2 - 90, window_y/2 - 100, 0, 15, 15)
  end
  
  -- display lock
  if display_lock then
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle("fill", 0, 0, window_x, window_y)
    lock:draw()
  end
  
  -- inventory
  inventory:draw(player)
end

function star_room:update(dt)
  mouse_x, mouse_y = love.mouse.getPosition()
  if passed then
    Gamestate.switch(room2)
  end
  if not paused then
    -- update player and chair
    if not display_dial and not display_shell and not display_lock then
      if not climb_chair then
        player:update(dt)
      end
      if move_chair then
        chair:update(dt)
      end
      
    elseif display_dial then
    -- dial
      for i = 1, 8 do
        if current_dial == i then
          dials[i]:update(dt, mouse_x, mouse_y)
          break
        end
      end
    
    elseif display_lock then
      lock:update(dt)
    end
  end
  
  -- correct wall passcode
  if d1.current_index == 1 and d2.current_index == 8 and d3.current_index == 1 and d4.current_index == 5 and d5.current_index == 3 and d6.current_index == 1 and d7.current_index == 3 and d8.current_index == 10 then
    passed = true
  end
end

function star_room:keyreleased(key, code)
  if key == "i" and not display_dial then
    inventory.on = not inventory.on 
  end
  if key == "e" then
    -- interact with dials
    if display_dial then
      display_dial = false
    elseif display_shell then
      display_shell = false
    elseif display_lock then
      display_lock = false
    else
      for i = 1, 8 do
        if near_object(player.x, player.y, player.w, player.h, wall_pos[i], d_y, d_w, d_h, 20, 20) then
          display_dial = true
          inventory.on = false
          current_dial = i
        end
      end
      
      -- interact with shells
      for i = 1, 6 do
        if near_object(player.x, player.y, player.w, player.h, shell_pos[i][1], shell_pos[i][2], 15, 15, 10, 10) then
          display_shell = true
          current_shell = i
        end
      end
      
      -- interact with lock
      if near_object(player.x, player.y, player.w, player.h, lock_x, lock_y, lock_w, lock_h, 10, 10) then
        display_lock = true
      end
      
      -- interact with sun/moon
      if near_object(player.x, player.y, player.w, player.h, celest_x, celest_y, celest_r, celest_r, 40, 40) then
        cur_index = inventory.clicked_index
        -- interact with sun while not hovering moon
        if sun and (cur_index == nil or inventory.items[cur_index] ~= moon_image) then
          sun = false
          inventory:update("add", sun_image)
        -- interact with sun while hovering moon
        elseif sun and inventory.items[cur_index] == moon_image then
          moon = true
          sun = false
          inventory:update("add", sun_image)
          inventory:update("remove", moon_image)
          inventory.clicked_index = nil
        -- interact with moon while not hovering sun
        elseif moon and (cur_index == nil or inventory.items[cur_index] ~= sun_image) then
          moon = false
          inventory:update("add", moon_image)
        -- interact with moon while hovering sun
        elseif moon and inventory.items[cur_index] == sun_image then
          sun = true
          moon = false
          inventory:update("add", moon_image)
          inventory:update("remove", sun_image)
          inventory.clicked_index = nil
        elseif not moon and not sun and inventory.items[cur_index] == sun_image then
          sun = true
          inventory:update("remove", sun_image)
          inventory.clicked_index = nil
        elseif not moon and not sun and inventory.items[cur_index] == moon_image then
          moon = true
          inventory:update("remove", moon_image)
          inventory.clicked_index = nil
        end
      end
    end
  end
  
  -- near chair
  if near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, 5, 5) then
    if key == "m" and not climb_chair then
      move_chair = not move_chair
    elseif key == "c" and not display_dial and not display_shell and not display_lock then
      climb_chair = not climb_chair
      move_chair = false
      if climb_chair then
        player.x = chair.x - (player.w - chair.w)/2
        player.y = chair.y - player.h
      else
        player.x = chair.x + (chair.w/2) - player.w/2
        player.y = chair.y + chair.h - player.h
      end
    end
  end
end

function update_dial(d, x, y)
  if d.orientation == "horizontal" and near_object(x, y, 0, 0, d.x, d.y, d.w/4, d.h, 0, 0) then
    d:update_down()
    return true
  elseif d.orientation == "horizontal" and near_object(x, y, 0, 0, d.x + 3*d.w/4, d.y, d.w/4, d.h, 0, 0) then
    d:update_up()
    return true
  elseif d.orientation == "vertical" and near_object(x, y, 0, 0, d.x, d.y + 3*d.h/4, d.w, d.h/4, 0, 0) then
    d:update_down()
    return true
  elseif d.orientation == "vertical" and near_object(x, y, 0, 0, d.x, d.y, d.w, d.h/4, 0, 0) then
    d:update_up()
    return true
  else
    return false
  end
end

function star_room:mousereleased(x, y, button)
  if button == 1 then
    -- interact with dials
    if display_dial then
      for i = 1, 8 do
        if current_dial == i then
          if update_dial(dials[i], x, y) then
            break
          end
        end
      end
    end
    
    -- interact with lock dials
    -- TODO: make less laggy?
    if display_lock then
      for i = 1, #lock.dials do
        update_dial(lock.dials[i], x, y)
      end
    end
    
    -- interact with inventory
    if inventory.on then 
      for i = 1, inventory.total_items do
        if near_object(x, y, 0, 0, inventory.item_width * (i - 1), 0, inventory.item_width, inventory.y, 0, 0) then
          if inventory.items[i] ~= nil and (inventory.clicked_index == nil or inventory.clicked_index ~= i) then
            inventory.clicked_index = i
          elseif inventory.clicked_index == i then
            inventory.clicked_index = nil
          end
        end
      end
    end
  end
end

return star_room