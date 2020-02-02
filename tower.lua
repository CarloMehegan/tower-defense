local class = require 'middleclass'

local Bullet = require 'bullet'

local Timer = require 'timer'

Tower = class('Tower')

function Tower:initialize( table )
  self.img = love.graphics.newImage('sprites/sidsmonkey.png')
  self.x = table.x or 0
  self.y = table.y or 0
  self.orientation = 0
  self.speed = table.speed or 1
  self.reachradius = 100
  self.projectiles = {}
  self.hasTarget = false
  self.target = null
  self.timer = Timer:new(function() 
    self:lockOn(enemies)
  end, {max = self.speed, manualreset = true})
end

function Tower:update(dt)
  self.timer:update(dt)
  for k,v in pairs(self.projectiles) do
    v:update(dt, enemies)
    if v.dead then
      table.remove( self.projectiles, k )
    end
  end
end

function Tower:lockOn(enemies)
  --reverse table
  local e = enemies
  local i, j = 1, #e
  while i < j do
    e[i], e[j] = e[j], e[i]
    i = i + 1
    j = j - 1
  end

  --find enemy thats first in line and save their key in the array
  local firstinline = 0
  local firstinlinekey = 0
  for k,v in pairs(e) do
    firstinline = math.max( firstinline, v.currentgoal )
    if v.currentgoal == firstinline then
      a = self.x - v.x
      b = self.y - v.y
      c = math.sqrt((a* a) + (b * b))
      if c < self.reachradius + v.r then
        self.target = v
        self.hasTarget = true
        --find orientation to turn the sprite
        if a < 0 then -- the angle is flipped on left vs right for some math reason
          self.orientation = math.atan( b/a ) + math.pi/2
        else
          self.orientation = math.atan( b/a ) + 3*math.pi/2
        end
      end
      firstinlinekey = k
    end
  end
  
  if self.hasTarget then
    self.timer.current = 0
    self:shoot(self.target)
    self.hasTarget = false
  end

end

function Tower:shoot(v)
  --direction to go
  local diffx = v.x - self.x
  local diffy = v.y - self.y
  --hypotenuse
  local c = math.sqrt(diffx*diffx + diffy*diffy)
  --normalizing
  local bulletdx = diffx / c * 20
  local bulletdy = diffy / c * 20
  table.insert( self.projectiles, Bullet:new( {x = self.x, y = self.y, dx = bulletdx, dy = bulletdy} ) )
end

function Tower:draw()
  local timepercent = self.timer.current / self.timer.max * 0.4
  love.graphics.setColor(0.4 - timepercent, 0.4 - timepercent, 1, 1)
  -- love.graphics.circle("fill", self.x, self.y, 20)
  
  love.graphics.setColor(1, 0, 1, 0.2)
  love.graphics.circle("fill", self.x, self.y, self.reachradius)
  love.graphics.setColor(1, 1, 1, .9)
  love.graphics.draw(self.img, self.x, self.y, self.orientation, 3, 3, 8, 8) --monkey
  for k,v in pairs(self.projectiles) do
    v:draw()
  end
end

return Tower
