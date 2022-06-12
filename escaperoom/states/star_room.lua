local room2 = require "states.room2"
require "objects.notebook"
require "objects.mirror"
require "objects.inventory"
require "objects.dial"
require "objects.lock"
require "objects.moveable"
require "objects.shell"

window_x, window_y = 1536, 864 --fixed game resolution
cur_x, cur_y = love.window.getDesktopDimensions()

local star_room, dials, lock_dials, shells = {}, {}, {}, {}
local bools = 
{
  sun = true, show_dial = false, show_lock = false, show_rock = false, show_chair_hint = false, 
  move_chair = false, climb_chair = false, 
  found_md = false, found_mp = false, placed_md = false, placed_mp = false,
  found_s1 = false, found_s2 = false, found_s3 = false, found_s4 = false, found_s5 = false, found_s6 = false,
  paused, add_text, remove_text = false, false, false
}


local current = 
{
  current_dial = nil, current_shell = nil
}

local coords = 
{
  d_x = {60, 240, 420, 600, 906, 1086, 1266, 1446}, d_y = window_y/3 - 110, d_w = 10, d_h = 10,
  lock_x = window_x/2, lock_y = 300, lock_w = 40, lock_h = 40,
  star_y = 20, star_w = 150,
  s1_x = window_x/2 + 50, s1_y = window_y/2 - 100, s1_w = 40, s1_h = 40,
  s2_x = 350, s2_y = 750, s2_w = 30, s2_h = 30,
  s3_x = 1200, s3_y = 320, s3_w = 30, s3_h = 30,
  s4_x = 1340, s4_y = 320, s4_w = 30, s4_h = 30,
  rock_x = window_x - 220, rock_y = window_y - 200, rock_w = 220, rock_h = 200,
  mr1_x = window_x/2 - 200, mr1_y = window_y/2 - 200, mr1_w = 40, mr1_h = 40,
  mr2_x = window_x/2 + 150, mr2_y = window_y/2  + 100, mr2_w = 40, mr2_h = 40,
}

local images = 
{
  shell = love.graphics.newImage("resources/star_room/shell.png"),
  sticky = love.graphics.newImage("resources/star_room/sticky.png"),
  screen = love.graphics.newImage("resources/star_room/screen.png"),
  screen_open = love.graphics.newImage("resources/star_room/screen_open.png"),
  draco_mirror = love.graphics.newImage("resources/star_room/draco_mirror.png"),
  pegasus_mirror = love.graphics.newImage("resources/star_room/pegasus_mirror.png"),
  mirror_stand = love.graphics.newImage("resources/star_room/mirror_stand.png"),
  mirror_stand_outline = love.graphics.newImage("resources/star_room/mirror_stand_outline.png"),
  
  andromeda = love.graphics.newImage("resources/star_room/andromeda.png"),
  cassiopeia = love.graphics.newImage("resources/star_room/cassiopeia.png"),
  cygnus = love.graphics.newImage("resources/star_room/cygnus.png"),
  draco = love.graphics.newImage("resources/star_room/draco.png"),
  lyra = love.graphics.newImage("resources/star_room/lyra.png"),
  orion = love.graphics.newImage("resources/star_room/orion.png"),
  pegasus = love.graphics.newImage("resources/star_room/pegasus.png"),
  ursa_minor = love.graphics.newImage("resources/star_room/ursa_minor.png"),
  
  cover = love.graphics.newImage("resources/star_room/notebook.png"),
  andromeda_note = love.graphics.newImage("resources/star_room/andromeda_note.png"),
  cassiopeia_note = love.graphics.newImage("resources/star_room/cassiopeia_note.png"),
  cygnus_note = love.graphics.newImage("resources/star_room/cygnus_note.png"),
  draco_note = love.graphics.newImage("resources/star_room/draco_note.png"),
  lyra_note = love.graphics.newImage("resources/star_room/lyra_note.png"),
  orion_note = love.graphics.newImage("resources/star_room/orion_note.png"),
  pegasus_note = love.graphics.newImage("resources/star_room/pegasus_note.png"),
  ursa_minor_note = love.graphics.newImage("resources/star_room/ursa_minor_note.png"),
}

