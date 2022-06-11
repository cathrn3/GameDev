local room2 = require "states.room2"
require "objects.notebook"
require "objects.mirror"
require "objects.inventory"
require "objects.dial"
require "objects.lock"
require "objects.moveable"
require "objects.shell"
local star_room, dials, lock_dials = {}, {}, {}
local sun = true
local show_dial, show_lock, show_shell, show_rock, show_chair_hint = false, false, false, false, false
local current_dial, current_shell = nil, nil
local move_chair, climb_chair = false, false
local found_md, found_mp, placed_md, placed_mp = false, false, false, false
local found_s1, found_s2, found_s3, found_s4, found_s5, found_s6 = false, false, false, false, false, false
local paused, inventory_text = false, false
local chair = Moveable(1010, 400, 60, 50, 200, {128/255, 88/255, 10/255})
local player = Moveable(1536/2 - 20, 864/2 - 50, 50, 100, 200, {1,1,1})
local inventory = Inventory(12)


function star_room:enter()
  love.graphics.setLineWidth(3)
  
  -- images
  shell = love.graphics.newImage("resources/star_room/shell.png")
  sticky = love.graphics.newImage("resources/star_room/sticky.png")
  screen = love.graphics.newImage("resources/star_room/screen.png")
  screen_open = love.graphics.newImage("resources/star_room/screen_open.png")
  draco_mirror = love.graphics.newImage("resources/star_room/draco_mirror.png")
  pegasus_mirror = love.graphics.newImage("resources/star_room/pegasus_mirror.png")
  mirror_stand = love.graphics.newImage("resources/star_room/mirror_stand.png")
  mirror_stand_outline = love.graphics.newImage("resources/star_room/mirror_stand_outline.png")
  
  andromeda = love.graphics.newImage("resources/star_room/andromeda.png")
  cassiopeia = love.graphics.newImage("resources/star_room/cassiopeia.png")
  cygnus = love.graphics.newImage("resources/star_room/cygnus.png")
  draco = love.graphics.newImage("resources/star_room/draco.png")
  lyra = love.graphics.newImage("resources/star_room/lyra.png")
  orion = love.graphics.newImage("resources/star_room/orion.png")
  pegasus = love.graphics.newImage("resources/star_room/pegasus.png")
  ursa_minor = love.graphics.newImage("resources/star_room/ursa_minor.png")
  
  
  cover = love.graphics.newImage("resources/star_room/notebook.png")
  andromeda_note = love.graphics.newImage("resources/star_room/andromeda_note.png")
  cassiopeia_note = love.graphics.newImage("resources/star_room/cassiopeia_note.png")
  cygnus_note = love.graphics.newImage("resources/star_room/cygnus_note.png")
  draco_note = love.graphics.newImage("resources/star_room/draco_note.png")
  lyra_note = love.graphics.newImage("resources/star_room/lyra_note.png")
  orion_note = love.graphics.newImage("resources/star_room/orion_note.png")
  pegasus_note = love.graphics.newImage("resources/star_room/pegasus_note.png")
  ursa_minor_note = love.graphics.newImage("resources/star_room/ursa_minor_note.png")
  
  -- inventory objects
  notebook = Notebook({cover, andromeda_note, cassiopeia_note, cygnus_note, draco_note, lyra_note, orion_note, pegasus_note, ursa_minor_note})
  mirror_p = Mirror(pegasus_mirror)
  mirror_d = Mirror(draco_mirror)
  
  inventory:add(notebook)
  
  -- alphnum
  alphnum = {}
  for i = 0, 35 do
    local new_image = love.graphics.newImage("resources/star_room/alphnum/" .. i .. ".png")
    table.insert(alphnum, new_image)
  end
  
  -- dials
  d_y = window_y/3 - 110
  d_w, d_h = 10, 10
  d_x = {60, 240, 420, 600, 906, 1086, 1266, 1446}
  for i = 1, 8 do
    table.insert(dials, Dial("num", window_x/2, window_y/2, 200, 200))
  end
  
  -- lock
  for i = 1, 6 do
    table.insert(lock_dials, Dial("alph", window_x/2 + (-200 + 80 * (i - 1)), window_y/2, 50, 100))
  end
  lock = Lock(lock_dials, {screen, window_x/2, window_y/2, 800, 600}, {screen_open, window_x/2, window_y/2, 800, 600}, {13, 35, 17, 24, 31, 29})
  lock_w, lock_h = 40, 40
  lock_x, lock_y = window_x/2, 300
  
  -- stars
  star_y, star_w = 20, 150
  
  -- shells
  shell_colors = {{241/255, 145/255, 155/255}, {152/255, 102/255, 199/255}, {82/255, 189/255, 1}, {1, 1, 153/255}, {0, 240/255, 120/255}, {.9, .9, .9}}
  shell_code = {17, 24, 29, 31, 13, 35}
  s1_x, s1_y, s1_w, s1_h = window_x/2 + 50, window_y/2 - 100, 40, 40
  s2_x, s2_y, s2_w, s2_h = 350, 750, 30, 30
  s3_x, s3_y, s3_w, s3_h = 1200, 320, 30, 30
  s4_x, s4_y, s4_w, s4_h = 1340, 320, 30, 30
  s1 = Shell(shell_colors[1], shell_code[1])
  s2 = Shell(shell_colors[2], shell_code[2])
  s3 = Shell(shell_colors[3], shell_code[3])
  s4 = Shell(shell_colors[4], shell_code[4])
  s5 = Shell(shell_colors[5], shell_code[5])
  s6 = Shell(shell_colors[6], shell_code[6])
  
  
  -- rock
  rock_x, rock_y, rock_w, rock_h = window_x - 220, window_y - 200, 220, 200
  mr1_x, mr1_y, mr1_w, mr1_h = window_x/2 - 200, window_y/2 - 200, 40, 40
  mr2_x, mr2_y, mr2_w, mr2_h = window_x/2 + 150, window_y/2 + 100, 40, 40
