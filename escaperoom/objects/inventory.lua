Inventory = Object:extend(Object)

function Inventory:new(items)
  -- in the future: items are expected to be drawable objects
  self.items  = {}
  self.total_items = items
  self.on = false -- is inventory open?
  self.clicked_index = nil 
  self.inspect = false
  self.interact = false
  for i = 1, self.total_items do
    self.items[i] = nil
  end
  self.item_width = 50
  self.x, self.y = self.total_items * self.item_width, 50
end

function Inventory:draw(player)
  if self.on then
    -- draw background
    love.graphics.setColor(1,1,1,.7)
    love.graphics.rectangle('fill', 0, 0, self.x, self.y)
    -- draw each item
    for i = 1, self.total_items do
      if self.items[i] ~= nil then
        love.graphics.setColor(1,1,1,1)
        self.items[i]:display(self.item_width * (i - 1), 0, self.item_width, self.y)
      end
    end
    -- draw dividing lines
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, self.x, self.y)
    for i = 1, self.total_items + 1 do 
      love.graphics.line(self.item_width * (i - 1), 0, self.item_width * (i - 1), self.y)
    end
  
    -- display clicked item above player or interact 
    if self.clicked_index ~= nil then
      love.graphics.setColor(.8, .8, .8)
      love.graphics.rectangle("line", self.item_width * (self.clicked_index - 1), 0, self.item_width, self.y)
      if self.inspect then
        love.graphics.setColor(1,1,1)
        self.items[self.clicked_index]:insp()
      elseif self.interact then
        love.graphics.setColor(1, 1, 1)
        self.items[self.clicked_index]:int(player.x + player.w/2 - self.item_width/2, player.y - self.y - 5, self.item_width, self.y)
      end 
    end    
  end
end

function Inventory:update(mouse_x, mouse_y)
  if self.on then
    for i = 1, self.total_items do
      if near_object(mouse_x, mouse_y, 0, 0, self.item_width * (i - 1), 0, self.item_width, self.y, 0, 0) and self.items[i] ~= nil then
        love.mouse.setCursor(hand_cursor)
        break
      else
        if self.clicked_index ~= nil and self.inspect then
          self.items[self.clicked_index]:cursor(mouse_x, mouse_y)
        else
          love.mouse.setCursor(arrow_cursor)
        end
      end
    end
  end
end

function Inventory:add(item)
  -- item should be a drawable, add to first empty slot
  for i = 1, self.total_items do
    if self.items[i] == nil then
      self.items[i] = item
      return
    end
  end
end

function Inventory:remove(item)
  for i = 1, self.total_items do
    if self.items[i] == item then
      self.items[i] = nil
      self.clicked_index = nil
      self.inspect = false
      self.interact = false
      return
    end
  end
end
  
  
function Inventory:mousereleased(x, y, button, paused)
  -- interact with inventory
  if self.on then
    for i = 1, self.total_items do
      if near_object(x, y, 0, 0, self.item_width * (i - 1), 0, self.item_width, self.y, 0, 0) and self.items[i] ~= nil then
        -- unselect previously selected item, reset clicked
        if self.clicked_index == i and ((self.inspect and button == 2) or (self.interact and button == 1)) then
          self.inspect = false
          self.interact = false
          self.clicked_index = nil
          return false
        -- select item
        else
          if button == 2 then
            self.inspect = true
            self.interact = false
            self.clicked_index = i
            return true
          elseif button == 1 then
            self.inspect = false
            self.interact = true
            self.clicked_index = i
            return false
          end
        end
      end
    end
    if self.inspect then
      self.items[self.clicked_index]:mousereleased(x, y, button)
    end
  end
  return paused
end