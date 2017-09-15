
-- Include modules/libraries
local composer = require("composer")
local physics = require("physics")

local scene = composer.newScene()

local speed = 5;

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-----------------------------------
-----------------------------------
--- O  BACKGROUND


-----------------------------------
-----------------------------------
--- O SCORE

local score = 0
local scoreText = display.newText("Foguetes: " .. score, 0, 0, "BorisBlackBloxx", 30)
scoreText.x = 60
scoreText.y = 60
uiGroup:insert(scoreText)

-----------------------------------
-----------------------------------
--- O PERSONAGEM 

local sheetOptions =
{
    width = 100,
    height = 69,
    numFrames = 4
}

local sheet_player = graphics.newImageSheet( "ui/baby/mansheet.png", sheetOptions)

local sequences_running = {
    {
        name = "normalRun",
        start = 1,
        count = 4,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local player = display.newSprite(sheet_player, sequences_running)
player.name = 'JOGADOR'
player.x = 80
player.y = 230
player:setSequence( "sequences_running" )
player:play()
mainGroup:insert(player)
		-----------------------------------
		-----------------------------------
		---  PULO

		local limit = 0
		function onTouch(event)
			if(event.phase == "began" and limit < 1) then
				player:setLinearVelocity(0, -200)
				limit = limit + 1
			end
		end

		Runtime:addEventListener("touch", onTouch)

----------------------------------------------------------
----------------------------------------------------------
--- FÍSICA E CRIAÇÃO DO CHÃO

physics.start()
physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, })

local blocks = display.newGroup()

local groundMin = 300
local groundMax = 340
local groundLevel = groundMin
 
for a = 1, 8, 1 do
--AQUI GERAMOS O NOSSO CHÃO
local newBlock
newBlock = display.newImage("ui/baby/ground.png")
newBlock.name = "CHAO"
-- REPOSICIONANDO O CHÃO
newBlock.x = (a * 79) - 79
newBlock.y = groundLevel
physics.addBody(newBlock, "static",  { density = 0, friction = 0, bounce = 0 })
blocks:insert(newBlock)
end

-----------------------------------
-----------------------------------
--- OBSTÁCULOS

local obstacles = {}
local obstaclesCounter = 0
local obstaclesDisappear = 0

showObstacles = function()

    local yVal = math.random(100, display.contentHeight-80)

    obstacles[obstaclesCounter] = display.newImageRect("ui/baby/deadblast.png", 50, 50)
    obstacles[obstaclesCounter].x = display.contentWidth
    obstacles[obstaclesCounter].y = yVal

    obstacles[obstaclesCounter].name = "OBSTACLE"
    obstacles[obstaclesCounter].id = obstaclesCounter
    physics.addBody(obstacles[obstaclesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })
    obstaclesCounter = obstaclesCounter + 1
end
obstacleLoop = timer.performWithDelay( 3000, showObstacles, -1 )

moveObstacles = function ()
	for a = 0, obstaclesCounter, 1 do
		if obstacles[a] ~= nil and obstacles[a].x ~= nil then
			print(obstacles[a])
			if obstacles[a].x < -100 then
				obstaclesDisappear = obstaclesDisappear + 1
		    	timer.performWithDelay(1, function()
                	obstacles[a] = nil;
            	end, 1)
            else
            	obstacles[a].x = obstacles[a].x  - (speed/2)
			end
		end
	end
end

local function die()
	composer.gotoScene( "scene.menu", { time=800, effect="crossFade" } )
end

-----------------------------------
-----------------------------------
--- COLECIONÁVEIS

local collectibles = {}
local collectiblesCounter = 0
local collectiblesDisappear = 0

showCollectibles = function()

    local yVal = math.random(100, display.contentHeight-80)

    collectibles[collectiblesCounter] = display.newImageRect("ui/baby/blast.png", 50, 50)
    collectibles[collectiblesCounter].x = display.contentWidth
    collectibles[collectiblesCounter].y = yVal

    collectibles[collectiblesCounter].name = "COLECIONAVEL"
    collectibles[collectiblesCounter].id = collectiblesCounter
    physics.addBody(collectibles[collectiblesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })
    collectiblesCounter = collectiblesCounter + 1
end
collectLoop = timer.performWithDelay( 1000, showCollectibles, -1 )

moveCollectibles = function ()
	for a = 0, collectiblesCounter, 1 do
		if collectibles[a] ~= nil and collectibles[a].x ~= nil then
			print(collectibles[a])
			if collectibles[a].x < -100 then
				collectiblesDisappear = collectiblesDisappear + 1
		    	timer.performWithDelay(1, function()
                	collectibles[a] = nil;
            	end, 1)
            else
            	collectibles[a].x = collectibles[a].x  - (speed/2)
			end
		end
	end
end


-----------------------------------
-----------------------------------
--- MOVIMENTO DO CENARIO

local function update( event )

	moveCollectibles()
	moveObstacles()
end

movementLoop = timer.performWithDelay(1, update, -1)

-----------------------------------
-----------------------------------
--- MOVIMENTO

local function onLocalCollision( self, event )
			print( "--- COLISAO ---" )
		    print( event.target.name )        --the first object in the collision
		    print( event.other.name )         --the second object in the collision
		    
		    if( event.other.name == "CHAO") then
		    	limit = 0
		    end

		    if( event.other.name == "COLECIONAVEL") then
		    	score = score + 1
		    	scoreText.text = "Foguetes: " .. score
		    	collectiblesDisappear = collectiblesDisappear + 1
		    	timer.performWithDelay(1, function()
		    		event.other:removeSelf()
                	event.other = nil
            	end, 1)
		    end

		    if( event.other.name == "OBSTACLE") then
		    	die()
		    end
		end
		player.collision = onLocalCollision
		player:addEventListener("collision")


-----------------------------------
-----------------------------------
--- SCENE EVENT FUNCTIONS

function scene:create( event )
	local sceneGroup = self.view

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		timer.cancel(collectLoop)
		timer.cancel(obstacleLoop)
		timer.cancel(movementLoop)
		display.remove(blocks)
		display.remove(mainGroup)
		display.remove(uiGroup)

		for i=0, #obstacles do
			if (obstacles[i] ~= nil) then
				display.remove(obstacles[i])
			    obstacles[i] = nil        -- Nil Out Table Instance
			end
		end
		
		print('collectibles')
		print(collectibles)
		for i=0, #collectibles do
			if (collectibles[i] ~= nil) then
				display.remove(collectibles[i])
			    collectibles[i] = nil        -- Nil Out Table Instance
			end
		end
		

	elseif ( phase == "did" ) then
		physics.pause()
		composer.removeScene("babyLevel")
		Runtime:removeEventListener( "collision", onLocalCollision)
		Runtime:removeEventListener("touch", onTouch)
	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene