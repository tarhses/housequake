local lg = love.graphics
local assets = require "assets"

local Demo = {}
Demo.__index = Demo

local IMAGE = assets.images["cursor.png"]
local DURATION = 1.4

function Demo.new(game)
  local self = setmetatable({}, Demo)
  self.game = game
  self.timer = 0
  self.x = 0
  self.y = 0
  return self
end

function Demo:isActive()
  return self.timer < DURATION
end

function Demo:update(dt)
  self.timer = self.timer + dt

  local remaining = self.timer / DURATION
  self.x = 40 + remaining*remaining * 50
  self.y = 80 - remaining*remaining * 24

  if not self.game:isGrabbing() then
    self.game:beginGrab(self.x, self.y)
  end

  self.game:updateGrab(self.x, self.y)

  if not self:isActive() then
    self.game:endGrab(self.x, self.y)
  end
end

function Demo:draw()
  lg.draw(IMAGE, self.x, self.y)
end

return Demo
