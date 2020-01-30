local class = require 'middleclass'

Tower = class('Tower')

function Tower:initialize( table )
  self.x = table.x or 0
  self.y = table.y or 0
  self.speed = table.speed or 1
  self.reachradius = 100
end

function Tower:update(dt)
  
end

function Tower:lockOn(enemies)
  local e = enemies
  local i, j = 1, #e
  while i < j do
    e[i], e[j] = e[j], e[i]
    i = i + 1
    j = j - 1
  end
  for k,v in pairs(e) do
    a = self.x - v.x
    b = self.y - v.y
    c = math.sqrt((a* a) + (b * b))
    if c < self.reachradius + v.r then
      self:shoot(v)
    end
  end
end

function Tower:shoot(v)

end

function Tower:draw()
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.circle("fill", self.x, self.y, 20)
  love.graphics.setColor(1, 0, 1, 0.3)
  love.graphics.circle("fill", self.x, self.y, self.reachradius)
end

return Tower
