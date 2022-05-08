Inventory = Object:extend(Object)

function Inventory:new()
  self.on = on
  text = love.graphics.newText(love.graphics.getFont(), "test")
  items  = {}
  total_items = 8
  inventory_x, inventory_y = 400, 50
  item_width = inventory_x / 8
end

function Inventory:draw(inventory_on)
  -- love.graphics.draw(items[1])
  if inventory_on then
    love.graphics.setColor(1,1,1,.7)
    love.graphics.rectangle('fill', 0, 0, inventory_x, inventory_y)
    for i = 1, #items do
      love.graphics.setColor(0,0,0)
      love.graphics.draw(items[i], item_width * (i - 1), 0)
    end
    
    for i = 1, total_items + 1 do 
      love.graphics.setColor(0,0,0) 
      love.graphics.line(item_width * (i - 1), 0, item_width * (i - 1), inventory_y)
    end
  end
end

function Inventory:update(player_x, player_y)
  
end