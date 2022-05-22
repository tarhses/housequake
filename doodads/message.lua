local lg = love.graphics

local Message = {}
Message.__index = Message

function Message.new(amount, x, y, duration)
  local font = lg.getFont()
  local self = setmetatable({}, Message)
  self.amount = amount
  self.x = x
  self.y = y
  self.w = font:getWidth(amount)
  self.h = font:getHeight()
  self.duration = duration
  self.timer = 0
  return self
end

function Message:isActive()
  return self.timer < self.duration
end

function Message:draw()
  local remaining = self.timer / self.duration
  local elapsed = 1 - remaining
  lg.setColor(1, 1, 1, elapsed)
  lg.print(self.amount, self.x, self.y - 32*remaining, 0, 1, 1, self.w / 2, self.h / 2)
  lg.setColor(1, 1, 1, 1)
end

function Message:update(dt)
  self.timer = self.timer + dt
end

return Message