local chair = Moveable(1010, 400, 60, 50, 200, {128/255, 88/255, 10/255})
local player = Moveable(1536/2 - 20, 864/2 - 50, 50, 100, 200, {1,1,1})
local inventory = Inventory(12)
local star_lock = Lock(lock_dials, {images.screen, window_x/2, window_y/2, 800, 600}, {images.screen_open, window_x/2, window_y/2, 800, 600}, {13, 35, 17, 24, 31, 29})
local star_notebook = Notebook({images.cover, images.andromeda_note, images.cassiopeia_note, images.cygnus_note, images.draco_note, images.lyra_note, images.orion_note, images.pegasus_note, images.ursa_minor_note})
local mirror_p, mirror_d = Mirror(images.pegasus_mirror), Mirror(images.draco_mirror)
local shell_colors = {{241/255, 145/255, 155/255}, {152/255, 102/255, 199/255}, {82/255, 189/255, 1}, {1, 1, 153/255}, {0, 240/255, 120/255}, {.9, .9, .9}}
local shell_code = {17, 24, 29, 31, 13, 35}

function star_room:enter()
  love.graphics.setLineWidth(3)
  
  inventory:add(star_notebook)
  for i = 1, 8 do
    table.insert(dials, Dial("num", window_x/2, window_y/2, 200, 200))
  end
  
  -- lock
  for i = 1, 6 do
    table.insert(lock_dials, Dial("alph", window_x/2 + (-200 + 80 * (i - 1)), window_y/2, 50, 100))
  end

  -- shells
  for i = 1, 6 do
    table.insert(shells, Shell(shell_colors[i], shell_code[i]))
  end
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
  if near_object(player.x, player.y, player.w, player.h, coords.rock_x, coords.rock_y, coords.rock_w, coords.rock_h) and (not bools.found_md or not bools.found_mp or not bools.found_s1) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", coords.rock_x, coords.rock_y, coords.rock_w, coords.rock_h)
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
  
  -- first mirror
  if bools.placed_md then
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", window_x/2 - 150, 400 - (160/3 - 20), 40, 160/3)
    love.graphics.setColor(1,1,1)
    love.graphics.line(window_x/2, window_y/10, window_x/2 - 150 + 20, 400 - (160/3 - 20) + 10)
  else
    love.graphics.setColor(26/255, 65/255, 196/255)
    love.graphics.rectangle("fill", window_x/2 - 150, 400, 40, 20)
  end
  if near_object(player.x, player.y, player.w, player.h, window_x/2 - 150, 400, 40, 20) then
    if inventory.items[inventory.clicked_index] == mirror_d and not bools.placed_md then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", window_x/2 - 150, 400, 40, 20)
    elseif bools.placed_md then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", window_x/2 - 150, 400 - (160/3 - 20), 40, 160/3)
    end
  end  
  
  -- second mirror
  if bools.placed_mp then 
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", window_x/2 + 110, 500 - (160/3 - 20), 40, 160/3)
  else 
    love.graphics.setColor(157/255, 25/255, 194/255)
    love.graphics.rectangle("fill", window_x/2 + 110, 500, 40, 20)
  end
  if near_object(player.x, player.y, player.w, player.h, window_x/2 + 110, 500, 40, 20) then
    if inventory.items[inventory.clicked_index] == mirror_p and not bools.placed_mp then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", window_x/2 + 110, 500, 40, 20)
    elseif bools.placed_mp then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", window_x/2 + 110, 500 - (160/3 - 20), 40, 160/3)
    end
  end  
  
  -- mirror shadow
  love.graphics.setColor(.7,.7,.7)
  love.graphics.rectangle("fill", window_x/2 - 150, 600, 40, 40)
  if bools.placed_md and bools.placed_mp then
    love.graphics.setColor(1,1,1)
    love.graphics.line(window_x/2 + 110 + 20, 500 - (160/3 - 20) + 10, window_x/2 - 150 + 20, 600 + 10)
    love.graphics.line(window_x/2 - 150 + 20, 400 - (160/3 - 20) + 10, window_x/2 + 110 + 20, 500 - (160/3 - 20) + 10)
    love.graphics.setColor(.7, .7, .7)
    love.graphics.rectangle("fill", window_x/2 - 150 - 40, 600 + 40, 40, 40)
  end
  
  -- seashell next to telescope
  if not bools.found_s2 then
    love.graphics.setColor(shell_colors[2][1], shell_colors[2][2], shell_colors[2][3])
    love.graphics.rectangle("fill", coords.s2_x, coords.s2_y, coords.s2_w, coords.s2_h)
    if near_object(player.x, player.y, player.w, player.h, coords.s2_x, coords.s2_y, coords.s2_w, coords.s2_h) then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", coords.s2_x, coords.s2_y, coords.s2_w, coords.s2_h)
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
  if not bools.found_s3 then
    love.graphics.setColor(shell_colors[3][1], shell_colors[3][2], shell_colors[3][3])
    love.graphics.rectangle("fill", coords.s3_x, coords.s3_y, coords.s3_w, coords.s3_h)
    if near_object(player.x, player.y, player.w, player.h, coords.s3_x, coords.s3_y, coords.s3_w, coords.s3_h) then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", coords.s3_x, coords.s3_y, coords.s3_w, coords.s3_h)
    end  
  end
  
  if not bools.found_s4 then
    love.graphics.setColor(shell_colors[4][1], shell_colors[4][2], shell_colors[4][3])
    love.graphics.rectangle("fill", coords.s4_x, coords.s4_y, coords.s4_w, coords.s4_h)
    if near_object(player.x, player.y, player.w, player.h, coords.s4_x, coords.s4_y, coords.s4_w, coords.s4_h) then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", coords.s4_x, coords.s4_y, coords.s4_w, coords.s4_h)
    end
  end
  
  -- lock
  love.graphics.setColor(.7, .7, .7)
  love.graphics.rectangle("fill", coords.lock_x, coords.lock_y, coords.lock_w, coords.lock_h)
  if near_object(player.x, player.y, player.w, player.h, coords.lock_x, coords.lock_y, coords.lock_w, coords.lock_h) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", coords.lock_x, coords.lock_y, coords.lock_w, coords.lock_h)
  end
  
  -- wall dials
  for i = 1, 8 do
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", coords.d_x[i], coords.d_y, coords.d_w, coords.d_h)
    if near_object(player.x, player.y, player.w, player.h, coords.d_x[i], coords.d_y, coords.d_w, coords.d_h) then
      love.graphics.setColor(.4, .4, .4)
      love.graphics.rectangle("line", coords.d_x[i], coords.d_y, coords.d_w, coords.d_h)
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
  if bools.sun then 
    love.graphics.setColor(1,1,153/255)
    love.graphics.circle("fill", window_x/2, window_y/10, 30)
  else
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle("fill", 0, 0, window_x, window_y)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", window_x/2, window_y/10, 30)
    local scale = coords.star_w/images.ursa_minor:getWidth() -- all same dimensions
    love.graphics.draw(images.ursa_minor, coords.d_x[1] - 45, coords.star_y, 0, scale)  
    love.graphics.draw(images.cygnus, coords.d_x[2] - 45, coords.star_y, 0, scale)  
    love.graphics.draw(images.andromeda, coords.d_x[3] - 45, coords.star_y, 0, scale)  
    love.graphics.draw(images.lyra, coords.d_x[4] - 45, coords.star_y, 0, scale)
    love.graphics.draw(images.draco, coords.d_x[5] - 45, coords.star_y, 0, scale)
    love.graphics.draw(images.cassiopeia, coords.d_x[6] - 45, coords.star_y, 0, scale)
    love.graphics.draw(images.pegasus, coords.d_x[7] - 45, coords.star_y, 0, scale)
    love.graphics.draw(images.orion, coords.d_x[8] - 45, coords.star_y, 0, scale)
  end
  love.graphics.setColor(0, 0, 0)
  if near_object(player.x, player.y, player.w, player.h, window_x/2 - 30, window_y/10 - 30, 60, 60, 40, 40) then
    love.graphics.circle("line", window_x/2, window_y/10, 30)
  end
  
  -- draw opened objects
  if bools.paused then
    star_room:paused()
    if bools.show_dial then
      inventory.on = false
      dials[current.current_dial]:draw()
    elseif bools.show_lock then
      inventory.on = false
      star_lock:draw()
    elseif bools.show_chair_hint then
      inventory.on = false
      love.graphics.setColor(1,1,1)
      love.graphics.draw(images.sticky, window_x/2 - 200, window_y/2 - 200, 0, 400/images.sticky:getWidth(), 400/images.sticky:getHeight())
    elseif bools.show_rock then
      inventory.on = false
      love.graphics.setColor(.7,.7,.7)
      love.graphics.rectangle("fill", window_x/2 - 300, window_y/2 - 300, 600, 600)  
      love.graphics.setColor(1, 1, 1)
      if not bools.found_md then
        love.graphics.rectangle("fill", coords.mr1_x, coords.mr1_y, coords.mr1_w, coords.mr1_h)  
      end
      if not bools.found_mp then
        love.graphics.rectangle("fill", coords.mr2_x, coords.mr2_y, coords.mr2_w, coords.mr2_h)  
      end
      if not bools.found_s1 then
        love.graphics.setColor(shell_colors[1])
        love.graphics.rectangle("fill", coords.s1_x, coords.s1_y, coords.s1_w, coords.s1_h) 
      end
    end
  end
  inventory:draw(player)
  if bools.add_text then
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", window_x - 30, 10, 60, 20)
  end
  
	push:finish()
