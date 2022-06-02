Inventory = Object:extend(Object)

function Inventory:new()
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
        width, height = self.items[i]:getWidth(), self.items[i]:getHeight()
        love.graphics.draw(self.items[i], self.item_width * (i - 1), 0, 0, self.item_width/width, self.y/height)
      end
    end
    -- draw dividing lines
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, self.x, self.y)
    for i = 1, self.total_items + 1 do 
      love.graphics.line(self.item_width * (i - 1), 0, self.item_width * (i - 1), self.y)
    end
  
    -- display clicked item above player
    if self.clicked_index ~= nil then
      cur = self.items[self.clicked_index]
      if cur ~= nil then  
        love.graphics.setColor(.8, .8, .8)
        love.graphics.rectangle("line", self.item_width * (self.clicked_index - 1), 0, self.item_width, self.y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(cur, player.x + player.w/2 - 20, player.y - 45, 0, 40/cur:getWidth(), 40/cur:getHeight())
      end
    end
  end
end

function Inventory:update(str, item)
  local mouse_x, mouse_y = love.mouse.getPosition()
  for i = 1, self.total_items do
    if near_object(mouse_x, mouse_y, 0, 0, self.item_width * (i - 1), 0, self.item_width, self.y, 0, 0) and self.items[i] ~= nil then
      love.mouse.setCursor(hand_cursor)
      break
    else
      love.mouse.setCursor(arrow_cursor)
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
  
  
function Inventory:mousereleased(x, y, button)
  if button == 1 and inventory.on then
    for i = 1, inventory.total_items do
      if near_object(x, y, 0, 0, inventory.item_width * (i - 1), 0, inventory.item_width, inventory.y, 0, 0) then
        -- select item
        if inventory.items[i] ~= nil and (inventory.clicked_index == nil or inventory.clicked_index ~= i) then
          inventory.clicked_index = i
        -- unselect previously selected item
        elseif inventory.clicked_index == i then
          inventory.clicked_index = nil
        end
      end
    end
  end  
end