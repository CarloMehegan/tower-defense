local class = require 'middleclass'

Timer = class('Timer')

function Timer:initialize( func, table )
  self.current = current or 0--current time in seconds
  self.max = table.max or 10--max time in seconds
  self.func = func
  --for some timers, like tower timers, we want to reset the cooldown on an event.
  self.manualreset = table.manualreset or false
end

function Timer:update(dt)
  self.current = self.current + dt
  if self.current >= self.max then
    self.current = self.max
    if self.manualreset == false then
      self.current = 0
    end
    self.func()
    return true
  end
  return false
end

return Timer