end


function star_room:draw()
  push:start()
  -- draw background
  love.graphics.setColor(194/255, 178/255, 128/255)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y)
  love.graphics.setColor(183/255, 226/255, 252/255)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y/3)
  love.graphics.setColor(0, 84/255, 119/255)
  love.graphics.rectangle("fill", 0, window_y/3 - 50, window_x, 100)
  love.graphics.setColor(144/255, 246/255, 215/255)
  love.graphics.rectangle("fill", 0, window_y/3, window_x, 60)
  
  -- temp graphics
  
  -- large rock 
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", window_x - 220, window_y - 200, 220, 200) 
  if near_object(player.x, player.y, player.w, player.h, rock_x, rock_y, rock_w, rock_h) and (not found_md or not found_mp or not found_s1) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line",rock_x, rock_y, rock_w, rock_h)
  end

  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 80, 340, 100, 75) -- sandcastle
  if near_object(player.x, player.y, player.w, player.h, 80, 340, 100, 75) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 80, 340, 100, 75)
  end
  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 50, window_y - 150, 105, 120) -- telescope
  if near_object(player.x, player.y, player.w, player.h, 50, window_y - 150, 105, 120) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 50, window_y - 150, 105, 120)
  end
  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 270, 470, 70, 120) -- surfboards
  love.graphics.rectangle("fill", 345, 470, 70, 120)
  love.graphics.rectangle("fill", 420, 470, 70, 120)
  if near_object(player.x, player.y, player.w, player.h, 270, 470, 220, 120) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 270, 470, 220, 120)
  end  
  
  -- mirrors
  if placed_md then
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", window_x/2 - 150, 400 - (160/3 - 20), 40, 160/3)
    love.graphics.setColor(1,1,1)
    love.graphics.line(window_x/2, window_y/10, window_x/2 - 150 + 20, 400 - (160/3 - 20) + 10)
  else
    love.graphics.setColor(26/255, 65/255, 196/255)
    love.graphics.rectangle("fill", window_x/2 - 150, 400, 40, 20)
  end
  if near_object(player.x, player.y, player.w, player.h, window_x/2 - 150, 400, 40, 20) then
    if inventory.items[inventory.clicked_index] == mirror_d and not placed_md then
      love.graphics.setColor(26/255 * .4, 65/255 * .4, 196/255 * .4)
      love.graphics.rectangle("line", window_x/2 - 150, 400, 40, 20)
    elseif placed_md then
      love.graphics.setColor(.7, .7, .7)
      love.graphics.rectangle("line", window_x/2 - 150, 400 - (160/3 - 20), 40, 160/3)
    end
  end  
  
  if placed_mp then 
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", window_x/2 + 110, 500 - (160/3 - 20), 40, 160/3)
  else 
    love.graphics.setColor(157/255, 25/255, 194/255)
    love.graphics.rectangle("fill", window_x/2 + 110, 500, 40, 20)
  end
  if near_object(player.x, player.y, player.w, player.h, window_x/2 + 110, 500, 40, 20) then
    if inventory.items[inventory.clicked_index] == mirror_p and not placed_mp then
      love.graphics.setColor(157/255 * .4, 25/255 * .4, 194/255 * .4)
      love.graphics.rectangle("line", window_x/2 + 110, 500, 40, 20)
    elseif placed_mp then
      love.graphics.setColor(.7, .7, .7)
      love.graphics.rectangle("line", window_x/2 + 110, 500 - (160/3 - 20), 40, 160/3)
    end
  end  
  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", window_x/2 - 150, 600, 40, 40)
  if placed_md and placed_mp then
    love.graphics.setColor(1,1,1)
    love.graphics.line(window_x/2 + 110 + 20, 500 - (160/3 - 20) + 10, window_x/2 - 150 + 20, 600 + 10)
    love.graphics.line(window_x/2 - 150 + 20, 400 - (160/3 - 20) + 10, window_x/2 + 110 + 20, 500 - (160/3 - 20) + 10)
    love.graphics.setColor(.7, .7, .7)
    love.graphics.rectangle("fill", window_x/2 - 150 - 40, 600 + 40, 40, 40)
  end
  
  -- seashell next to telescope
  if not found_s2 then
    love.graphics.setColor(shell_colors[2][1], shell_colors[2][2], shell_colors[2][3])
    love.graphics.rectangle("fill", s2_x, s2_y, s2_w, s2_h)
    if near_object(player.x, player.y, player.w, player.h, s2_x, s2_y, s2_w, s2_h) then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", s2_x, s2_y, s2_w, s2_h)
    end  
  end
  
   -- shovel and prints
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", window_x/2 - 180, window_y - 40, 350, 10)
  love.graphics.rectangle("fill", window_x/2 - 220, window_y - 60, 40, 40)
  if near_object(player.x, player.y, player.w, player.h, window_x/2 - 220, window_y - 60, 40, 40) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", window_x/2 - 220, window_y - 60, 40, 40)
  end  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", window_x/2 + 170, window_y - 80, 30, 60)
  if near_object(player.x, player.y, player.w, player.h, window_x/2 + 170, window_y - 80, 30, 60) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", window_x/2 + 170, window_y - 80, 30, 60)
  end  
  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 1050, 650, 100, 100) -- beachball
  if near_object(player.x, player.y, player.w, player.h, 1050, 650, 100, 100) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 1050, 650, 100, 100)
  end  
  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 1175, 500, 30, 20) -- crab holes
  if near_object(player.x, player.y, player.w, player.h, 1175, 500, 30, 20) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 1175, 500, 30, 20)
  end  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 1325, 500, 30, 20)
  if near_object(player.x, player.y, player.w, player.h, 1325, 500, 30, 20) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 1325, 500, 30, 20)
  end  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 1475, 500, 30, 20)
  if near_object(player.x, player.y, player.w, player.h, 1475, 500, 30, 20) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 1475, 500, 30, 20)
  end  
  
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", 1420, 380, 60, 60) -- small rock
  if near_object(player.x, player.y, player.w, player.h, 1420, 380, 60, 60) then
    love.graphics.setColor(.4, .4, .4)
    love.graphics.rectangle("fill", 1420, 380, 60, 60)
  end  
  
   -- water seashells
  if not found_s3 then
    love.graphics.setColor(shell_colors[3][1], shell_colors[3][2], shell_colors[3][3])
    love.graphics.rectangle("fill", s3_x, s3_y, s3_w, s3_h)
    if near_object(player.x, player.y, player.w, player.h, s3_x, s3_y, s3_w, s3_h) then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", s3_x, s3_y, s3_w, s3_h)
    end  
  end
  
  if not found_s4 then
    love.graphics.setColor(shell_colors[4][1], shell_colors[4][2], shell_colors[4][3])
    love.graphics.rectangle("fill", s4_x, s4_y, s4_w, s4_h)
    if near_object(player.x, player.y, player.w, player.h, s4_x, s4_y, s4_w, s4_h) then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", s4_x, s4_y, s4_w, s4_h)
    end
  end
  
  -- lock
  love.graphics.setColor(.7, .7, .7)
  love.graphics.rectangle("fill", lock_x, lock_y, lock_w, lock_h)
  if near_object(player.x, player.y, player.w, player.h, lock_x, lock_y, lock_w, lock_h) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", lock_x, lock_y, lock_w, lock_h)
  end
  
  -- wall dials
  for i = 1, 8 do
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", d_x[i], d_y, d_w, d_h)
    if near_object(player.x, player.y, player.w, player.h, d_x[i], d_y, d_w, d_h) then
      love.graphics.setColor(.4, .4, .4)
      love.graphics.rectangle("line", d_x[i], d_y, d_w, d_h)
    end 
  end
  
  -- moveables
  chair:draw()
  if near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h) then
    love.graphics.setColor(139/255, 0, 0)
    love.graphics.rectangle("fill", chair.x, chair.y, chair.w, chair.h)
  end
  love.graphics.setColor(188/255, 219/255, 73/255)
  love.graphics.rectangle("fill", chair.x + chair.w/2 - 10, chair.y + chair.h/2 - 12.5, 20, 25)
  if near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, -3, -3) then
    love.graphics.setColor(29/255, 54/255, 11/255)
    love.graphics.rectangle("line", chair.x + chair.w/2 - 10, chair.y + chair.h/2 - 12.5, 20, 25)
  end
  
  
  player:draw()
  
  -- day/night
  if sun then 
    love.graphics.setColor(1,1,153/255)
    love.graphics.circle("fill", window_x/2, window_y/10, 30)
  else
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle("fill", 0, 0, window_x, window_y)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", window_x/2, window_y/10, 30)
    local scale = star_w/ursa_minor:getWidth() -- all same dimensions
    love.graphics.draw(ursa_minor, d_x[1] - 45, star_y, 0, scale)  
    love.graphics.draw(cygnus, d_x[2] - 45, star_y, 0, scale)  
    love.graphics.draw(andromeda, d_x[3] - 45, star_y, 0, scale)  
    love.graphics.draw(lyra, d_x[4] - 45, star_y, 0, scale)
    love.graphics.draw(draco, d_x[5] - 45, star_y, 0, scale)
    love.graphics.draw(cassiopeia, d_x[6] - 45, star_y, 0, scale)
    love.graphics.draw(pegasus, d_x[7] - 45, star_y, 0, scale)
    love.graphics.draw(orion, d_x[8] - 45, star_y, 0, scale)
  end
  love.graphics.setColor(0, 0, 0)
  if near_object(player.x, player.y, player.w, player.h, window_x/2 - 30, window_y/10 - 30, 60, 60, 40, 40) then
    love.graphics.circle("line", window_x/2, window_y/10, 30)
  end
  
  -- draw opened objects
  if paused then
    star_room:paused()
    if show_dial then
      inventory.on = false
      dials[current_dial]:draw()
    elseif show_lock then
      inventory.on = false
      lock:draw()
    elseif show_shell then
      inventory.on = false
      love.graphics.setColor(shell_colors[current_shell][1], shell_colors[current_shell][2], shell_colors[current_shell][3])
      love.graphics.draw(shell, window_x/2 - 300, window_y/2 - 300, 0, 600/shell:getWidth())
      love.graphics.setColor(1,1,1)
      shell_num = alphnum[shell_code[current_shell]]
      love.graphics.draw(shell_num, window_x/2 - 100, window_y/2 - 100, 0, 200/shell_num:getWidth(), 200/shell_num:getHeight())
    elseif show_chair_hint then
      inventory.on = false
      love.graphics.setColor(1,1,1)
      love.graphics.draw(sticky, window_x/2 - 200, window_y/2 - 200, 0, 400/sticky:getWidth(), 400/sticky:getHeight())
    elseif show_rock then
      inventory.on = false
      love.graphics.setColor(.7,.7,.7)
      love.graphics.rectangle("fill", window_x/2 - 300, window_y/2 - 300, 600, 600)  
      love.graphics.setColor(1, 1, 1)
      if not found_md then
        love.graphics.rectangle("fill", mr1_x, mr1_y, mr1_w, mr1_h)  
      end
      if not found_mp then
        love.graphics.rectangle("fill", mr2_x, mr2_y, mr2_w, mr2_h)  
      end
      if not found_s1 then
        love.graphics.setColor(shell_colors[1])
        love.graphics.rectangle("fill", s1_x, s1_y, s1_w, s1_h) 
      end
    end
  end
  inventory:draw(player)
  if inventory_text then
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", window_x - 30, 10, 60, 20)
  end
  
	push:finish()
