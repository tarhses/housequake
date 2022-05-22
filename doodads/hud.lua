local lg = love.graphics

local HUD = {}
HUD.__index = HUD

function HUD.new(game)
  local self = setmetatable({}, HUD)
  self.game = game
  return self
end

function HUD:draw()
  lg.print(self.game.score, 16, 16)
  lg.print(self.game.grabCount, 16, 32)
end

return HUD
