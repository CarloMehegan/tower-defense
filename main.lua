local Enemy = require 'enemy'
local Timer = require 'timer'

function love.load()
  fullscreen = false
  love.window.setMode( 1200, 820, {resizable = true, minwidth=800, minheight=600})
  love.graphics.setBackgroundColor(185/255, 241/255, 250/255, 1)

  goals ={{61,522},{86,527},{111,536},{144,545},{170,555},{201,563},{241,572},{315,560},{337,538},{355,514},{372,469},{383,415},{403,364},{429,338},{464,321},{486,319},{512,321},{534,328},{557,344},{572,370},{585,407},{593,448},{601,496},{604,547},{605,592},{607,636},{621,678},{645,716},{688,746},{739,760},{811,754},{841,738},{887,696},{909,638},{919,564},{918,496},{909,414},{903,344},{889,270},{861,217},{820,184},{783,165},{725,157},{659,168},{593,178},{528,187},{451,198},{383,194},{311,184},{263,170},{236,141},{233,123},{255,103},{299,85},{367,62},{425,57},{489,54},{547,58},{609,66},{667,64},{726,62},{770,61},{821,60},{863,54},{965,65},{990,89},{1006,122},{1011,158},{1003,201},{999,245},{1027,275},{1088,282},{1134,303},{1146,334},{1151,368},{1143,390},{1131,404},{1117,412},{1099,414},{1077,420},{1059,435},{1051,459},{1048,491},{1053,534},{1060,578},{1054,624},{1044,642},{1023,648},{1004,650},{972,652},{856,653},{791,654},{718,652},{637,641},{573,633},{499,620},{445,606},{383,600},{333,604},{291,613},{264,619},{241,634},{226,656},{215,678},{209,710},{210,742},{212,778},{213,800},{212,804},{211,808}}
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

end

function love.update(dt)
  for k,e in pairs(enemies) do
    e:update()
  end

  mousetimer:update(dt)
  enemytimer:update(dt)
end

function love.draw()
  for k,e in pairs(enemies) do
    e:draw()
  end

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