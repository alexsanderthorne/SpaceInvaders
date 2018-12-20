local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
local nave = require("Model.Classes.Nave")
local score = require("BD.score")
physics.start(true)
physics.setGravity(0, 0)
--physics.setDrawMode("debug")

display.setStatusBar (display.HiddenStatusBar)
system.setIdleTimer(false) --impede a tela de apagar

local w = display.contentWidth
local h = display.contentHeight
 
local buttons = {}
local aliens = {}
balasInvasores = {}
timerTiroAliens = 0
timermoverAliens = 0
local margemEsquerda = 20
local margemDireita = w - 20
local invasorMetade = 6
velocidadeAlien = 0.4
mover_navex = 0
ajustary = h / 20
ajustarx = 49
pontos = 0
vidas = 3
 
function menu()
	--composer.removeScene("View.gamePlay")
    composer.gotoScene("View.menuScene")
end

function winner()
	--score:atualizarPontuacao(pontos)
	composer.gotoScene("View.winner")
end

function GameOver()
	score:atualizarPontuacao(pontos)
   composer.gotoScene("View.gameOver")
end

function loop_game()
	--A ordem em que você adiciona coisas à cena é a ordem em que elas serão exibidas.
	atualizarPosicaoNave()
	gotoWinner()
end

function atualizar()
   pontosDisplay.text = "pontos : " .. pontos
   vidasDisplay.text = "vidas : " .. newNave.live
end

podeAtirar = true
function colisaoGlobal(event)
	if event.phase == "began" then
		if
         (event.object1.myName == "inimigos" and event.object2.myName == "tiroNave") or
            (event.object1.myName == "tiroNave" and event.object2.myName == "inimigos")
       then
         pontos = pontos + 100

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
         podeAtirar = true
      elseif
         (event.object1.myName == "defensor" and event.object2.myName == "tiroAlien") or
            (event.object1.myName == "tiroAlien" and event.object2.myName == "defensor")
       then
        if newNave.live > 0 then

	         if event.object1.myName == "tiroAlien" then -- remover apenas o tiro
	            display.remove(event.object1)
	         elseif event.object2.myName == "tiroAlien" then
	         	display.remove(event.object2)
	         end 
         newNave.live = newNave.live - 1
     	-- else
     	-- 	display.remove(event.object1)
	     --    display.remove(event.object2)
     	end
      elseif
         (event.object1.myName == "inimigos" and event.object2.myName == "defensor") or
            (event.object1.myName == "defensor" and event.object2.myName == "inimigos")
       then

	       for i = #aliens, 1, -1 do
		       	if aliens[i] == event.object1 then
				       	table.remove(aliens, i)
				       	display.remove(event.object1)
				end
			     
		    end
		         newNave.live = newNave.live - 1
		
		end
		elseif
         (event.object1.myName == "inimigos" and event.object2.myName == "linha") or--colisão para detectar se os aliens passaram da nave e não foram destruidos por ela
            (event.object1.myName == "linha" and event.object2.myName == "inimigos")
       then

         for i = #aliens, 1, -1 do
	            if aliens[i] == event.object1 then
		               table.remove(aliens, i)
		               display.remove(event.object1)
	            elseif aliens[i] == event.object2 then
		               table.remove(aliens, i)
		               display.remove(event.object2)
	            end
	            if aliens[i] == nil then
	            	menu()
	            	
	            end
         end
	end

		atualizar()
	   if newNave.live <= 0 then
	      GameOver()
	   end
end

function gotoWinner()
	atualizar()
	if pontos >= 2400 then
		winner()
	end
end

function criarNave()

	defensor = {
	   image = "View/Images/ship_b.png",
	   live = 3,
	}
		newNave = nave.newNave(defensor)
		physics.addBody(newNave.naveImage,"dynamic", {isSensor = true, radius = 15})  
		newNave.naveImage.myName = "defensor"
      	newNave.naveImage.x =  w / 2
      	newNave.naveImage.y =  h / 2 + 180
      	group:insert(newNave.naveImage) 
end

function tiroNave(event)
	verificacaoGlobal()
	if event.phase == "began" then	
		if podeAtirar == true then
			local shot = display.newRect(newNave.naveImage.x,newNave.naveImage.y,4,6)
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

function touchNave(event) --ctrl+d para mudar todas as váriáveis de uma só vez
	if event.phase == "began" or event.phase == "moved" then
		if event.target.myName == "direita" then
			mover_navex = 5
		elseif event.target.myName == "esquerda" then
			mover_navex = -5
		end
	else 
		mover_navex = 0
	end
end

