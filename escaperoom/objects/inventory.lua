Inventory = Object:extend(Object)

function Inventory:new()
  -- in the future: items are expected to be drawable objects
  self.items  = {}
  self.total_items = 10
  self.on = false
  self.clicked_index = nil
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
    for i = 1, #self.items do
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
      if self.items[self.clicked_index].interact then
        love.graphics.setColor(1,1,1)
        self.items[self.clicked_index]:inspect()
      else
        love.graphics.setColor(1, 1, 1)
        self.items[self.clicked_index]:display(player.x + player.w/2 - 20, player.y - 45, 40, 40)
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
        if self.clicked_index ~= nil and self.items[self.clicked_index].interact then
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
    if self.items[i] == items then
      self.items[i] = nil
      return
    end
  end
end
  
  
function Inventory:mousereleased(x, y, button, paused)
  -- interact with inventory
  if button == 1 and self.on then
    for i = 1, self.total_items do
      if near_object(x, y, 0, 0, self.item_width * (i - 1), 0, self.item_width, self.y, 0, 0) then
        -- select item
        if self.items[i] ~= nil and (self.clicked_index == nil or self.clicked_index ~= i) then
          self.clicked_index = i
          if self.items[self.clicked_index].interact then
            paused = true
          else 
            paused = false
          end
          return paused
        -- unselect previously selected item
        elseif self.clicked_index == i then
          self.clicked_index = nil
          paused = false
          return paused
        end
      end
    end
    if self.clicked_index ~= nil and self.items[self.clicked_index].interact then
      self.items[self.clicked_index]:mousereleased(x, y, button)
    end
  end
  return paused
end