local M = {}

function M.newNave(params)
   local nave = {
      naveImage = display.newImageRect(params.image, 40, 50),
      live = params.live,
   }

   --posso criar o tiro da nave aqui e associar o touch ao botão do tiro(nova classe bulletNave)
   -- function nave:destroy()
   --    nave.naveImage:removeSelf()
   --    nave = nil
   -- end

   --tiros = timer.performWithDelay(params.timeDisparos, nave.launch, 0)
   return nave
end

return M