end

function star_room:update(dt)
  local m_x, m_y = love.mouse.getPosition()
  local mouse_x, mouse_y = m_x * (window_x/cur_x), m_y * (window_y/cur_y)
  if bools.paused then
    if bools.show_dial then
      dials[current.current_dial]:update(mouse_x, mouse_y, dt)
    elseif bools.show_lock then
      star_lock:update(mouse_x, mouse_y, dt)
    elseif bools.show_rock then
      if (near_object(mouse_x, mouse_y, 0, 0, coords.mr1_x, coords.mr1_y, coords.mr1_w, coords.mr1_h) and not bools.found_md) or (near_object(mouse_x, mouse_y, 0, 0, coords.mr2_x, coords.mr2_y, coords.mr2_w, coords.mr2_h) and not bools.found_mp) or (near_object(mouse_x, mouse_y, 0, 0, coords.s1_x, coords.s1_y, coords.s1_w, coords.s1_h) and not bools.found_s1) then
        love.mouse.setCursor(hand_cursor)
      else
        love.mouse.setCursor(arrow_cursor)
      end
    else
      love.mouse.setCursor(arrow_cursor)
    end
  else
    love.mouse.setCursor(arrow_cursor)
    if not bools.climb_chair then
      player:update(dt)
    end
    if bools.move_chair then
      chair:update(dt)
    end
  end
  inventory:update(mouse_x, mouse_y)
  Timer.update(dt)
