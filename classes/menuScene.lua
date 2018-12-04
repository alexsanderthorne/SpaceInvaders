local composer = require( "composer" )
local scene = composer.newScene()
--local widget = require("widget")
--local gameplay = require("gameplay")

local w = display.contentWidth -- representa a largura da tela
local h = display.contentHeight -- altura da tela
local button

function iniciarGame()
    composer.gotoScene("classes.gameplay")
end
-- local function gotoScore(event)
--    if event.phase == "ended" then
--       composer.gotoScene("scenes.score")
--    end
-- end
-- local function exitGame(event)
--    if event.phase == "ended" then
--       os.exit()
--    end
-- end

function scene:create(event)
    local sceneGroup = self.view

	local background = display.newImage(sceneGroup ,"Images/etzin.jpg", w, h)-- ADCIONAR BACKGROUND ESTELAR!
	background.x = w * .5
	background.y = h * .5
	background:scale(1.3,1.2) --dimensões da imagem        
	sceneGroup:insert(background)
	self.background = background

	local title = display.newImageRect(sceneGroup, "Images/Space_Invaders.jpg", 310, 55)
	title.x = w * .5
	title.y = 30

	button = display.newImageRect(sceneGroup, "Images/button_play.png", 100, 35 )
	button.x = w *.5 
	button.y = h *.6 
	button.myName = "play"
	sceneGroup:insert(button)
	self.button = button

	local buttonText = display.newText(sceneGroup, "Play", 0, 0, nil, 30 )
	buttonText.x = button.x
	buttonText.y = button.y
	sceneGroup:insert(buttonText)
	self.buttonText = buttonText

	local button2 = display.newImageRect(sceneGroup, "Images/button_play.png", 100, 35 )
	button2.x = w *.5 
	button2.y = button.y + button.height*.5 + 40
	sceneGroup:insert(button2)
	self.button2 = button2

	local buttonText2 = display.newText(sceneGroup, "Score", 0, 0, nil, 30 )
	buttonText2.x = button2.x
	buttonText2.y = button2.y
	sceneGroup:insert(buttonText)
	self.button2 = button2

	button:addEventListener("tap", iniciarGame)
end

function scene:show(event)
	local phase = event.phase
	-- local cenaAnterior = composer.getSceneName( "previous" )
 --    if cenaAnterior~=nil then
 --        composer.removeScene(cenaAnterior)
 --    end
	--if  phase == "will"  then -- Código aqui é executado quando a cena ainda está fora da tela (mas está prestes a entrar)
   	 
	--local group = self.view
   	if (phase == "did") then -- O código aqui é executado quando a cena está totalmente na tela()
   		--button:addEventListener("tap",iniciarGame)-- colocar um efeito na transição de cena
 		
    end
end

function scene:hide(event) -- ocultar
	local phase = event.phase
    if  (phase == "will") then -- Código aqui é executado quando a cena está na tela (mas está prestes a sair da tela)
    --elseif ( phase == "did" ) then -- O código aqui é executado quando a cena está totalmente na tela
 
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene