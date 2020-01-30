local class = require 'middleclass'

Bullet = class('Bullet')

function Bullet:initialize( table )
  self.x = table.x or 0
  self.y = table.y or 0
  self.dx = table.dx or 0
  self.dy = table.dy or 0
  self.speed = table.speed or 1
  self.dead = false
end

function Bullet:update(dt)
  self.x = self.x + self.dx
  self.y = self.y + self.dy
  local ww, wh = love.graphics.getDimensions()
  if self.x < -50 or self.y < -50 or self.x > ww + 50 or self.y > wh + 50 then
    self.dead = true
  end
end

function Bullet:draw()
  love.graphics.setColor(1, 0, 1, 1)
  love.graphics.circle("fill", self.x, self.y, 4)
  love.graphics.print(self.dx .. " , " .. self.dy)
end

return Bullet