end

function star_room:update(dt)
  local m_x, m_y = love.mouse.getPosition()
  local mouse_x, mouse_y = m_x * (window_x/cur_x), m_y * (window_y/cur_y)
  if paused then
    if show_dial then
      dials[current_dial]:update(mouse_x, mouse_y, dt)
    elseif show_lock then
      lock:update(mouse_x, mouse_y, dt)
    elseif show_rock then
      if (near_object(mouse_x, mouse_y, 0, 0, mr1_x, mr1_y, mr1_w, mr1_h) and not found_md) or (near_object(mouse_x, mouse_y, 0, 0, mr2_x, mr2_y, mr2_w, mr2_h) and not found_mp) or (near_object(mouse_x, mouse_y, 0, 0, s1_x, s1_y, s1_w, s1_h) and not found_s1) then
        love.mouse.setCursor(hand_cursor)
      else
        love.mouse.setCursor(arrow_cursor)
      end
    else
      love.mouse.setCursor(arrow_cursor)
    end
  else
    love.mouse.setCursor(arrow_cursor)
    if not climb_chair then
      player:update(dt)
    end
    if move_chair then
      chair:update(dt)
    end
  end
  inventory:update(mouse_x, mouse_y)
  Timer.update(dt)
end

function star_room:keypressed(key)    
  if key == "e" then
    if paused then
      if show_dial then
        show_dial = false
        paused = false
      elseif show_lock then
        show_lock = false
        paused = false
      elseif show_shell then
        show_shell = false
        paused = false
      elseif show_chair_hint then
        show_chair_hint = false
        paused = false
      elseif show_rock then
        show_rock = false
        paused = false
      end
    else
      -- dials
      for i = 1, 8 do
        if near_object(player.x, player.y, player.w, player.h, d_x[i], d_y, d_w, d_h) then
          show_dial = true
          current_dial = i
          paused = true
          break
        end
      end
      
      --lock
      if near_object(player.x, player.y, player.w, player.h, lock_x, lock_y, lock_w, lock_h) then
        show_lock = true
        paused = true
      -- sun/moon
      elseif near_object(player.x, player.y, player.w, player.h, window_x/2 - 30, window_y/10 - 30, 60, 60, 40, 40) then
        sun = not sun
      -- sticky note 
      elseif near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, -3, -3) then
        show_chair_hint = true
        paused = true
      -- large rock
      elseif near_object(player.x, player.y, player.w, player.h, rock_x, rock_y, rock_w, rock_h) and (not found_md or not found_mp or not found_s1) then
        show_rock = true
        paused = true
      -- mirror_d
      elseif near_object(player.x, player.y, player.w, player.h, window_x/2 - 150, 400, 40, 20) then
        if placed_md then
          inventory:add(mirror_d)
          placed_md = false
        elseif not placed_md and inventory.items[inventory.clicked_index] == mirror_d then
          inventory:remove(mirror_d)
          placed_md = true
        end
      -- mirror_p
      elseif near_object(player.x, player.y, player.w, player.h, window_x/2 + 110, 500, 40, 20) then
        if placed_mp then
          inventory:add(mirror_p)
          placed_mp = false
        elseif not placed_mp and inventory.items[inventory.clicked_index] == mirror_p then
          inventory:remove(mirror_p)
          placed_mp = true
        end
      -- shell 2
      elseif near_object(player.x, player.y, player.w, player.h, s2_x, s2_y, s2_w, s2_h) and not found_s2 then
        inventory:add(s2)
        found_s2 = true
        Timer.during(1, function() inventory_text = true end, function() inventory_text = false end)
      -- shell 3
      elseif near_object(player.x, player.y, player.w, player.h, s3_x, s3_y, s3_w, s3_h) and not found_s3 then
        inventory:add(s3)
        found_s3 = true
        Timer.during(1, function() inventory_text = true end, function() inventory_text = false end)      
      -- shell 4
      elseif near_object(player.x, player.y, player.w, player.h, s4_x, s4_y, s4_w, s4_h) and not found_s4 then
        inventory:add(s4)
        found_s4 = true
        Timer.during(1, function() inventory_text = true end, function() inventory_text = false end)  
      end
    end
  -- chair
  elseif key == "m" and not climb_chair and near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h) and not paused then
    move_chair = not move_chair
  elseif key == "c" and near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h) and not paused then
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
    paused = false
    inventory.on = not inventory.on
    inventory.clicked_index = nil
  end
