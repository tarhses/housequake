-- Globals
-- TODO: put this somewhere else
function math.distance(x1, y1, x2, y2)
  return math.hypothenuse(x2 - x1, y2 - y1)
end

function math.hypothenuse(w, h)
  return math.sqrt(w*w + h*h)
end
--

local lg = love.graphics
local lp = love.physics
local game = require "game"
local assets = require "assets"

function love.load()
  lg.setFont(assets.fonts["Retro Gaming.ttf"])
  lp.setMeter(12)
  game:loadLevel()
end

function love.draw()
  lg.scale(SCALE)
  game:draw()

  --[[ Debug
  lg.setLineWidth(1 / SCALE)
  for _, body in ipairs(game.world:getBodies()) do
    for _, fixture in ipairs(body:getFixtures()) do
      local shape = fixture:getShape()
      local type_ = shape:getType()
      if type_ == "polygon" then
        lg.polygon("line", body:getWorldPoints(shape:getPoints()))
      elseif type_ == "chain" then
        lg.line(body:getWorldPoints(shape:getPoints()))
      end
    end
  end
  --]]
end

function love.update(dt)
  game:update(dt)
end

function love.mousepressed(x, y, button)
  x = x / SCALE
  y = y / SCALE
  if button == 1 then
    game:beginGrab(x, y)
  end
end

function love.mousemoved(x, y)
  x = x / SCALE
  y = y / SCALE
  game:updateGrab(x, y)
end

function love.mousereleased(x, y, button)
  x = x / SCALE
  y = y / SCALE
  if button == 1 then
    game:endGrab(x, y)
  end
end
