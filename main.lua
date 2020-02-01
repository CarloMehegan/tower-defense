local Enemy = require 'enemy'
local Timer = require 'timer'
local Tower = require 'tower'
local Bullet = require 'bullet'

function love.load()
  fullscreen = false
  love.window.setMode( 1200, 820, {resizable = true, minwidth=800, minheight=600})
  love.graphics.setBackgroundColor(185/255, 241/255, 250/255, 1)

  goals ={{4,32},{13,31},{17,30},{22,29},{26,28},{30,29},{36,30},{41,32},{49,36},{59,40},{64,43},{69,46},{74,51},{80,57},{84,61},{88,65},{92,69},{98,74},{102,79},{107,83},{112,88},{117,94},{123,99},{127,104},{131,109},{137,118},{141,127},{147,138},{150,145},{153,153},{156,161},{160,168},{163,172},{166,179},{170,189},{174,201},{176,212},{178,221},{179,232},{180,242},{182,255},{184,265},{185,275},{186,290},{187,305},{186,324},{185,331},{184,339},{183,347},{182,355},{181,382},{180,391},{178,397},{174,408},{172,417},{170,423},{168,432},{165,443},{161,454},{159,461},{158,471},{157,478},{156,485},{154,494},{153,501},{152,510},{154,526},{156,532},{157,536},{161,543},{165,552},{167,556},{173,564},{178,573},{181,577},{185,581},{190,586},{194,590},{196,592},{199,593},{203,594},{208,595},{227,594},{233,592},{238,590},{242,588},{246,586},{250,582},{254,579},{257,575},{261,569},{266,563},{270,557},{274,552},{278,546},{284,533},{289,520},{294,509},{297,498},{301,489},{306,478},{310,466},{311,459},{312,451},{313,442},{316,423},{317,417},{323,401},{329,390},{334,378},{339,362},{343,349},{346,342},{350,338},{354,333},{358,329},{362,325},{367,321},{371,317},{375,313},{379,311},{383,309},{388,308},{393,306},{397,303},{401,301},{406,298},{415,295},{420,292},{429,290},{436,289},{486,293},{502,298},{514,303},{522,307},{533,311},{542,315},{550,320},{557,324},{564,328},{569,331},{573,334},{581,339},{586,343},{591,345},{594,346},{600,351},{605,354},{610,355},{617,358},{621,359},{628,361},{636,363},{644,366},{649,367},{655,369},{660,371},{666,373},{671,375},{680,378},{685,380},{691,382},{696,386},{710,390},{726,395},{737,400},{749,403},{755,406},{762,409},{774,413},{785,416},{791,417},{795,418},{802,420},{810,421},{822,423},{833,426},{840,428},{846,431},{855,434},{866,437},{872,438},{885,442},{897,446},{903,447},{915,450},{929,454},{939,458},{952,462},{968,466},{995,468},{1008,469},{1021,470},{1032,469},{1053,468},{1068,466},{1073,465}}
  
  enemies = {}
  towers = {}

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
  end, {max = 0.05})

  enemytimer = Timer:new(function()
    table.insert(enemies, Enemy:new({ x = 10, y = 10, goals = goals, speed = 0.5}) )
  end, {max = 1})

  table.insert(towers, Tower:new({ x = 250, y = 400, speed = 0.4 }))
  
end

function love.update(dt)
  for k,e in pairs(enemies) do
    e:update()
    if e.x > 900 or e.dead == true then -- TEMP
      table.remove( enemies, k )
    end -- TEMP
  end

  for k,t in pairs(towers) do
    for k,v in pairs(t.projectiles) do
      for k1,e in pairs(enemies) do
        -- checks if the circles collide
        if checkCircleCollision(e,v) then
          e.hp = e.hp - 1
          table.remove( t.projectiles, k )
        end
      end
    end
  end

  for k,t in pairs(towers) do
    t:update(dt, enemies)
  end
  
  mousetimer:update(dt)
  enemytimer:update(dt)
end

function love.draw()
  for k,e in pairs(enemies) do
    e:draw()
  end
  for k,t in pairs(towers) do
    t:draw()
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
  if key == "t" then
    local mx, my = love.mouse.getPosition()
    table.insert(towers, Tower:new({ x = mx, y = my }))
  end
end


function checkCircleCollision(ob1, ob2)
  a = ob1.x - ob2.x
  b = ob1.y - ob2.y
  c = math.sqrt((a* a) + (b * b))
  if c < ob1.r + ob2.r then
    return true
  else
    return false
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