local Enemy = require 'enemy'

function love.load()
  fullscreen = false
  love.window.setMode( 1200, 820, {resizable = true, minwidth=800, minheight=600})
  love.graphics.setBackgroundColor(185/255, 241/255, 250/255, 1)

  egoals = {
    -- {40,100},
    -- {300,400},
    -- {500,500},
    -- {100,300},
    -- {500,100}
    {100,100},
    {100,130},
    {100,160},
    {100,190},
    {100,210},
    {100,310},
    {300,450}
    -- {160,370}
    
  }



 goals = {{13,221},{83,175},{185,154},{253,182},{318,243},{392,321},{459,365},{487,398},{527,447},{590,497},{679,539},{805,565},{880,564},{917,547},{975,518},{1037,498},{1083,481},{1163,443},{1205,431},{1284,409}}


 e = Enemy:new({ x = 10, y = 10, goals = goals })

  mousepath = {}
  lastPosx, lastPosy = 0,0
  mousetimer = 1
  mousetimermax = 5
end

function love.update()
  e:update()

  

  if love.mouse.isDown(1) then
    mousetimer = mousetimer + 1
    if mousetimer >= mousetimermax then 
      mousetimer = 1
      if love.mouse.getX() ~= lastPosx and love.mouse.getY() ~= lastPosy then
        table.insert( mousepath, {love.mouse.getPosition()} )
        love.system.setClipboardText( table.tostring(mousepath) )
      end
      lastPosx, lastPosy = love.mouse.getPosition()
    end
  end
end

function love.draw()
  e:draw()
  love.graphics.print(e.currentgoal .. "\n" .. e.dx .. "\n" .. e.dy .. "\n" .. math.sqrt( e.dx*e.dx + e.dy*e.dy ))
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