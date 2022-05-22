local lg = love.graphics
local lp = love.physics
local effects = require "effects"
local Animation = require "doodads.animation"
local Message = require "doodads.message"
local TitleScreen = require "doodads.titlescreen"
local Demo = require "doodads.demo"
local Button = require "doodads.button"
local HUD = require "doodads.hud"
local assets = require "assets"

local game = {
  level = nil,
  levelNumber = 0,

  ---@type love.World
  world = nil,
  objects = nil,
  doodads = nil,

  score = 0,
  ---@type {x1:number,y1:number,x2:number,y2:number}
  grab = nil,
  grabCount = 0,
  won = false,

  effects = effects,
}

function game:loadLevel(levelNumber)
  self.levelNumber = levelNumber or self.levelNumber
  self.level = assets.levels[math.max(1, self.levelNumber)]
  self.grabCount = self.levelNumber == 0 and 1 or self.level.grabCount

  self.score = 0
  self.won = false

  if self.world ~= nil then
    self.world:destroy()
    self.world:release()
  end

  -- Walls
  self.world = lp.newWorld(0, 9.81 * lp.getMeter())
  for _, wall in ipairs(self.level.walls) do
    local body = lp.newBody(self.world, 0, 0, "static")
    local shape = lp.newChainShape(false, wall)
    local fixture = lp.newFixture(body, shape)
    fixture:setUserData("wall")
  end

  -- Playground
  local x, y, w, h = unpack(self.level.playground)
  local body = lp.newBody(self.world, 0, 0, "static")
  local shape = lp.newRectangleShape(x, y, w, h)
  local fixture = lp.newFixture(body, shape)
  fixture:setSensor(true)
  fixture:setUserData("playground")

  -- Objects
  self.objects = {}
  for _, o in ipairs(self.level.objects) do
    local object, x, y = unpack(o)
    local _, _, w, h = object.quad:getViewport()

    local body = lp.newBody(self.world, x + w/2, y + h/2, "dynamic")
    local shape = lp.newRectangleShape(w, h)
    local fixture = lp.newFixture(body, shape)
    body:setMass(object.mass)
    fixture:setUserData(object.score)

    table.insert(self.objects, setmetatable({
      body = body,
      shape = shape,
      fixture = fixture,
    }, { __index = object }))
  end

  -- Doodads
  self.doodads = {}
  if self.levelNumber == 0 then
    table.insert(self.doodads, TitleScreen.new())
    table.insert(self.doodads, Demo.new(self))
  else
    table.insert(self.doodads, HUD.new(self))
    table.insert(self.doodads, Message.new("Score " .. self.level.goal, 135 / 2, 80, 4))
    table.insert(self.doodads, Message.new("points to win!", 135 / 2, 92, 4))
  end
  for _, d in ipairs(self.level.doodads) do
    if d[1] == "animation" then
      local _, anim, x, y = unpack(d)
      table.insert(self.doodads, Animation.new(anim, x, y))
    else
      error("unknown doodad type: " .. d[1])
    end
  end

  -- Collisions
  self.world:setCallbacks(function(a, b)
    if a:getUserData() == "wall" or b:getUserData() == "wall" then
      local name = "crash" .. love.math.random(1, 3) .. ".ogg"
      assets.sounds[name]:play()
    end
  end, function(playground, object)
    local type_ = playground:getUserData()
    local score = object:getUserData()
    if score == "playground" then
      playground, object = object, playground
      type_, score = score, type_
    end

    if type_ == "playground" and type(score) == "number" then
      local x, y = object:getBody():getWorldCenter()
      object:setUserData(nil)
      self.score = self.score + score
      self:win()
      table.insert(self.doodads, Message.new(score, x, y, 0.8))
      self.effects:slowDown()
      assets.sounds["score.ogg"]:play()
    end
  end)

  self.effects:fadeIn()
end

function game:draw()
  self.effects:applyPre()

  -- Background
  lg.draw(self.level.background)

  -- Doodads
  for _, doodad in ipairs(self.doodads) do
    doodad:draw()
  end

  -- Objects
  for _, obj in ipairs(self.objects) do
    local x, y = obj.body:getPosition()
    local _, _, w, h = obj.quad:getViewport()
    local r = obj.body:getAngle()
    lg.draw(obj.image, obj.quad, x, y, r, 1, 1, w / 2, h / 2)
  end

  -- Grab
  if self.grab ~= nil then
    lg.line(self.grab.x1, self.grab.y1, self.grab.x2, self.grab.y2)
  end

  self.effects:applyPost()
end

function game:update(dt)
  self.effects:update(dt)
  dt = self.effects:applyTime(dt)

  self.world:update(dt)

  -- Doodads
  local i = 1
  while i <= #self.doodads do
    local doodad = self.doodads[i]
    if doodad.update ~= nil then
      doodad:update(dt)
    end
    if doodad.isActive ~= nil and not doodad:isActive() then
      local last = table.remove(self.doodads)
      if doodad ~= last then
        self.doodads[i] = last
      end
    else
      i = i + 1
    end
  end
end

function game:win()
  if self.won then return end
  if self.grabCount > 0 then return end
  if self.score < self.level.goal then return end

  self.won = true
  table.insert(self.doodads, Button.new(50, 92, "Next", function()
    self:loadLevel(self.levelNumber % #assets.levels + 1)
  end))
end

function game:isGrabbing()
  return self.grab ~= nil
end

function game:beginGrab(x, y)
  if self.grabCount <= 0 then return end
  self.grab = { x1 = x, y1 = y, x2 = x, y2 = y }
end

function game:updateGrab(x, y)
  if self.grab == nil then return end
  self.grab.x2 = x
  self.grab.y2 = y
end

function game:endGrab(x, y)
  if self.grab == nil then return end
  local dx = x - self.grab.x1
  local dy = y - self.grab.y1
  local distance = math.hypothenuse(dx, dy)
  if distance > 4 then
    self:applyLinearImpulse(dx * 4, dy * 4)
    self.effects:shake(distance / 100)
    self.grabCount = self.grabCount - 1
    if self.grabCount <= 0 then
      if self.levelNumber == 0 then
        table.insert(self.doodads, Button.new(47, 78, "Start", function() self:loadLevel(1) end))
      else
        table.insert(self.doodads, Button.new(45, 74, "Retry", function() self:loadLevel() end))
        self:win()
      end
    end
  end
  self.grab = nil
end

function game:applyLinearImpulse(x, y)
  for _, obj in ipairs(self.objects) do
    obj.body:applyLinearImpulse(x, y)
  end
end

return game
