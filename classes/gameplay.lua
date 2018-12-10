local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.start(true)
physics.setGravity(0, 0)
--physics.setDrawMode("debug")

display.setStatusBar (display.HiddenStatusBar)
system.setIdleTimer(false) --impede a tela de apagar

local w = display.contentWidth
local h = display.contentHeight
local margemEsquerda = 20
local margemDireita = w - 20
local invasorMetade = 6
local buttons = {}
local aliens = {}
balasInvasores = {}
timerTiroAliens = 0
timermoverAliens = 0
velocidadeAlien = 0.8
mover_navex = 0
ajustary = h / 20--(y)
ajustarx = 49 --(x)
pontos = 0
vidas = 3
 
function menu()
    composer.gotoScene("classes.menuScene")
end

function winner()
	composer.gotoScene("classes.winner")
end

function GameOver()
   composer.gotoScene("classes.gameover")
end

function loop_game()
	--A ordem em que você adiciona coisas à cena é a ordem em que elas serão exibidas.
	atualizar_aliens()
	atualizar_nave()
	gotoWinner()
end

function atualizar()
   pontosDisplay.text = "pontos : " .. pontos
   vidasDisplay.text = "vidas : " .. vidas
end

podeAtirar = true
function onGlobalCollision(event)
	if event.phase == "began" then
		if
         (event.object1.myName == "inimigos" and event.object2.myName == "tiroNave") or
            (event.object1.myName == "tiroNave" and event.object2.myName == "inimigos")
       then
         pontos = pontos + 400

         for i = #aliens, 1, -1 do
	            if aliens[i] == event.object1 then-- se o invasor for atingido vaza
		               table.remove(aliens, i)
		               display.remove(event.object1)--tanto o alien pode atingir o tiro
		               display.remove(event.object2)--quanto o tiro pode atingir o alien
		               podeAtirar = true
	            elseif aliens[i] == event.object2 then
		               table.remove(aliens, i)
		               display.remove(event.object1)
		               display.remove(event.object2)
		               podeAtirar = true
	            end
         end
      elseif
         (event.object1.myName == "nave" and event.object2.myName == "tiroAlien") or
            (event.object1.myName == "tiroAlien" and event.object2.myName == "nave")
       then
        if vidas > 0 then

	         if event.object1.myName == "tiroAlien" then -- remover apenas o tiro
	            display.remove(event.object1)
	         elseif event.object2.myName == "tiroAlien" then
	         	display.remove(event.object2)
	         end 
         vidas = vidas - 1
     	-- else
     	-- 	display.remove(event.object1)
	     --    display.remove(event.object2)
     	end
      elseif
         (event.object1.myName == "inimigos" and event.object2.myName == "nave") or
            (event.object1.myName == "nave" and event.object2.myName == "inimigos")
       then

	       for i = #aliens, 1, -1 do
		       	if aliens[i] == event.object1 then
				       	table.remove(aliens, i)
				       	display.remove(event.object1)
				end
			     
		    end
		         vidas = vidas - 1
		
		end
	end
		atualizar()
	   if vidas <= 0 then
	      GameOver()
	   end
end

function gotoWinner()
	if pontos >= 2400 then
		winner()
	end
end

function tiro_nave(event)
	verificacaoGlobal()
	if event.phase == "began" then	
		if podeAtirar == true then
			local shot = display.newRect(player.x,player.y,4,6)
			shot:setFillColor(1,0.2,0)
			shot.myName = "tiroNave"
			physics.addBody(shot, "dinamic")
			transition.to(
	            shot,
	            {
	               y = -40,
	               time = 1800,
	               onComplete = function()
	                  podeAtirar = true
	                  display.remove(shot)
	               end
	            }
	         )
		end
	elseif event.phase == "ended" then
		podeAtirar = false
	end
end

function verificacaoGlobal()
	if shot then
		podeAtirar = false
	end
end

function mover_nave(event) --ctrl+d para mudar todas as váriáveis de uma só vez
	if event.phase == "began" or event.phase == "moved" then
		
		if event.target.myName == "direita" then
			mover_navex = 5
		elseif event.target.myName == "esquerda" then
			mover_navex = -5
		elseif event.target.myName == "atacar" then
			print("pei")
		end
	else 
		mover_navex = 0
	end
end

function atualizar_nave()
	if player.x ~= nil  then
		player.x = player.x + mover_navex
	if player.x <= player.width * 0.5 then
		player.x = player.width * 0.5
	elseif player.x >= w - player.width * 0.5 then 
		player.x = w - player.width * 0.5
	end
	end
end

