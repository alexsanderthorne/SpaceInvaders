local composer = require( "composer" )
local scene = composer.newScene()

local w = display.contentWidth
local h = display.contentHeight

local function iniciarGame(event)
    composer.removeScene("gameover")
    composer.gotoScene("classes.gameplay")
end

local function menuGame(event)
   composer.removeScene("gameover")
    composer.gotoScene("classes.menuScene")
end
 
function scene:create(event)
    local sceneGroup = self.view

    local gameover = display.newImage(sceneGroup ,"Images/game-over.jpg", w, h)
    gameover.x = w * .5
    gameover.y = h * .2
    gameover:scale(0.3,0.2) --dimensões da imagem        
    sceneGroup:insert(gameover)

    button = display.newImageRect(sceneGroup, "Images/button_play.png", 143, 35 )
    button.x = w *.5 
    button.y = h *.6 
    button.myName = "newGame"
    sceneGroup:insert(button)

    local buttonText = display.newText(sceneGroup, "newGame", 0, 0, nil, 30 )
    buttonText.x = button.x
    buttonText.y = button.y
    sceneGroup:insert(buttonText)

    local button2 = display.newImageRect(sceneGroup, "Images/button_play.png", 100, 35 )
    button2.x = w *.5 
    button2.y = button.y + button.height*.5 + 40
    sceneGroup:insert(button2)

    local buttonText2 = display.newText(sceneGroup, "Menu", 0, 0, nil, 30 )
    buttonText2.x = button2.x
    buttonText2.y = button2.y
    sceneGroup:insert(buttonText2)

    button:addEventListener("touch", iniciarGame)
    button2:addEventListener("touch", menuGame)
end
 
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    composer.removeScene("classes.gameplay" )
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
    end
end
 
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
    end
end
 
function scene:destroy(event)
    local sceneGroup = self.view
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene