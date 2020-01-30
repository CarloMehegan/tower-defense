local class = require 'middleclass'

Enemy = class('Enemy')

function Enemy:initialize( table )
  self.x = table.x or love.math.random(100,200)
  self.y = table.y or love.math.random(100,200)
  self.dx = 0
  self.dy = 0
  self.goals = table.goals or {}
  self.goaltablelength = 0
  for i,v in ipairs(self.goals) do
    self.goaltablelength = self.goaltablelength + 1
  end
  self.currentgoal = 1
  self.speed = 1
  self.onPath = false
  self.gx = 0
  self.gy = 0
end

function Enemy:update(dt)
  if self.onPath then
    self:updatePath()
    self.x = self.x + self.dx*self.speed*4
    self.y = self.y + self.dy*self.speed*4
  end

  if self.onPath == false then
    self:setPath(self.goals[self.currentgoal][1], self.goals[self.currentgoal][2])
    -- self:setPath(400, 400)
  end

end

function Enemy:draw()
  love.graphics.circle("line", self.x, self.y, 10)
end

function Enemy:setPath(gx,gy) -- goalx, goaly
  self.gx = gx
  self.gy = gy
  self.onPath = true

  --direction to go
  local diffx = self.gx - self.x
  local diffy = self.gy - self.y
  --hypotenuse
  local c = math.sqrt(diffx*diffx + diffy*diffy)
  --normalizing
  self.dx = diffx / c
  self.dy = diffy / c
end

function Enemy:updatePath() -- goalx, goaly
  local error = 3
  if self.x < self.gx + error
    and self.x > self.gx - error
    and self.y < self.gy + error
    and self.y > self.gy - error
  then
    self.onPath = false
    self.currentgoal = self.currentgoal + 1
    if self.currentgoal == self.goaltablelength + 1 then self.currentgoal = 1 end
  else
    --direction to go
    local diffx = self.gx - self.x
    local diffy = self.gy - self.y
    --hypotenuse
    local c = math.sqrt(diffx*diffx + diffy*diffy)
    --normalizing
    self.dx = diffx / c
    self.dy = diffy / c
  end
end

return Enemy