function criar_aliens(event)
	local group = display.newGroup()
		for i=1,24 do

		aliens[i] = display.newImageRect("Images/Enemy.png",27,27)
		aliens[i].x = ajustarx
		aliens[i].y = ajustary 
		aliens[i].i = i
		physics.addBody( aliens[i], "dynamic" )
		group:insert(aliens[i])
		aliens[i].myName = "inimigos"
		ajustary = ajustary + 30

			if i % 4 == 0 then
					
			ajustarx = ajustarx + 36
			ajustary = h / 20
			end
		end
	return group
end

function tiro_aliens(event)
		if #aliens > 0  then
	        local indiceAleatorio = math.random(#aliens)
	        local invasorAleatorio = aliens[indiceAleatorio]

	        if invasorAleatorio.x ~= nil and invasorAleatorio.y ~= nil then
	        local TiroAlien = display.newRect(aliens[indiceAleatorio].x,aliens[indiceAleatorio].y,4,6)
	        TiroAlien:setFillColor(1,0.2,0)
	        TiroAlien.myName = "tiroAlien"
	        TiroAlien.x = invasorAleatorio.x
	        TiroAlien.y = invasorAleatorio.y + 20 / 2
	        physics.addBody(TiroAlien, "dynamic" )
	        TiroAlien.gravityScale = 0
	        TiroAlien.isSensor = true
	        TiroAlien:setLinearVelocity( 0,100)
	        table.insert(balasInvasores, TiroAlien) 
	    	end
	    end
end

function remove_tiro()
	for i=1,#balasInvasores do
		display.remove(balasInvasores[i])
	end
end

function mover_aliens()
	local mudaDirecao = false
    for i=1, #aliens do
    	if aliens[i].x ~= nil  then
          aliens[i].x = aliens[i].x + velocidadeAlien
        if aliens[i].x > margemDireita - invasorMetade or aliens[i].x < margemEsquerda + invasorMetade then
            mudaDirecao = true;
        end
    	end
     end
    if mudaDirecao == true then
        velocidadeAlien = velocidadeAlien*-1--mover ao contrário
        for j = 1, #aliens do
            aliens[j].y = aliens[j].y + 36
        end
        mudaDirecao = false;
    end 
end

function atualizar_aliens()
	for i=1,#aliens do
		if aliens[i].width ~= nil  then
		if aliens[i].x <= aliens[i].width * 0.5 then 
			aliens[i].x = aliens[i].width * 0.5
		elseif aliens[i].x >= w - aliens[i].width * 0.5 then 
			aliens[i].x = w - aliens[i].width * 0.5
		end
		end
	end
end

function scene:create(event)
	local sceneGroup = self.view

		physics.pause()

		pontosDisplay = display.newText(sceneGroup, "pontos : " .. pontos, w / 2, 0)
		pontosDisplay:setFillColor(1,0,0)
	   	vidasDisplay = display.newText(sceneGroup, "vidas : " .. vidas, 248,0)
	   	vidasDisplay:setFillColor(0,1,0)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	 if  phase == "will"  then
	  
    	pontos = 0
    	
   		sceneGroup:insert(criar_aliens())

   		player = display.newImageRect("Images/ship_b.png",50,50)
		player.myName = "nave"
		player.x = w / 2
		player.y = h / 2 + 180
		--player:scale(0.2,0.1)
		physics.addBody(player,"dinamic")
		sceneGroup:insert(player)

      	elseif phase == "did" then
      	physics.start()
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
		sceneGroup:insert(buttons[1])
		sceneGroup:insert(buttons[2])
		sceneGroup:insert(buttons[3])

		local j=1  
		for j=1, 2 do 
			buttons[j]:addEventListener("touch", mover_nave)
		end
		buttons[3]:addEventListener("touch",tiro_nave)
		
 		Runtime:addEventListener("enterFrame",loop_game)--singleton
 		Runtime:addEventListener("collision", onGlobalCollision)
		timerTiroAliens = timer.performWithDelay( 500, tiro_aliens, -1)
		timermoverAliens = timer.performWithDelay(velocidadeAlien,mover_aliens,-1)
    	end
end

function scene:hide(event)--quando você remove um objeto do Display, ele deve ser definido como nil.
	local phase = event.phase
	local sceneGroup = self.view

	if  phase == "will"  then 
   		remove_tiro()
		--pontos = -100
     elseif ( phase == "did" ) then
   		Runtime:removeEventListener("enterFrame",loop_game)--Sempre que você adicionar um ouvinte de evento, verifique se também o está removendo em algum momento mais adiante no programa.
   		Runtime:removeEventListener("collision", onGlobalCollision)
   		Runtime:removeEventListener("enterFrame",tiro_nave)
   		--display.remove(shot)
    end
end

function scene:destroy( event )
	print("destruindo a cena")
	local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene