local M = {}

function M.newNave(params)
   local nave = {
      naveImage = display.newImageRect(params.image, 40, 50),
      live = params.live,
   }

   return nave
end

return M