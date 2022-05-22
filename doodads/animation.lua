local lg = love.graphics

local Animation = {}
Animation.__index = Animation

function Animation.new(anim, x, y)
  local self = setmetatable({}, Animation)
  self.anim = anim
  self.x = x
  self.y = y
  self.frame = 1
  self.timer = 0
  return self
end

function Animation:getQuad()
  return self.anim.quads[self.frame]
end

function Animation:getWidth()
  return self:getQuad():getWidth()
end

function Animation:getHeight()
  return self:getQuad():getHeight()
end

function Animation:getDimensions()
  return self:getQuad():getDimensions()
end

function Animation:draw()
  lg.draw(self.anim.image, self:getQuad(), self.x, self.y)
end

function Animation:update(dt)
  self.timer = self.timer + dt
  if self.timer >= self.anim.frameDuration then
    self.timer = self.timer - self.anim.frameDuration
    self.frame = self.frame + 1
    if self.frame > #self.anim.quads then
      self.frame = 1
    end
  end
end

return Animation
