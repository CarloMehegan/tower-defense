local Enemy = require 'enemy'
local Timer = require 'timer'
local Tower = require 'tower'

function love.load()
  fullscreen = false
  love.window.setMode( 1200, 820, {resizable = true, minwidth=800, minheight=600})
  love.graphics.setBackgroundColor(185/255, 241/255, 250/255, 1)

  goals ={{163,66},{169,97},{175,126},{176,157},{177,191},{175,233},{180,274},{185,322},{189,360},{192,401},{191,435},{192,484},{195,521},{201,561},{211,603},{221,647},{245,689},{277,708},{309,711},{348,696},{378,652},{381,621},{373,590},{362,534},{348,479},{340,416},{329,378},{319,336},{317,305},{312,279},{310,244},{309,206},{310,136},{315,94},{318,62},{315,50},{316,40},{317,33},{323,30},{333,26},{350,25},{375,26},{395,30},{425,43},{460,60},{497,86},{521,111},{543,143},{559,178},{571,222},{578,266},{585,314},{599,364},{618,426},{639,461},{680,493},{727,512},{795,521},{847,524},{901,522},{971,521},{1015,517},{1045,515},{1064,516}}
  enemies = {}

  mousepath = {}
  lastPosx, lastPosy = 0,0
  mousetimer = Timer:new(function()
    if love.mouse.isDown(1) then
      if love.mouse.getX() ~= lastPosx and love.mouse.getY() ~= lastPosy then
        table.insert( mousepath, {love.mouse.getPosition()} )
        love.system.setClipboardText( table.tostring(mousepath) )
      end
      lastPosx, lastPosy = love.mouse.getPosition()
    end
  end, 0.1)

  enemytimer = Timer:new(function()
    table.insert(enemies, Enemy:new({ x = 10, y = 10, goals = goals, speed = love.math.random(100,150)/100 }) )
  end, 0.1)

  t = Tower:new({ x = 250, y = 400 })
end

function love.update(dt)
  for k,e in pairs(enemies) do
    e:update()
    if e.x > 900 then
      table.remove( enemies, k )
    end
  end

  mousetimer:update(dt)
  enemytimer:update(dt)
end

function love.draw()
  for k,e in pairs(enemies) do
    e:draw()
  end
  t:draw()
  -- love.graphics.print(e.currentgoal .. "\n" .. e.dx .. "\n" .. e.dy .. "\n" .. math.sqrt( e.dx*e.dx + e.dy*e.dy ))
  love.graphics.print(table.tostring(mousepath), 20, 300)
end


function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
  if key == "f" then
    if fullscreen == false then
      love.window.setMode( 800, 600, {fullscreen = true} )
      fullscreen = true
    elseif fullscreen == true then
      love.window.setMode( 1200, 820, {resizable = true, minwidth=800, minheight=600})
      fullscreen = false
    end
  end
end


-- for saving path data from mouse recording
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end