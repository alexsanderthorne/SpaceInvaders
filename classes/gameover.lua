local composer = require( "composer" )
local scene = composer.newScene()

local w = display.contentWidth
local h = display.contentHeight
 
function scene:create( event )
 
    local sceneGroup = self.view
    textoGameover = display.newText(sceneGroup,"Perdeu zé",0, 0, nil, 30)
    textoGameover.x = w *.5
    textoGameover.y = h *.6  
    textoGameover:setFillColor(1,0.6,0.6)
    sceneGroup:insert(textoGameover)
    self.textoGameover = textoGameover

end
 
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
    end
end
 
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
    end
end
 
function scene:destroy( event )
 
    local sceneGroup = self.view
 
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene