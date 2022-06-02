local star_room = {}
local room2 = require "states.room2"
local paused = false
local show_dial = false
local show_lock = false
local current_dial = nil
local move_chair = false
local climb_chair = false
local sun = true
local show_shell = false
local current_shell = nil
local show_chair_hint = false

function star_room:enter()
  love.graphics.setLineWidth(3)
  player = Moveable(window_x/2 - 20, window_y/2 - 35, 40, 70, 200, {1,1,1})
  chair = Moveable(1000, 400, 60, 50, 200, {69/255, 0, 0})
  
  -- images
  cygnus = love.graphics.newImage("resources/star_room/cygnus.png")
  shell = love.graphics.newImage("resources/star_room/shell.png")
  sticky = love.graphics.newImage("resources/star_room/sticky.png")
   
  inventory = Inventory()
  inventory:add(shell) 
  
  -- alphnum
  alphnum = {}
  for i = 0, 35 do
    local new_image = love.graphics.newImage("resources/star_room/alphnum/" .. i .. ".png")
    table.insert(alphnum, new_image)
  end
  
  -- dials
  d_y = window_y/4 - 20
  d_w, d_h = 30, 10
  d_x = {60, 240, 420, 600, 906, 1086, 1266, 1446}
  dials = {}
  for i = 1, 8 do
    table.insert(dials, Dial("num", window_x/2, window_y/2, 600, 200))
  end
  
  -- lock
  lock_dials = {}
  for i = 1, 6 do
    table.insert(lock_dials, Dial("alph", window_x/2 + (-175 + 70 * (i - 1)), window_y/2, 50, 100))
  end
  screen = love.graphics.newImage("resources/star_room/screen.png")
  lock = Lock(lock_dials, {screen, window_x/2, window_y/2, 600, 600}, {alphnum[8], window_x/2, window_y/2, 200, 200}, {13, 35, 17, 24, 31, 29})
  lock_w, lock_h = 22, 30
  lock_x, lock_y = window_x/2 - lock_w/2, window_y/3 + 25
  
  -- stars
  star_y, star_w = 20, 150
  
  -- shells
  shell_colors = {{241/255, 145/255, 155/255}, {152/255, 102/255, 199/255}, {82/255, 189/255, 1}, {1, 1, 153/255}, {0, 240/255, 120/255}, {.9, .9, .9}}
  shell_pos = {{120, window_y/3 + 10}, {360, window_y/3 + 50}, {550, window_y/3 + 20}, {910, window_y/3 + 30}, {1110, window_y/3 + 20}, {1400, window_y/3 + 40}}
  shell_code = {17, 24, 29, 31, 13, 35}
end


function star_room:draw()
  -- draw background
  love.graphics.setBackgroundColor(194/255, 178/255, 128/255)
  love.graphics.setColor(183/255, 226/255, 252/255)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y/3)
  love.graphics.setColor(0, 84/255, 119/255)
  love.graphics.rectangle("fill", 0, window_y/3 - 80, window_x, 80)
  love.graphics.setColor(144/255, 246/255, 215/255)
  love.graphics.rectangle("fill", 0, window_y/3, window_x, 60)
  
  -- lock
  love.graphics.setColor(.7, .7, .7)
  love.graphics.rectangle("fill", lock_x, lock_y, lock_w, lock_h)
  if near_object(player.x, player.y, player.w, player.h, lock_x, lock_y, lock_w, lock_h, 10, 10) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", lock_x, lock_y, lock_w, lock_h)
  end
  
  -- wall dials
  for i = 1, 8 do
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", d_x[i], d_y, d_w, d_h)
    if near_object(player.x, player.y, player.w, player.h, d_x[i], d_y, d_w, d_h, 20, 20) then
      love.graphics.setColor(.4, .4, .4)
      love.graphics.rectangle("line", d_x[i], d_y, d_w, d_h)
    end
  end
  
  -- beach shells
  for i = 1, 6 do
    love.graphics.setColor(shell_colors[i][1], shell_colors[i][2], shell_colors[i][3])
    love.graphics.circle("fill", shell_pos[i][1], shell_pos[i][2], 15)
    if near_object(player.x, player.y, player.w, player.h, shell_pos[i][1], shell_pos[i][2], 15, 15, 10, 10) then
      love.graphics.setColor(shell_colors[i][1] * .7, shell_colors[i][2] * .7, shell_colors[i][3] * .7)
      love.graphics.circle("line", shell_pos[i][1], shell_pos[i][2], 15)
    end
  end
  
  -- moveables
  chair:draw()
  if near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, 5, 5) then
    love.graphics.setColor(139/255, 0, 0)
    love.graphics.rectangle("fill", chair.x, chair.y, chair.w, chair.h)
  end
  love.graphics.setColor(188/255, 219/255, 73/255)
  love.graphics.rectangle("fill", chair.x + chair.w/2 - 10, chair.y + chair.h/2 - 12.5, 20, 25)
  if near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, 5, 5) then
    love.graphics.setColor(29/255, 54/255, 11/255)
    love.graphics.rectangle("line", chair.x + chair.w/2 - 10, chair.y + chair.h/2 - 12.5, 20, 25)
  end
  
  
  player:draw()
  
  -- day/night
  if sun then 
    love.graphics.setColor(1,1,153/255)
    love.graphics.circle("fill", window_x/2, window_y/8, 40)
  else
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle("fill", 0, 0, window_x, window_y)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", window_x/2, window_y/8, 40)
    love.graphics.draw(cygnus, d_x[2] - 40, star_y, 0, star_w/cygnus:getWidth())  
  end
  love.graphics.setColor(0, 0, 0)
  if near_object(player.x, player.y, player.w, player.h, window_x/2 - 20, window_y/8 - 20, 80, 80, 40, 40) then
    love.graphics.circle("line", window_x/2, window_y/8, 40)
  end
  
  inventory:draw(player)
  
  -- draw opened objects
  if paused then
    star_room:paused()
    if show_dial then
      dials[current_dial]:draw()
    elseif show_lock then
      lock:draw()
    elseif show_shell then
      love.graphics.setColor(shell_colors[current_shell][1], shell_colors[current_shell][2], shell_colors[current_shell][3])
      love.graphics.draw(shell, window_x/2 - 300, window_y/2 - 300, 0, 600/shell:getWidth())
      love.graphics.setColor(1,1,1)
      shell_num = alphnum[shell_code[current_shell]]
      love.graphics.draw(shell_num, window_x/2 - 100, window_y/2 - 100, 0, 200/shell_num:getWidth(), 200/shell_num:getHeight())
    elseif show_chair_hint then
      love.graphics.setColor(1,1,1)
      love.graphics.draw(sticky, window_x/2 - 200, window_y/2 - 200, 0, 400/sticky:getWidth(), 400/sticky:getHeight())
    end
  end
end

function star_room:update(dt)
  local mouse_x, mouse_y = love.mouse.getPosition()
  if paused then
    if show_dial then
      dials[current_dial]:update(mouse_x, mouse_y, dt)
    elseif show_lock then
      lock:update(mouse_x, mouse_y, dt)
    end
  else
    love.mouse.setCursor(arrow_cursor)
    if not climb_chair then
      player:update(dt)
    end
    if move_chair then
      chair:update(dt)
    end
    inventory:update(player)
  end
end

function star_room:keypressed(key)    
  if key == "e" then
    if paused then
      paused = false
      if show_dial then
        show_dial = false
      elseif show_lock then
        show_lock = false
      elseif show_shell then
        show_shell = false
      elseif show_chair_hint then
        show_chair_hint = false
      end
    else
      -- dials
      for i = 1, 8 do
        if near_object(player.x, player.y, player.w, player.h, d_x[i], d_y, d_w, d_h, 20, 20) then
          show_dial = true
          current_dial = i
          paused = true
          break
        end
      end
      
      -- shell
      for i = 1, 6 do
        if near_object(player.x, player.y, player.w, player.h, shell_pos[i][1], shell_pos[i][2], 15, 15, 10, 10) then
          show_shell = true
          current_shell = i
          paused = true
          break
        end
      end
      
      --lock
      if near_object(player.x, player.y, player.w, player.h, lock_x, lock_y, lock_w, lock_h, 10, 10) then
        show_lock = true
        paused = true
      -- sun/moon
      elseif near_object(player.x, player.y, player.w, player.h, window_x/2 - 20, window_y/8 - 20, 80, 80, 40, 40) then
        sun = not sun
      -- sticky note 
      elseif near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, 5, 5) then
        show_chair_hint = true
        paused = true
      end
    end
  -- chair
  elseif key == "m" and not climb_chair and near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, 5, 5) and not paused then
    move_chair = not move_chair
  elseif key == "c" and near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, 5, 5) and not paused then
    climb_chair = not climb_chair
    move_chair = false
    if climb_chair then
      player.x = chair.x - (player.w - chair.w)/2
      player.y = chair.y - player.h
    else
      player.x = chair.x + (chair.w/2) - player.w/2
      player.y = chair.y + chair.h - player.h
    end
  elseif key == "i" then
    inventory.on = not inventory.on
  end
end

function star_room:mousereleased(x, y, button)
  inventory:mousereleased(x, y, button)
  if show_dial then
    dials[current_dial]:mousereleased(x, y, button)
  elseif show_lock then
    lock:mousereleased(x, y, button)
  end
end

function star_room:paused()
  love.graphics.setColor(0, 0, 0, .8)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y)
end

return star_room