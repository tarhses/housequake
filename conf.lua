SCALE = 3

function love.conf(t)
  t.version = "11.3"
  t.window.title = "Housequake"
  t.window.icon = "icon.png"
  t.window.width = 135 * SCALE
  t.window.height = 240 * SCALE
  t.modules.joystick = false
end
