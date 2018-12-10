local composer = require ("composer")
local scene = composer.newScene( )
--local widget= require ("widget")
local score = require ("classes.score")

local w = display.contentWidth
local h = display.contentHeight

local function iniciarGame(event)
    --composer.removeScene("winner")
    composer.gotoScene("classes.gameplay")
end

local function menuGame(event)
   --composer.removeScene("winner")
    composer.gotoScene("classes.menuScene")
end

local function exitGame(event)
       os.exit()
end 
 
function scene:create( event )
    
    local sceneGroup = self.view
    
    print(score:getPontuacao())
    local textoPontuacao = display.newText( score:getPontuacao(),0 , 0 , nil , 50 )
    textoPontuacao.x = w * .5
    textoPontuacao.y = h * .4
    textoPontuacao:setFillColor( 1, 1, 1 )
    sceneGroup:insert(textoPontuacao)

    button = display.newImageRect(sceneGroup, "Images/button_play.png", 114, 35 )
    button.x = w *.5 
    button.y = h *.6 
    button.myName = "newGame"
    sceneGroup:insert(button)

    local buttonText = display.newText(sceneGroup, "newGame", 0, 0, nil, 20 )
    buttonText.x = button.x
    buttonText.y = button.y
    sceneGroup:insert(buttonText)

    local button2 = display.newImageRect(sceneGroup, "Images/button_play.png", 76, 35 )
    button2.x = w *.5 
    button2.y = h * .75
    sceneGroup:insert(button2)

    local buttonText2 = display.newText(sceneGroup, "Menu", 0, 0, nil, 20 )
    buttonText2.x = button2.x
    buttonText2.y = button2.y
    sceneGroup:insert(buttonText2)

    local button3 = display.newImageRect(sceneGroup, "Images/button_play.png", 50, 35 )
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
    composer.removeScene("classes.menuScene" )-- nova scene prestes a entrar
    -- composer.setVariable( "pontos", 0 )
    -- local pontosAtuais = composer.getVariable( "pontos" )
    end
end
 
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    composer.loadScene( "classes.menuScene" )
    --composer.removeScene( "classes.gameplay", true )
    elseif ( phase == "did" ) then
    -- local gameplay = composer.getScene("classes.gameplay")
    -- gameplay.getatualizar()
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