end

function star_room:mousereleased(x, y, button)
  mouse_x, mouse_y = x * window_x/cur_x, y * window_y/cur_y
  paused = inventory:mousereleased(mouse_x, mouse_y, button, paused)
  if show_dial then
    dials[current_dial]:mousereleased(mouse_x, mouse_y, button)
  elseif show_lock then
    lock:mousereleased(mouse_x, mouse_y, button)
  elseif show_rock then
    if near_object(mouse_x, mouse_y, 0, 0, mr1_x, mr1_y, mr1_w, mr1_h) and not found_md then
      found_md = true
      inventory:add(mirror_d)
      Timer.during(1, function() inventory_text = true end, function() inventory_text = false end)
    elseif near_object(mouse_x, mouse_y, 0, 0, mr2_x, mr2_y, mr2_w, mr2_h) and not found_mp then
      found_mp = true
      inventory:add(mirror_p)
      Timer.during(1, function() inventory_text = true end, function() inventory_text = false end)
    elseif near_object(mouse_x, mouse_y, 0, 0, s1_x, s1_y, s1_w, s1_h) and not found_s1 then
      found_s1 = true
      inventory:add(s1)
      Timer.during(1, function() inventory_text = true end, function() inventory_text = false end)
    end
  end
end

function star_room:paused()
  love.graphics.setColor(0, 0, 0, .8)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y)
end

return star_room