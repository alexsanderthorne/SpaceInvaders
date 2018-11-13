local composer = require( "composer" ) --bibilioteca de criação e gerenciamento de telas
local scene = composer.newScene()
--composer.gotoScene("menuScene")--ir para outra tela

display.setStatusBar (display.HiddenStatusBar)
system.setIdleTimer(false) --impede a tela de apagar

local w = display.contentWidth
local h = display.contentHeight

local aliens = {}
ajustary = h / 20--(y)
ajustarx = 49 --(x)
 
function menu()

    composer.gotoScene("menuScene")
end

function scene:create( event )

	criar_aliens()--A ordem em que você adiciona coisas à cena é a ordem em que elas serão exibidas.
	mover_aliens()
	atualizar_aliens()
	mover_nave()
	touchNave()

end

function scene:show( event )

	local phase = event.phase
	local cenaAnterior = composer.getSceneName( "previous" )-- oque é Sceneprevious
    composer.removeScene(cenaAnterior)
	-- if  phase == "will"  then 
   	
 --   	else
	local group = self.view
 if ( phase == "did" ) then
 	Runtime:addEventListener("enterFrame",criar_aliens)
	Runtime:addEventListener("enterFrame",mover_aliens)
	Runtime:addEventListener("enterFrame", atualizar_aliens)
	Runtime:addEventListener("enterFrame",mover_nave)
	Runtime:addEventListener("enterFrame", atualizar_nave)--singleton

    end

end

function scene:hide( event )--quando você remove um objeto do Display, ele deve ser definido como nil.
	
	local group = self.view
	local phase = event.phase
	if  phase == "will"  then 
   		Runtime:addEventListener("enterFrame",criar_aliens)--Sempre que você adicionar um ouvinte de evento, verifique se também o está removendo em algum momento mais adiante no programa.
		Runtime:addEventListener("enterFrame",mover_aliens)
		Runtime:addEventListener("enterFrame", atualizar_aliens)
   		Runtime:addEventListener("enterFrame", atualizar_nave)--singleton
   		
   	end
   	-- elseif ( phase == "did" ) then
   	 		
    -- end
	timer.performWithDelay(300,mover_aliens,0)
end

function criar_aliens()
	
	for i=1,35 do

		aliens[i] = display.newRect(0,0,21,21)
		aliens[i].x = ajustarx
		aliens[i].y = ajustary 
		aliens[i].i = i

		ajustary = ajustary + 30

			if i % 5 == 0 then
					
			ajustarx = ajustarx + 36
			ajustary = h / 20
			end

			--physics.addBody( aliens[i], "dynamic" )

--aliens[i]:applyForce(20,10,aliens[i].x,aliens[i].y)
	end

end
--alien:scale(0.2,0.2) dimensões da imagem

--return aliens

function mover_aliens()

	local mover_alien_esquerda = 10 -- Definir a iterations propriedade como -1 faz com que a ação se repita para sempre.
	local mover_alien_esquerda_reverter = -10
	local mudaDirecao = false
	
	for i=1,#aliens do
		aliens[i].x = aliens[i].x - mover_alien_esquerda
		if atualizar_aliens() then
	 		mudaDirecao = true
	 	end
	end

	if mudaDirecao == true then
		mover_alien_esquerda = mover_alien_esquerda_reverter
		for j = 1, #aliens do
			aliens[j].y = aliens[j].y + 100
		end
		mudaDirecao = false
	end
	
end



function atualizar_aliens()

	for i=1,#aliens do

		if aliens[i].x <= aliens[i].width * 0.5 then 
			aliens[i].x = aliens[i].width * 0.5 --permite que o alien vá até as bordas ta tela do simulador(x)
		elseif aliens[i].x >= w - aliens[i].width * 0.5 then 
			aliens[i].x = w - aliens[i].width * 0.5
		end
	end
end

-- function verificar_borda()
-- end

-- verificar_borda()

local player = display.newRect(0, 0, 23, 23)
player:setFillColor(0,1,0)
player.x = w * 0.5
player.y = h * 0.85

local buttons = {}

buttons[1] = display.newImage("Images/button.png")
buttons[1].x = 30
buttons[1].y = 470
buttons[1].myName = "esquerda"
buttons[1].rotation = 180

buttons[2] = display.newImage("Images/button.png")
buttons[2].x = 90
buttons[2].y = 470
buttons[2].myName = "direita"

buttons[3] = display.newImage("Images/button.png")
buttons[3]:setFillColor(1,0,0)
buttons[3].x = 260
buttons[3].y = 470
buttons[3].myName = "atacar"
buttons[3].rotation = -90


local mover_navey = 0
local mover_navex = 0

function touchNave(event) 
	
	eventName = event.phase
	--local direction = event.target.myName
	--local phase = event.phase
	if eventName == "began" or eventName == "moved" then
		
		if event.target.myName == "direita" then
			mover_navex = 5
			mover_navey = 0
		elseif event.target.myName == "esquerda" then
			mover_navex = -5
			mover_navey = 0
		elseif event.target.myName == "atacar" then
			print("pei")
		end
	else 
		mover_navey = 0
		mover_navex = 0
	end
end


function mover_nave(  )

local j=1
for j=1, #buttons do 
	buttons[j]:addEventListener("touch", touchNave) --evento de toque nos buttons
end
	
end

function atualizar_nave()

	player.x = player.x + mover_navex
	player.y = player.y + mover_navey

	if player.x <= player.width * 0.5 then --será que funciona com os aliens tbm?
		player.x = player.width * 0.5 --permite que a nave vá até as bordas ta tela do simulador(x)
	elseif player.x >= w - player.width * 0.5 then 
		player.x = w - player.width * 0.5
	end

	-- if player.y <= player.height * 0.5 then--permite que a nave vá até as bordas ta tela do simulador(y)
	-- 	player.y = player.height * 0.5
	-- elseif player.y >= h - player.height * 0.5 then 
	-- 	player.y = h - player.height * 0.5
	-- end 

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene