local class = require 'middleclass'

Timer = class('Timer')

function Timer:initialize( func, max )
  self.current = current or 0--current time in seconds
  self.max = max or 10--max time in seconds
  self.func = func
end

function Timer:update(dt)
  self.current = self.current + dt
  if self.current >= self.max then
    self.current = 0
    self.func()
    return true
  end
  return false
end

return Timer
