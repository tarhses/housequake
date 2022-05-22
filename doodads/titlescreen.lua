local lg = love.graphics

local TitleScreen = {}
TitleScreen.__index = TitleScreen

local WAIT_DURATION = 3

function TitleScreen.new()
  local self = setmetatable({}, TitleScreen)
  self.timer = 0
  return self
end

function TitleScreen:update(dt)
  self.timer = self.timer + dt
end

function TitleScreen:draw()
  local remaining1 = self.timer - WAIT_DURATION
  lg.setColor(1, 1, 1, remaining1)
  lg.print("Steal as many", 15, 26)
  lg.print("items as you", 20, 38)
  lg.print("can in 5 moves.", 12, 50)
  lg.setColor(1, 1, 1)
end

return TitleScreen
