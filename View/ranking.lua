local composer = require ("composer")
local scene = composer.newScene( )
local score = require ("BD.score")

local w = display.contentWidth
local h = display.contentHeight

local function iniciarGame(event)
    composer.gotoScene("View.gamePlay")
end

local function menuGame(event)
    composer.gotoScene("View.menuScene")
end

local function exitGame(event)
       os.exit()
end 
 
function scene:create( event )
    
    local sceneGroup = self.view

    local etScore = display.newImageRect(sceneGroup, "View/Images/etScore.jpg", 124, 86 )
    etScore.x = w *.55
    etScore.y = h *.3
    sceneGroup:insert(etScore)

    local button = display.newImageRect(sceneGroup, "View/Images/button_play.png", 114, 35 )
    button.x = w *.5 
    button.y = h *.6 
    sceneGroup:insert(button)

    local buttonText = display.newText(sceneGroup, "newGame", 0, 0, nil, 20 )
    buttonText.x = button.x
    buttonText.y = button.y
    sceneGroup:insert(buttonText)

    local button2 = display.newImageRect(sceneGroup, "View/Images/button_play.png", 76, 35 )
    button2.x = w *.5 
    button2.y = h * .75
    sceneGroup:insert(button2)

    local buttonText2 = display.newText(sceneGroup, "Menu", 0, 0, nil, 20 )
    buttonText2.x = button2.x
    buttonText2.y = button2.y
    sceneGroup:insert(buttonText2)

    local button3 = display.newImageRect(sceneGroup, "View/Images/button_play.png", 50, 35 )
    button3.x = w *.5 
    button3.y = h * .9
    sceneGroup:insert(button3)

    local buttonText3 = display.newText(sceneGroup, "Exit", 0, 0, nil, 20 )
    buttonText3.x = button3.x
    buttonText3.y = button3.y
    sceneGroup:insert(buttonText3)

    button:addEventListener("touch", iniciarGame)
    button2:addEventListener("touch", menuGame)
    button3:addEventListener("touch",exitGame)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
    print(score:getPontuacao())
    local textoPontuacao = display.newText("Maior Pontuação : " .. score:getPontuacao(),0 , 0 , nil , 17 )
    textoPontuacao.x = w * .5
    textoPontuacao.y = h * .1
    textoPontuacao:setFillColor( 1, 0, 0 )
    sceneGroup:insert(textoPontuacao)
    composer.removeScene("View.menuScene" )-- nova scene prestes a entrar
    end
end
 
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    
    elseif ( phase == "did" ) then
    
    end
end
  
function scene:destroy( event )
    local sceneGroup = self.view
    display.remove(sceneGroup)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene