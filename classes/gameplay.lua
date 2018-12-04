local composer = require("composer")
local scene = composer.newScene()
--local bomb = require("classes.bullet")
local physics = require("physics")
physics.start()
physics.setDrawMode("hibrid")
physics.setGravity(0, 0)

display.setStatusBar (display.HiddenStatusBar)
system.setIdleTimer(false) --impede a tela de apagar

local w = display.contentWidth
local h = display.contentHeight
local margemEsquerda = 20
local margemDireita = w - 20
local invasorMetade = 6
local velocidadeAlien = 0.2
local buttons = {}
local aliens = {}
local balasInvasores = {}
local timerTiroAliens
local mover_navey = 0
local mover_navex = 0
ajustary = h / 20--(y)
ajustarx = 49 --(x)
pontos = 0
vidas = 3
 
function menu()
    composer.gotoScene("menuScene")
end

function loop_game()
	--A ordem em que você adiciona coisas à cena é a ordem em que elas serão exibidas.
	mover_aliens()
	atualizar_aliens()
	atualizar_nave()
end

local function loop(event)
   for i = #aliens, 1, -1 do
      if aliens[i] ~= nil then
         if aliens[i].x < -50 then
            --aliens[i].destroy()
            table.remove(aliens, i)
         end
      end
   end
end

local function atualizar()
   pontosDisplay.text = "pontos : " .. pontos
   vidasDisplay.text = "vidas : " .. vidas
end

local function GameOver()
   composer.gotoScene("classes.gameover")
end

podeAtirar = true
function onGlobalCollision(event)
	if event.phase == "began" then
		if
         (event.object1.myName == "inimigos" and event.object2.myName == "tiroNave") or --botar colisão apenas no tiro da nave e dos aliens
            (event.object1.myName == "tiroNave" and event.object2.myName == "inimigos")
       then
         pontos = pontos + 100

         for i = #aliens, 1, -1 do
            if aliens[i] == event.object1 then-- se o invasor for atingido vaza
               table.remove(aliens, i)
               display.remove(event.object1)--remover tanto o alien
               display.remove(event.object2)--quanto o tiro
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
         if event.object1.myName == "nave" then -- se a nave for atingida vaza
            display.remove(event.object2)
         else
            display.remove(event.object1)
         end
         vidas = vidas - 1
      elseif
         (event.object1.myName == "inimigos" and event.object2.myName == "nave") or
            (event.object1.myName == "nave" and event.object2.myName == "inimigos")
       then
       for i = #aliens, 1, -1 do
	       	if aliens[i] == event.object1 then
		       	table.remove(aliens, i)
		       	display.remove(event.object1)--remover o alien quando bater na nave,caso a nave seja atingida por 3 aliens vaza
		     end
	      end
		         vidas = vidas - 1 -- reduz as vidas
		   elseif event.phase == "ended" then
		   end
		
		atualizar()
	   if vidas == 0 then
	      GameOver()
	   end
	end
end

local function destruirTudo()
   for i = #aliens, 1, -1 do
      --aliens[i].destroy()
      display.remove(aliens[i])
      table.remove(aliens, i)
   end
   display.remove(nave)
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
	               y = -50,
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

function atualizar_nave()
	player.x = player.x + mover_navex
	player.y = player.y + mover_navey

	if player.x <= player.width * 0.5 then
		player.x = player.width * 0.5
	elseif player.x >= w - player.width * 0.5 then 
		player.x = w - player.width * 0.5
	end
end

