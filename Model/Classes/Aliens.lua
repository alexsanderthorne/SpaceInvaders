local M = {} --modulo externo
local aliens = {}


function M.newAlien(params)--crie o módulo com os aliens já criados
   for i=1,12 do

      aliens[i] = {
            alienImage = display.newImageRect("View/Images/Enemy.png",27,27),
            live = params.live,
      }

function aliens:atirar()-- e atirando aleatoriamente
      if #aliens > 0  then
           local indiceAleatorio = math.random(#aliens)
           local invasorAleatorio = aliens[indiceAleatorio]

         if invasorAleatorio.x ~= nil and invasorAleatorio.y ~= nil then
            if aliens[i] ~= nil then
               local shot = display.newRect(aliens[indiceAleatorio].x,aliens[indiceAleatorio].y,4,6)
               shot:setFillColor(1,0.2,0)
               shot.myName = params.typeShot
               physics.addBody(shot, "dinamic")

               transition.to(
                  shot,
                  {--propriedades da transição
                     y = params.direction,
                     time = params.time,
                     onComplete = function()
                        display.remove(shot)
                     end
                  }
               )
               
            end
         end
      end
end

   function aliens:destroy()
      aliens[i].alienImage:removeSelf()
      alien[i] = nil
   end

   end

timerTiroAliens = timer.performWithDelay(3000, aliens.atirar, -1)
   return aliens
end

return M