function atualizarPosicaoNave()
	if newNave.naveImage.x ~= nil  then
		newNave.naveImage.x = newNave.naveImage.x + mover_navex
	if newNave.naveImage.x <= newNave.naveImage.width * 0.5 then
		newNave.naveImage.x = newNave.naveImage.width * 0.5
	elseif newNave.naveImage.x >= w - newNave.naveImage.width * 0.5 then 
		newNave.naveImage.x = w - newNave.naveImage.width * 0.5
	end
	end
end

local function naveAccelerate(event)--acelerometro funcionando *_*
	if newNave.naveImage.x ~= nil  then
    newNave.naveImage.x = newNave.naveImage.x + event.xGravity*50--zGravity não é,yGravity tbm não
	end
end
  
function aliens:criarAliens(event)
	local group = display.newGroup()
		for i=1,24 do

		self[i] = display.newImageRect("View/Images/Enemy.png",27,27)
		self[i].x = ajustarx
		self[i].y = ajustary 
		self[i].i = i
		physics.addBody( self[i], "dynamic" )
		group:insert(self[i])
		self[i].myName = "inimigos"
		ajustary = ajustary + 30

			if i % 4 == 0 then
					
			ajustarx = ajustarx + 36
			ajustary = h / 20
			end
		end
	return group
end

function tiroAliens(event)
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

function removeTiroAliens()
	for i=1,#balasInvasores do
		display.remove(balasInvasores[i])
	end
end

function moverAliens()
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
        velocidadeAlien = velocidadeAlien*-1
        for j = 1, #aliens do
            aliens[j].y = aliens[j].y + 36
        end
        mudaDirecao = false;
    end 
end

-- local function loop(event)
-- 	--criarAliens()

--    for i = #aliens, 1, -1 do
--       if aliens[i] ~= nil then
--          if aliens[i].y >= h / 2 + 180 then
--             aliens[i].destroy()
--             table.remove(aliens, i)
--          end
--       end
--    end
--    menu()
-- end

function scene:create(event)
	local sceneGroup = self.view
	group = display.newGroup()
   	sceneGroup:insert(group)

		physics.pause()

		pontosDisplay = display.newText(group, "pontos : " .. pontos, w / 2, 0)
		pontosDisplay:setFillColor(1,0,0)
	   	vidasDisplay = display.newText(group, "vidas : " .. vidas, 248,0)
	   	vidasDisplay:setFillColor(0,1,0)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	 if  phase == "will"  then
	  
    	pontos = 0
    	
   		sceneGroup:insert(aliens:criarAliens())
   		criarNave()
   		local linha1 = display.newLine(sceneGroup , 0,575,w,575)
		 physics.addBody(linha1,"dinamic",{isSensor = true})
		 linha1.myName = "linha"

      	elseif phase == "did" then

      	physics.start()
		buttons[1] = display.newImage(group,"View/Images/button.png")
		buttons[1].x = 30
		buttons[1].y = 470
		buttons[1].myName = "esquerda"
		buttons[1].rotation = 180

		buttons[2] = display.newImage(group, "View/Images/button.png")
		buttons[2].x = 90
		buttons[2].y = 470
		buttons[2].myName = "direita"

		buttons[3] = display.newImage(group, "View/Images/button.png")
		buttons[3]:setFillColor(1,0,0)
		buttons[3].x = 260
		buttons[3].y = 470
		buttons[3].rotation = -90

		local j=1  
		for j=1, 2 do 
			buttons[j]:addEventListener("touch", touchNave)
		end
		buttons[3]:addEventListener("touch",tiroNave)
		
 		Runtime:addEventListener("enterFrame",loop_game)--singleton
 		Runtime:addEventListener("collision", colisaoGlobal)
 		Runtime:addEventListener("accelerometer",naveAccelerate)
		timerTiroAliens = timer.performWithDelay( 5000, tiroAliens, -1)
		timermoverAliens = timer.performWithDelay(velocidadeAlien,moverAliens,-1)
    	end
end

function scene:hide(event)--quando você remove um objeto do Display, ele deve ser definido como nil.
	local phase = event.phase
	local sceneGroup = self.view

	if  phase == "will"  then 
   		removeTiroAliens()
   		-- composer.removeScene("View.gamePlay" )
     elseif ( phase == "did" ) then
     	--loop()
   		Runtime:removeEventListener("enterFrame",loop_game)--Sempre que você adicionar um ouvinte de evento, verifique se também o está removendo em algum momento mais adiante no programa.
   		Runtime:removeEventListener("collision", colisaoGlobal)
   		Runtime:removeEventListener("accelerometer",naveAccelerate)
   		Runtime:removeEventListener("enterFrame",tiroNave)
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