function tiro_aliens(event)
	for i=1,35 do
		if #aliens > 0  then
	        local randomIndice = math.random(#aliens)
	        local randomInvasor = aliens[randomIndice]

	        if randomInvasor.x ~= nil and randomInvasor.y ~= nil then
	        local tlaserl = display.newImageRect(aliens[i].x,aliens[i].y,4,6)
	       -- tlaserl:setFillColor(1,0.2,0)
	        --tlaserl.name = "tiroAlien"
	        tlaserl.x = randomInvasor.x
	        tlaserl.y = randomInvasor.y + 20 / 2
	        physics.addBody(tlaserl, "dynamic" )
	        tlaserl.gravityScale = 0
	        tlaserl.isSensor = true
	        tlaserl:setLinearVelocity( 0,150)
	        table.insert(balasInvasores, tlaserl) 
	    	end
	    end
	end
	    tlaserl:addEventListener("collision",destruirNave)  
end

function destruirNave( event )
	if(event.other.name == "player") then
		display.remove(event.other)
		display.remove(event.target)
		GameOver()
	end
end

function mover_aliens()
	local mudaDirecao = false
    for i=1, #aliens do
          aliens[i].x = aliens[i].x + velocidadeAlien
        if aliens[i].x > margemDireita - invasorMetade or aliens[i].x < margemEsquerda + invasorMetade then
            mudaDirecao = true;
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
	--timer.performWithDelay(50000,mover_aliens,1)

function atualizar_aliens()
	for i=1,#aliens do

		if aliens[i].x <= aliens[i].width * 0.5 then 
			aliens[i].x = aliens[i].width * 0.5
		elseif aliens[i].x >= w - aliens[i].width * 0.5 then 
			aliens[i].x = w - aliens[i].width * 0.5
		end
	end
end

function scene:create(event)
	local group = self.view
	
	physics.start()

	for i=1,35 do

		aliens[i] = display.newImageRect("Images/Enemy.png",27,27)
		aliens[i].x = ajustarx
		aliens[i].y = ajustary 
		aliens[i].i = i
		physics.addBody( aliens[i], "dynamic" )
		group:insert(aliens[i])
		aliens[i].myName = "inimigos"
		--self.aliens[i] = aliens[i]

		ajustary = ajustary + 30

			if i % 5 == 0 then
					
			ajustarx = ajustarx + 36
			ajustary = h / 20
			end
	end
	pontosDisplay = display.newText(group, "pontos : " .. pontos, w / 2, 0)
	pontosDisplay:setFillColor(1,0,0)
   	vidasDisplay = display.newText(group, "vidas : " .. vidas, 248,0)
   	vidasDisplay:setFillColor(0,1,0)
end

function scene:show(event)
	local group = self.view
	local phase = event.phase
	-- local cenaAnterior = composer.getSceneName( "previous" )
 --    composer.removeScene(cenaAnterior)
	 if  phase == "will"  then 
   		player = display.newImageRect("Images/nave2.png",50,50)
		player.myName = "nave"
		player.x = w / 2
		player.y = h / 2 + 180
		--player:scale(0.2,0.1)
		physics.addBody(player,"dinamic")
		group:insert(player)
	--self.player = player

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
		group:insert(buttons[1])
		group:insert(buttons[2])
		group:insert(buttons[3])
		

		local j=1  
		for j=1, 2 do 
			buttons[j]:addEventListener("touch", mover_nave)
		end
		buttons[3]:addEventListener("touch",tiro_nave)

    	elseif ( phase == "did" ) then
    	pontos = 0
      	physics.start()
      	loop()
 		Runtime:addEventListener("enterFrame",loop_game)--singleton
 		Runtime:addEventListener("collision", onGlobalCollision)
		--local delay = math.random(3000,9000)
		timerTiroAliens = timer.performWithDelay( 1500, tiro_aliens, -1)
    end
end

function scene:hide(event)--quando você remove um objeto do Display, ele deve ser definido como nil.
	local phase = event.phase
	local group = self.view
	if  phase == "will"  then 
		--timer.cancel(timerTiroAliens)
   	
    elseif ( phase == "did" ) then
    	destruirTudo()
   		Runtime:removeEventListener("enterFrame",loop_game)--Sempre que você adicionar um ouvinte de evento, verifique se também o está removendo em algum momento mais adiante no programa.
   		Runtime:removeEventListener("collision", onGlobalCollision)
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
--scene:addEventListener("destroy", scene)

return scene