end

function star_room:keypressed(key)    
  if key == "e" then
    if bools.paused then
      if bools.show_dial then
        bools.show_dial = false
        bools.paused = false
      elseif bools.show_lock then
        bools.show_lock = false
        bools.paused = false
      elseif bools.show_chair_hint then
        bools.show_chair_hint = false
        bools.paused = false
      elseif bools.show_rock then
        bools.show_rock = false
        bools.paused = false
      end
    else
      -- dials
      for i = 1, 8 do
        if near_object(player.x, player.y, player.w, player.h, coords.d_x[i], coords.d_y, coords.d_w, coords.d_h) then
          bools.show_dial = true
          current.current_dial = i
          bools.paused = true
          break
        end
      end
      
      --lock
      if near_object(player.x, player.y, player.w, player.h, coords.lock_x, coords.lock_y, coords.lock_w, coords.lock_h) then
        bools.show_lock = true
        bools.paused = true
      -- sun/moon
      elseif near_object(player.x, player.y, player.w, player.h, window_x/2 - 30, window_y/10 - 30, 60, 60, 40, 40) then
        bools.sun = not bools.sun
      -- sticky note 
      elseif near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h, -3, -3) then
        bools.show_chair_hint = true
        bools.paused = true
      -- large rock
      elseif near_object(player.x, player.y, player.w, player.h, coords.rock_x, coords.rock_y, coords.rock_w, coords.rock_h) and (not bools.found_md or not bools.found_mp or not bools.found_s1) then
        bools.show_rock = true
        bools.paused = true
      -- mirror_d
      elseif near_object(player.x, player.y, player.w, player.h, window_x/2 - 150, 400, 40, 20) then
        if bools.placed_md then
          inventory:add(mirror_d)
          bools.placed_md = false
        elseif not placed_md and inventory.items[inventory.clicked_index] == mirror_d then
          inventory:remove(mirror_d)
          bools.placed_md = true
        end
      -- mirror_p
      elseif near_object(player.x, player.y, player.w, player.h, window_x/2 + 110, 500, 40, 20) then
        if bools.placed_mp then
          inventory:add(mirror_p)
          bools.placed_mp = false
        elseif not bools.placed_mp and inventory.items[inventory.clicked_index] == mirror_p then
          inventory:remove(mirror_p)
          bools.placed_mp = true
        end
      -- shell 2
      elseif near_object(player.x, player.y, player.w, player.h, coords.s2_x, coords.s2_y, coords.s2_w, coords.s2_h) and not bools.found_s2 then
        inventory:add(shells[2])
        bools.found_s2 = true
        Timer.during(1, function() bools.add_text = true end, function() bools.add_text = false end)
      -- shell 3
      elseif near_object(player.x, player.y, player.w, player.h, coords.s3_x, coords.s3_y, coords.s3_w, coords.s3_h) and not bools.found_s3 then
        inventory:add(shells[3])
        bools.found_s3 = true
        Timer.during(1, function() bools.add_text = true end, function() bools.add_text = false end)      
      -- shell 4
      elseif near_object(player.x, player.y, player.w, player.h, coords.s4_x, coords.s4_y, coords.s4_w, coords.s4_h) and not bools.found_s4 then
        inventory:add(shells[4])
        bools.found_s4 = true
        Timer.during(1, function() bools.add_text = true end, function() bools.add_text = false end)  
      end
    end
  -- chair
  elseif key == "m" and not bools.climb_chair and near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h) and not bools.paused then
    bools.move_chair = not bools.move_chair
  elseif key == "c" and near_object(player.x, player.y, player.w, player.h, chair.x, chair.y, chair.w, chair.h) and not bools.paused then
    bools.climb_chair = not bools.climb_chair
    bools.move_chair = false
    if bools.climb_chair then
      player.x = chair.x - (player.w - chair.w)/2
      player.y = chair.y - player.h
    else
      player.x = chair.x + (chair.w/2) - player.w/2
      player.y = chair.y + chair.h - player.h
    end
  elseif key == "i" then
    bools.paused = false
    inventory.on = not inventory.on
    inventory.clicked_index = nil
  end
