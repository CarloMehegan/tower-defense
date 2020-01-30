local class = require 'middleclass'

local Bullet = require 'bullet'

Tower = class('Tower')

function Tower:initialize( table )
  self.x = table.x or 0
  self.y = table.y or 0
  self.speed = table.speed or 1
  self.reachradius = 100
  self.projectiles = {}
  self.hasTarget = false
  self.target = null
end

function Tower:update(dt)
  for k,v in pairs(self.projectiles) do
    v:update(dt)
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

  --find target
  if self.hasTarget == false then

  for k,v in pairs(e) do -- look through all enemies
    if self.hasTarget == false then
      a = self.x - v.x
      b = self.y - v.y
      c = math.sqrt((a* a) + (b * b))
      if c < self.reachradius + v.r then
        self.target = v
        self.hasTarget = true
      end
    else
      break -- look for enemy, stop when found one
    end
  end

  --if there's already a target, continue fire
  else
    a = self.x - self.target.x
    b = self.y - self.target.y
    c = math.sqrt((a* a) + (b * b))
    if c < self.reachradius + self.target.r then
      self:shoot(self.target) -- make bullet
    else
      self.hasTarget = false
    end
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
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.circle("fill", self.x, self.y, 20)
  love.graphics.setColor(1, 0, 1, 0.3)
  love.graphics.circle("fill", self.x, self.y, self.reachradius)
  for k,v in pairs(self.projectiles) do
    v:draw()
  end
end

return Tower
