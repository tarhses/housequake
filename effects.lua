local lg = love.graphics
local lm = love.math

local FADE_DURATION = 0.5
local SLOW_DOWN_DURATION = 0.1
local SLOW_DOWN_FACTOR = 0.1

local effects = {
  shakeTimer = 0,
  fadeInTimer = 0,
  slowDownTimer = 0,
}

function effects:shake(duration)
  self.shakeTimer = duration
end

function effects:fadeIn()
  self.fadeInTimer = FADE_DURATION
end

function effects:slowDown()
  self.slowDownTimer = SLOW_DOWN_DURATION
end

function effects:update(dt)
  self.shakeTimer = self.shakeTimer - dt
  self.fadeInTimer = self.fadeInTimer - dt
  self.slowDownTimer = self.slowDownTimer - dt
end

function effects:applyPre()
  lg.push()

  -- Shake screen
  if self.shakeTimer > 0 then
    local factor = 1 + self.shakeTimer
    lg.translate(lm.random(-factor, factor), lm.random(-factor, factor))
  end
end

function effects:applyPost()
  -- Fade in
  if self.fadeInTimer > 0 then
    lg.setColor(0, 0, 0, self.fadeInTimer / FADE_DURATION)
    lg.rectangle("fill", 0, 0, lg.getDimensions())
    lg.setColor(1, 1, 1)
  end

  lg.pop()
end

function effects:applyTime(dt)
  -- Slow down
  if self.slowDownTimer > 0 then
    return SLOW_DOWN_FACTOR * dt
  end

  return dt
end

return effects
