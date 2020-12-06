Inventory = Object:extend(Object)

function Inventory:new()
  items  = {}
end

function Inventory:draw()
  if love.keyboard.isDown("v") then
    love.graphics.rectangle('fill', 0, 0, 100, 70)
    for i = 1, #items do
      love.graphics.draw(items[i], 20*i, 0, .1, .1)
    end
  end
end

function Inventory:update(playerx, playery)
  if playerx + playerw/2 >= swordx then
    if items[1] == nil then
      table.insert(items, sword)
      bool = false
    end
  end
end