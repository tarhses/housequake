local lg = love.graphics
local lm = love.mouse

local Button = {}
Button.__index = Button

local WAIT_DURATION = 2
local FADE_DURATION = 0.8
local PADDING = 4
local ROUNDING = 2

function Button.new(x, y, text, handle)
  local self = setmetatable({}, Button)
  self.x = x
  self.y = y
  self.w = lg.getFont():getWidth(text)
  self.h = lg.getFont():getHeight()
  self.text = text
  self.handle = handle
  self.timer = 0
  return self
end

function Button:contains(x, y)
  return x >= self.x and y >= self.y and x < self.x + self.w and y < self.y + self.h
end

function Button:update(dt)
  self.timer = self.timer + dt

  local x, y = lm.getPosition()
  x = x / SCALE
  y = y / SCALE

  if self.timer > WAIT_DURATION and lm.isDown(1) and self:contains(x, y) then
    self.handle()
  end
end

function Button:draw()
  local remaining = (self.timer-WAIT_DURATION) / FADE_DURATION
  lg.setColor(1, 1, 1, remaining)
  lg.rectangle("fill", self.x - PADDING, self.y, self.w + 2*PADDING, self.h, ROUNDING)
  lg.setColor(0, 0, 0, remaining)
  lg.print(self.text, self.x, self.y)
  lg.setColor(1, 1, 1)
end

return Button
