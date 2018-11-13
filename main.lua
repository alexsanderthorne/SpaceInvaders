display.setStatusBar(display.HiddenStatusBar)-- Esconde barra de status**

math.randomseed( os.time() )

local composer = require("composer")

--local composer = require("menuScene")

--local composer = require("gameplay")

composer.gotoScene("menuScene" ,{effect ="fade" , time=500})