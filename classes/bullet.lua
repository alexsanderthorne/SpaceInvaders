local bomb = {}
local bomb_mt = { __index = bomb}
local composer = require("composer")
local scene = composer.newScene()

function bomb:new() -- constructor
	local group = {}
   return setmetatable( group, bomb_mt )
end

function scene:create(event,xloc, yloc) --initializer
	-- Create attributes
	self.bomb =display.newGroup ( )
	local bomb1 = display.newRect( self.bomb,2,2,2,12)
	bomb1:setFillColor ( 1, 0, 0  )
	local bomb1 = display.newRect( self.bomb,2,0,12,2)
	bomb1:setFillColor ( 1, 0, 0  )
	self.bomb.x = xloc
	self.bomb.y = yloc
	self.bomb.name = "bomb"
	local borderCollisionFilter --= { categoryBits = 2, maskBits = 22}  
	physics.addBody( self.bomb,  "dynamic", {borderCollisionFilter})
	
end
 
function scene:show(self, event)
		print("bomb Kaboom")
		Runtime:removeEventListener( "enterFrame", self )
		self.bomb:removeEventListener( "collision", self )
		self.bomb:removeSelf()
		self = nil
end

function bomb:enterFrame()
	self.bomb.y = self.bomb.y + 10
end

function bomb:start()
	---  Create Listeneres
	Runtime:addEventListener( "enterFrame", self )
	self.bomb:addEventListener( "collision", self )
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)

return scene