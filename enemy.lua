local class = require 'middleclass'

Enemy = class('Enemy')

colors = {
  {.9,.1,.1},
  {.1,.1,.9},
  {.1,.9,.3},
  {.9,.9,.1}
}

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
  self.speed = table.speed or 1
  self.onPath = false
  self.gx = 0
  self.gy = 0
  self.dead = false
  self.hp = love.math.random(1,4)
  self.maxhp = self.hp
  self.c = colors[self.hp]
  self.r = 10 + self.hp
end

function Enemy:update(dt)
  if self.onPath then
    self:updatePath()
    self.x = self.x + self.dx*self.speed*4
    self.y = self.y + self.dy*self.speed*4
    self.c = colors[self.hp]
    self.r = 10 + self.hp
  end

  if self.onPath == false then
    self:setPath(self.goals[self.currentgoal][1], self.goals[self.currentgoal][2])
  end

  if self.hp <= 0 then
    self.dead = true
  end

end

function Enemy:draw()
  love.graphics.setColor(0,0,0,1)
  love.graphics.circle("fill", self.x, self.y, self.r + 1)
  love.graphics.setColor(self.c)
  love.graphics.circle("fill", self.x, self.y, self.r)
  if self.hp < self.maxhp then
    love.graphics.rectangle("line", self.x - self.r, self.y - self.r - 5, self.r*2, 3)
    local hppercent = self.hp/self.maxhp
    love.graphics.rectangle("fill", self.x - self.r, self.y - self.r - 5, self.r*2 * hppercent, 3)
  end
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
  local error = 5
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
    c = c / self.speed
    --normalizing
    self.dx = diffx / c
    self.dy = diffy / c
  end
end

return Enemy