end

function star_room:mousereleased(x, y, button)
  mouse_x, mouse_y = x * window_x/cur_x, y * window_y/cur_y
  bools.paused = inventory:mousereleased(mouse_x, mouse_y, button, bools.paused)
  if bools.show_dial then
    dials[current.current_dial]:mousereleased(mouse_x, mouse_y, button)
  elseif bools.show_lock then
    star_lock:mousereleased(mouse_x, mouse_y, button)
  elseif bools.show_rock then
    if near_object(mouse_x, mouse_y, 0, 0, coords.mr1_x, coords.mr1_y, coords.mr1_w, coords.mr1_h) and not bools.found_md then
      bools.found_md = true
      inventory:add(mirror_d)
      Timer.during(1, function() bools.add_text = true end, function() bools.add_text = false end)
    elseif near_object(mouse_x, mouse_y, 0, 0, coords.mr2_x, coords.mr2_y, coords.mr2_w, coords.mr2_h) and not bools.found_mp then
      bools.found_mp = true
      inventory:add(mirror_p)
      Timer.during(1, function() bools.add_text = true end, function() bools.add_text = false end)
    elseif near_object(mouse_x, mouse_y, 0, 0, coords.s1_x, coords.s1_y, coords.s1_w, coords.s1_h) and not bools.found_s1 then
      bools.found_s1 = true
      inventory:add(shells[1])
      Timer.during(1, function() bools.add_text = true end, function() bools.add_text = false end)
    end
  end
end

function star_room:paused()
  love.graphics.setColor(0, 0, 0, .8)
  love.graphics.rectangle("fill", 0, 0, window_x, window_y)
end

return star_room