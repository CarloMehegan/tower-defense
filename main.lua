local Enemy = require 'enemy'

function love.load()
  fullscreen = false
  love.window.setMode( 1200, 820, {resizable = true, minwidth=800, minheight=600})

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
  e = Enemy:new({ x = 10, y = 10, goals = egoals })
end

function love.update()
  e:update()
end

function love.draw()
  e:draw()
  love.graphics.print(e.currentgoal .. "\n" .. e.dx .. "\n" .. e.dy .. "\n" .. math.sqrt( e.dx*e.dx + e.dy*e.dy ))
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