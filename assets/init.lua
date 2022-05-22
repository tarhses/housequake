local lf = love.filesystem
local lg = love.graphics
local la = love.audio

local function loadDirectory(dir, load)
  local assets = {}
  for _, item in ipairs(lf.getDirectoryItems(dir)) do
    assets[item] = load(dir .. item)
  end
  return assets
end

local function fromSVG(s)
  local result = {}

  local x, y = 0, 0
  local cmd = "M"
  local args = {}
  for token in s:gmatch("[MmLlHhVv%-%d%.]+") do
    if token:match("%a") ~= nil then -- letters
      cmd = token
    else -- numbers
      table.insert(args, tonumber(token))
      if #args == 1 then
        if cmd == "H" then
          x = table.remove(args)
        elseif cmd == "h" then
          x = x + table.remove(args)
        elseif cmd == "V" then
          y = table.remove(args)
        elseif cmd == "v" then
          y = y + table.remove(args)
        end
      elseif #args == 2 then
        if cmd == "M" or cmd == "L" then
          y = table.remove(args)
          x = table.remove(args)
        elseif cmd == "m" or cmd == "l" then
          y = y + table.remove(args)
          x = x + table.remove(args)
        end
      end

      if #args == 0 then
        table.insert(result, x)
        table.insert(result, y)
      end
    end
  end

  return result
end

-- Images
local images = loadDirectory("assets/images/", function(path)
  local image = lg.newImage(path)
  image:setFilter("nearest", "nearest")
  return image
end)

-- Fonts
local fonts = loadDirectory("assets/fonts/", function(path)
  local font = lg.newFont(path, 12, "none")
  font:setFilter("nearest", "nearest")
  return font
end)

-- Sounds
local sounds = loadDirectory("assets/sounds/", function(path)
  return la.newSource(path, "static")
end)

