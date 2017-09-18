
-- Include modules/libraries
local composer = require("composer")
local physics = require("physics")

local scene = composer.newScene()

composer.recycleOnSceneChange = true
local obstacles = {}
local obstaclesCounter = 0
local obstaclesDisappear = 0

local collectibles = {}
local collectiblesCounter = 0
local collectiblesDisappear = 0

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local score = 100

-----------------------------------
-----------------------------------
--- SCENE EVENT FUNCTIONS

function scene:create( event )
	local sceneGroup = self.view

	local speed = 5;

		-----------------------------------
		-----------------------------------
		--- O  BACKGROUND

		local background = display.newImageRect(backGroup, "ui/baby/background.png", 600, 400 )
			background.x = display.contentCenterX
			background.y = display.contentCenterY
		backGroup:insert(background)

		-----------------------------------
		-----------------------------------
		--- O SCORE

		local scoreText = display.newText(score .. "%", 0, 0, "", 30)
		scoreText.x = 70
		scoreText.y = 60
		local scoreIcon = display.newImageRect("ui/baby/health.png", 30, 30)
		scoreIcon.x = 10
		scoreIcon.y = 60
		uiGroup:insert(scoreText)
		uiGroup:insert(scoreIcon)

		-----------------------------------
		-----------------------------------
		--- O PERSONAGEM 

		local sheetOptions =
		{
		    width = 45,
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

		local groundMin = 300
		local groundMax = 340
		local groundLevel = groundMin
		 
		for a = 1, 8, 1 do
		--AQUI GERAMOS O NOSSO CHÃO
		local newBlock
		newBlock = display.newImage("ui/baby/ground.png")
		newBlock.name = "CHAO"
		-- REPOSICIONANDO O CHÃO
		newBlock.x = (a * 79) - 85
		newBlock.y = groundLevel
		physics.addBody(newBlock, "static",  { density = 0, friction = 0, bounce = 0 })
		mainGroup:insert(newBlock)
		end

		-----------------------------------
		-----------------------------------
		--- OBSTÁCULOS

		showObstacles = function()

		    local yVal = math.random(100, display.contentHeight-80)

		    obstacles[obstaclesCounter] = display.newImageRect("ui/baby/deadblast.png", 30, 50)
		    obstacles[obstaclesCounter].x = display.contentWidth + 50
		    obstacles[obstaclesCounter].y = yVal

		    obstacles[obstaclesCounter].name = "OBSTACLE"
		    obstacles[obstaclesCounter].id = obstaclesCounter
		    physics.addBody(obstacles[obstaclesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })
		    obstaclesCounter = obstaclesCounter + 1
		end

		moveObstacles = function ()
			for a = 0, obstaclesCounter, 1 do
				if obstacles[a] ~= nil and obstacles[a].x ~= nil then
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

		local function damage()
			
		end

		-----------------------------------
		-----------------------------------
		--- COLECIONÁVEIS


		showCollectibles = function()

		    local yVal = math.random(100, display.contentHeight-80)

		    collectibles[collectiblesCounter] = display.newImageRect("ui/baby/blast.png", 30, 50)
		    collectibles[collectiblesCounter].x = display.contentWidth + 50
		    collectibles[collectiblesCounter].y = yVal

		    collectibles[collectiblesCounter].name = "COLECIONAVEL"
		    collectibles[collectiblesCounter].id = collectiblesCounter
		    physics.addBody(collectibles[collectiblesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })
		    collectiblesCounter = collectiblesCounter + 1

		    score = score - 1
		    scoreText.text = score .. "%"
		end

		moveCollectibles = function ()
			for a = 0, collectiblesCounter, 1 do
				if collectibles[a] ~= nil and collectibles[a].x ~= nil then
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
		--- MOVIMENTO DO CENARIO E CRIAÇÃO RANDOMICA

		local function creationLoop( event )
			local aux = math.random(0, 10)
			if aux <= 6 then
				showCollectibles()
			else
				showObstacles()
			end
		end

		local function update( event )

			moveCollectibles()
			moveObstacles()
		end

		movementLoop = timer.performWithDelay(1, update, -1)
		emergeLoop = timer.performWithDelay(1000, creationLoop, -1 )

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
				    	scoreText.text = score .. "%"
				    	collectiblesDisappear = collectiblesDisappear + 1
				    	timer.performWithDelay(1, function()
				    		event.other:removeSelf()
		                	event.other = nil
		            	end, 1)
				    end

				    if( event.other.name == "OBSTACLE") then
				    	score = score - 50
				    	obstaclesDisappear = obstaclesDisappear + 1

						if score > 0 then
							scoreText.text = score .. "%"
							timer.performWithDelay(1, function()
				    			event.other:removeSelf()
		                		event.other = nil
		            		end, 1)
						else
							composer.gotoScene( "scene.gameover", { time=800, effect="crossFade" } )
						end
				    end
				end
				player.collision = onLocalCollision
				player:addEventListener("collision")
		

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
		timer.cancel(movementLoop)
		timer.cancel(emergeLoop)
		display.remove(mainGroup)
		display.remove(uiGroup)
		display.remove(backGroup)

		for i=0, #obstacles do
			if (obstacles[i] ~= nil) then
				display.remove(obstacles[i])
			    obstacles[i] = nil        -- Nil Out Table Instance
			end
		end
		
		for i=0, #collectibles do
			if (collectibles[i] ~= nil) then
				display.remove(collectibles[i])
			    collectibles[i] = nil        -- Nil Out Table Instance
			end
		end
		

	elseif ( phase == "did" ) then

		physics.pause()
		composer.removeScene("babyLevel")
		composer.hideOverlay()
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