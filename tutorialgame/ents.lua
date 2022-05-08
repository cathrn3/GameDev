ents = {} --table
ents.objects = {}  --list of ent objects
ents.objpatch =  "entities/"--path to entities
local register = {}
local id = 0

function ents.Startup()
  
end

function ents.Create(name,x,y)
  --spawn entities
  if not x then
    x = 0
  end
  if not y then
    y = 0
  end
  if register[name] then --entity exists
    id = id + 1 --unique id number for ents
    local ent = register[name]{}
    ent:load() --run fnc in table
    ent:setPos(x, y)
    ent.id = id
    ents.objects[#ents.objects + 1] = ent --amount of objects in table plus one to make new ent
    return ents.objects[#ents.objects]
  else
    print("error")
    return false
  end
end