-- Quads
local quads = {
  wardrobe = lg.newQuad(0, 0, 11, 16, images["objects.png"]:getPixelDimensions()),
  television = lg.newQuad(15, 6, 16, 10, images["objects.png"]:getPixelDimensions()),
  book = lg.newQuad(33, 12, 2, 4, images["objects.png"]:getPixelDimensions()),
  lamp = lg.newQuad(37, 9, 5, 7, images["objects.png"]:getPixelDimensions()),
  coffeeTable = lg.newQuad(44, 12, 16, 4, images["objects.png"]:getPixelDimensions()),
  nightTable = lg.newQuad(62, 11, 7, 5, images["objects.png"]:getPixelDimensions()),
  box = lg.newQuad(71, 11, 6, 5, images["objects.png"]:getPixelDimensions()),
  sofa = lg.newQuad(79, 1, 10, 15, images["objects.png"]:getPixelDimensions()),
  plant = lg.newQuad(91, 9, 5, 7, images["objects.png"]:getPixelDimensions()),
  desktop = lg.newQuad(98, 11, 16, 5, images["objects.png"]:getPixelDimensions()),
  screenLeft = lg.newQuad(116, 8, 4, 8, images["objects.png"]:getPixelDimensions()),
  screenRight = lg.newQuad(122, 8, 4, 8, images["objects.png"]:getPixelDimensions()),
  bookcase = lg.newQuad(0, 25, 10, 23, images["objects.png"]:getPixelDimensions()),
  bottle = lg.newQuad(13, 26, 3, 6, images["objects.png"]:getPixelDimensions()),
  vase = lg.newQuad(24, 26, 5, 6, images["objects.png"]:getPixelDimensions()),
  bucket = lg.newQuad(12, 44, 5, 4, images["objects.png"]:getPixelDimensions()),
  broom = lg.newQuad(19, 31, 3, 17, images["objects.png"]:getPixelDimensions()),
  bed = {
    lg.newQuad(1, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
    lg.newQuad(19, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
    lg.newQuad(37, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
    lg.newQuad(55, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
    lg.newQuad(73, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
    lg.newQuad(91, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
    lg.newQuad(109, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
    lg.newQuad(127, 1, 16, 16, images["bed.png"]:getPixelDimensions()),
  },
  cat = {
    lg.newQuad(1, 1, 11, 5, images["cat.png"]:getPixelDimensions()),
    lg.newQuad(13, 1, 11, 5, images["cat.png"]:getPixelDimensions()),
    lg.newQuad(25, 1, 11, 5, images["cat.png"]:getPixelDimensions()),
    lg.newQuad(37, 1, 11, 5, images["cat.png"]:getPixelDimensions()),
  }
}

-- Animations
local animations = {
  bed = {
    image = images["bed.png"],
    quads = quads.bed,
    frameDuration = 0.2,
  },
  cat = {
    image = images["cat.png"],
    quads = quads.cat,
    frameDuration = 0.2,
  }
}

-- Objects
local objects = {
  wardrobe = {
    image = images["objects.png"],
    quad = quads.wardrobe,
    mass = 4,
    score = 700,
  },
  television = {
    image = images["objects.png"],
    quad = quads.television,
    mass = 4,
    score = 1000,
  },
  book = {
    image = images["objects.png"],
    quad = quads.book,
    mass = 1,
    score = 150,
  },
  lamp = {
    image = images["objects.png"],
    quad = quads.lamp,
    mass = 2,
    score = 200,
  },
  coffeeTable = {
    image = images["objects.png"],
    quad = quads.coffeeTable,
    mass = 2,
    score = 100,
  },
  nightTable = {
    image = images["objects.png"],
    quad = quads.nightTable,
    mass = 2,
    score = 100,
  },
  box = {
    image = images["objects.png"],
    quad = quads.box,
    mass = 5,
    score = 500,
  },
  sofa = {
    image = images["objects.png"],
    quad = quads.sofa,
    mass = 5,
    score = 1000,
  },
  plant = {
    image = images["objects.png"],
    quad = quads.plant,
    mass = 2,
    score = 400,
  },
  desktop = {
    image = images["objects.png"],
    quad = quads.desktop,
    mass = 4,
    score = 100,
  },
  screenLeft = {
    image = images["objects.png"],
    quad = quads.screenLeft,
    mass = 3,
    score = 800,
  },
  screenRight = {
    image = images["objects.png"],
    quad = quads.screenRight,
    mass = 3,
    score = 800,
  },
  bottle = {
    image = images["objects.png"],
    quad = quads.bottle,
    mass = 2,
    score = 300,
  },
  vase = {
    image = images["objects.png"],
    quad = quads.vase,
    mass = 3,
    score = 1000,
  },
  bucket = {
    image = images["objects.png"],
    quad = quads.bucket,
    mass = 2,
    score = 300,
  },
  broom = {
    image = images["objects.png"],
    quad = quads.broom,
    mass = 2,
    score = 400,
  },
}

-- Levels
local levels = {
  {
    background = images["house1.png"],
    grabCount = 5,
    goal = 3800,
    playground = { 24 + 88/2, 112 + 120/2, 88, 120 },
    walls = {
      fromSVG("m 25.094445,162.47566 -0.07789,-7.13698 42.931496,-42.88056 19.902711,20.00018"),
      fromSVG("m 25.016473,159.36952 65.242887,0.15395"),
      fromSVG("m 25.193106,183.41377 h 40.38153"),
      fromSVG("M 80.414442,183.43732 H 111.06631"),
      fromSVG("M 25.243161,207.57987 H 65.488414"),
      fromSVG("M 80.462613,207.58104 H 111.09007"),
      fromSVG("M -3.4916941,232.30122 H 138.76027"),
      fromSVG("m 39.499764,183.443 v 8.44528"),
      fromSVG("m 25.220455,228.41832 v 3.99815"),
      fromSVG("m 25.243161,211.57987 -0.05006,-32.1661"),
      fromSVG("m 99.592815,192.59165 h 8.935995"),
      fromSVG("m 99.592815,200.59165 h 8.935995"),
      fromSVG("m 101.25886,145.63012 9.86043,10.0614 v 60.24159"),
    },
    objects = {
      { objects.coffeeTable, 32,228 },
      { objects.television, 32,218 },
      { objects.sofa, 52,217 },
      { objects.nightTable, 89,202 },
      { objects.lamp, 90,196 },
      { objects.book, 100,188 },
      { objects.book, 103,188 },
      { objects.book, 106,188 },
      { objects.book, 100,196 },
      { objects.book, 103,196 },
      { objects.book, 106,196 },
      { objects.wardrobe, 52,167 },
      { objects.box, 35,149 },
      { objects.box, 33,154 },
      { objects.box, 39,154 },
      { objects.box, 51,154 },
    },
    doodads = {
      { "animation", animations.bed, 32,167 },
    }
  },
  {
    background = images["house3.png"],
    grabCount = 5,
    goal = 5000,
    playground = { 24 + 88/2, 111 + 122/2, 88, 122 },
    walls = {
      fromSVG("M -5.1025545,232.53826 H 141.33595"),
      fromSVG("m 110.99046,215.81878 v -36.5053"),
      fromSVG("M 111.06616,135.59953 V 111.64738 H 73.014818 v 8.25855"),
      fromSVG("m 26.010421,135.54564 v -6.85607"),
      fromSVG("M 24.996544,159.57972 H 49.498925"),
      fromSVG("M 111.11577,159.4877 H 64.440011"),
      fromSVG("M 24.967926,183.58093 H 49.481671"),
      fromSVG("M 110.99816,183.56635 H 64.555764"),
      fromSVG("M 110.98447,207.46486 H 54.539647"),
      fromSVG("M 25.034111,207.51799 H 39.686802"),
      fromSVG("m 111.07319,155.41936 v 7.15073"),
      fromSVG("m 24.961803,232.62169 v -97.0341 h 86.031167 v 3.87725"),
      fromSVG("m 24.976671,167.50955 h 6.623988"),
      fromSVG("m 24.909842,175.47908 h 6.689282"),
    },
    objects = {
      { objects.bottle, 88,129 },
      { objects.box, 98,125 },
      { objects.box, 94,130 },
      { objects.box, 101,130 },
      { objects.plant, 30,152 },
      { objects.lamp, 89,147 },
      { objects.nightTable, 88,154 },
      { objects.sofa, 96,144 },
      { objects.book, 27,163 },
      { objects.book, 30,163 },
      { objects.book, 27,171 },
      { objects.book, 30,171 },
      { objects.vase, 99,172 },
      { objects.nightTable, 98,178 },
      { objects.screenLeft, 83,194 },
      { objects.desktop, 78,202 },
      { objects.wardrobe, 97,191 },
      { objects.bottle, 30,221 },
      { objects.bottle, 34,221 },
      { objects.nightTable, 30,227 },
      { objects.desktop, 74,227 },
      { objects.plant, 95,225 },
    },
    doodads = {
      { "animation", animations.cat, 77,106 },
    },
  },
  {
    background = images["house2.png"],
    grabCount = 4,
    goal = 4500,
    playground = { 16 + 104/2, 111 + 122/2, 104, 122 },
    walls = {
      fromSVG("m -6.8571944,208.59273 102.6615194,0"),
      fromSVG("m 17.072,208.65358 v 23.92341 h 101.92371 l -0.0312,-101.03188"),
      fromSVG("M 16.742096,135.26319 H 95.279747"),
      fromSVG("M 16.866662,159.59028 H 95.545875"),
      fromSVG("m 55.482429,135.2665 0,32.50144"),
      fromSVG("m 88.544517,159.5644 v 8.19794"),
      fromSVG("m 88.509403,135.31067 v 8.49197"),
      fromSVG("m 16.954435,183.54295 102.047515,0"),
      fromSVG("m 39.533371,159.6632 v 23.90711"),
      fromSVG("m 39.461311,168.51795 h 4.696368"),
      fromSVG("m 88.508492,183.60732 v 8.16011"),
      fromSVG("m 88.497711,208.47001 v 7.28823"),
      fromSVG("m 16.958264,162.58363 v -7.20349"),
      fromSVG("m 118.90981,208.59273 22.81745,0"),
      fromSVG("m 16.954435,179.23279 0,12.31245"),
      fromSVG("m 17.010361,138.41345 v -3.76772 l 11.191894,-23.09796 60.867745,0 v 7.9827"),
     },
    objects = {
      { objects.box, 32,125 },
      { objects.box, 32,130 },
      { objects.box, 39,125 },
      { objects.box, 39,130 },
      { objects.television, 26,145 },
      { objects.coffeeTable, 26,155 },
      { objects.screenRight, 65,146 },
      { objects.desktop, 61,154 },
      { objects.plant, 81,152 },
      { objects.bucket, 29,179 },
      { objects.broom, 35,166 },
      { objects.book, 41,165 },
      { objects.plant, 81,176 },
      { objects.wardrobe, 31,216 },
    },
    doodads = {},
  },
}

return {
  images = images,
  fonts = fonts,
  sounds = sounds,
  quads = quads,
  animations = animations,
  objects = objects,
  levels = levels,
}
