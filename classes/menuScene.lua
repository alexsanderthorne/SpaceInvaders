local composer = require( "composer" )
local scene = composer.newScene()

local w = display.contentWidth -- representa a largura da tela
local h = display.contentHeight -- altura da tela

local function iniciarGame(event)
    composer.gotoScene("classes.gameplay")
end

local function exitGame(event)
       os.exit()
end

function scene:create(event)
    local sceneGroup = self.view

	local background = display.newImage(sceneGroup ,"Images/etzin.jpg", w, h)
	background.x = w * .5
	background.y = h * .6
	background:scale(1.3,1.5) --dimensões da imagem        
	sceneGroup:insert(background)

	local title = display.newImageRect(sceneGroup, "Images/Space_Invaders.jpg", 310, 55)
	title.x = w * .5
	title.y = 30

	local button = display.newImageRect(sceneGroup, "Images/button_play.png", 100, 35 )
	button.x = w *.5 
	button.y = h *.7 
	button.myName = "play"
	sceneGroup:insert(button)

	local buttonText = display.newText(sceneGroup, "Play", 0, 0, nil, 30 )
	buttonText.x = button.x
	buttonText.y = button.y
	sceneGroup:insert(buttonText)

	local button2 = display.newImageRect(sceneGroup, "Images/button_play.png", 100, 35 )
	button2.x = w *.5 
	button2.y = h * .8
	sceneGroup:insert(button2)

	local buttonText2 = display.newText(sceneGroup, "Score", 0, 0, nil, 30 )
	buttonText2.x = button2.x
	buttonText2.y = button2.y
	sceneGroup:insert(buttonText2)

	local button3 = display.newImageRect(sceneGroup, "Images/button_play.png", 100, 35 )
	button3.x = w *.5 
	button3.y = h * .9
	sceneGroup:insert(button3)

	local buttonText3 = display.newText(sceneGroup, "Exit", 0, 0, nil, 30 )
	buttonText3.x = button3.x
	buttonText3.y = button3.y
	sceneGroup:insert(buttonText3)

	button:addEventListener("touch", iniciarGame)
	button3:addEventListener("touch", exitGame)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	
	if  phase == "will"  then -- Código aqui é executado quando a cena ainda está fora da tela (mas está prestes a entrar)
   	 
   	elseif (phase == "did") then -- O código aqui é executado quando a cena está totalmente na tela()
   		--button:addEventListener("tap",iniciarGame)-- colocar um efeito na transição de cena
 		
    end
end

function scene:hide(event) -- ocultar
	local sceneGroup = self.view
	local phase = event.phase

    if  (phase == "will") then -- Código aqui é executado quando a cena está na tela (mas está prestes a sair da tela)
    
    elseif ( phase == "did" ) then -- O código aqui é executado quando a cena está totalmente na tela
    
    end
end

function scene:destroy(event)
	local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy",scene)

return scene