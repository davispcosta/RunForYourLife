
-- Include modules/libraries
local composer = require("composer")
local physics = require("physics")

local level = require("leveltemplate")
local sounds = require( "soundsfile" )

local scene = composer.newScene()
composer.recycleOnSceneChange = true

local obstacles = {}
local obstaclesCounter = 0
local obstaclesDisappear = 0

local collectibles = {}
local collectiblesCounter = 0
local collectiblesDisappear = 0

local player 

local gamePaused = false
local movementLoop
local emergeLoop

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local health = 100
local happiness = 100
local money = 100
local wedding = 100

local meters = 0

function resumeGame()
	player:play()
	physics.start()
	timer.resume(movementLoop)
	timer.resume(emergeLoop)
	resumebox:removeSelf()
	resumebtn:removeSelf()
	pauserect:removeSelf()
	gamePaused = false
end

function pauseGame()
	gamePaused = true
	player:pause()
	physics.pause()
	timer.pause(movementLoop)
	timer.pause(emergeLoop)

	pauserect = display.newRect(0, 0, display.contentWidth+100, 640)
	pauserect.x = display.contentWidth/2
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)
	uiGroup:insert(pauserect)

	resumebox = display.newRect( 0, 0, display.contentWidth/2, display.contentHeight/2 )
		resumebox.x = display.contentWidth/2
		resumebox.y = display.contentHeight/2 
		resumebox:setFillColor(1, 1, 1)
		uiGroup:insert(resumebox)

	resumebtn = display.newImageRect("ui/menu/resumebtn.png", 60, 60)
		resumebtn.x = display.contentWidth/2
		resumebtn.y = display.contentHeight/2 
		uiGroup:insert(resumebtn)
		resumebtn:addEventListener("tap", resumeGame)


end

-----------------------------------
-----------------------------------
--- SCENE EVENT FUNCTIONS

function scene:create( event )
	local sceneGroup = self.view

	playgameMusic(adultbgmusic)

	local speed = 5;

		-----------------------------------
		-----------------------------------
		--- O  BACKGROUND

		local background = display.newImageRect(backGroup, "ui/adult/background.png", 600, 400 )
			background.x = display.contentCenterX
			background.y = display.contentCenterY+90
		backGroup:insert(background)

		local backgroundfar = display.newImage("ui/adult/bgfar1.png")
 		backgroundfar.x = 480
 		backgroundfar.y = 160
 		backGroup:insert(backgroundfar)

 		local backgroundnear1 = display.newImage("ui/adult/bgnear2.png")
 		backgroundnear1.x = 240
 		backgroundnear1.y = 160
 		backGroup:insert(backgroundnear1)

 		local backgroundnear2 = display.newImage("ui/adult/bgnear2.png")
 		backgroundnear2.x = 760
 		backgroundnear2.y = 160
 		backGroup:insert(backgroundnear2)

 		function updateBackgrounds()

 			backgroundfar.x = backgroundfar.x - (speed/55)
 			backgroundnear1.x = backgroundnear1.x - (speed/5)

			if(backgroundnear1.x < -239) then
 				backgroundnear1.x = 760
 			end
			backgroundnear2.x = backgroundnear2.x - (speed/5)
			
			if(backgroundnear2.x < -239) then
				backgroundnear2.x = 760
			end
 		end

		-----------------------------------
		-----------------------------------
		--- UI

		local header = display.newRect( 0, 0, display.contentWidth+100, 100 )
		header.x = display.contentWidth/2
		header.y = 0
		header:setFillColor(1, 0.75, 0.14)
		uiGroup:insert(header)

		local healthText = display.newText(health .. "%", 0, 0, "zorque.ttf", 30)
		healthText.x = 45
		healthText.y = 25
		uiGroup:insert(healthText)

		local healthIcon = display.newImageRect("ui/adult/health.png", 20, 20)
		healthIcon.x = -10
		healthIcon.y = 25
		uiGroup:insert(healthIcon)

		local happinessText = display.newText(happiness .. "%", 0, 0, "zorque.ttf", 30)
		happinessText.x = 165
		happinessText.y = 25
		uiGroup:insert(happinessText)

		local happinessIcon = display.newImageRect("ui/adult/happiness.png", 20, 20)
		happinessIcon.x = 110
		happinessIcon.y = 25
		uiGroup:insert(happinessIcon)

		local moneyText = display.newText(money .. "%", 0, 0, "zorque.ttf", 30)
		moneyText.x = 285
		moneyText.y = 25
		uiGroup:insert(moneyText)

		local moneyIcon = display.newImageRect("ui/adult/money.png", 20, 20)
		moneyIcon.x = 230
		moneyIcon.y = 25
		uiGroup:insert(moneyIcon)

		local weddingText = display.newText(wedding .. "%", 0, 0, "zorque.ttf", 30)
		weddingText.x = 400
		weddingText.y = 25
		uiGroup:insert(weddingText)

		local weddingIcon = display.newImageRect("ui/adult/wedding.png", 20, 20)
		weddingIcon.x = 350
		weddingIcon.y = 25
		uiGroup:insert(weddingIcon)

		local scoreMeters = display.newText("score:  " .. meters, 0, 0, "zorque.ttf", 30)
		scoreMeters.x = display.contentWidth-100
		scoreMeters.y = display.contentHeight-30
		uiGroup:insert(scoreMeters)

		local pausebtn = display.newImageRect("ui/menu/pausebtn.png", 30, 30)
		pausebtn.x = display.contentWidth
		pausebtn.y = 25
		uiGroup:insert(pausebtn)
		pausebtn:addEventListener("tap", pauseGame)
		
		-----------------------------------
		-----------------------------------
		--- O PERSONAGEM 

		local sheetOptions =
		{
		    width = 45,
		    height = 69,
		    numFrames = 4
		}

		local sheet_player = graphics.newImageSheet( "ui/adult/mansheet.png", sheetOptions)

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

		player = display.newSprite(sheet_player, sequences_running)
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
					if(gamePaused == false) then
						if(event.phase == "began" and limit < 1) then
							playSFX(jumpsound)
							player:setLinearVelocity(0, -240)
							limit = limit + 1
						end
					end
				end

				backGroup:addEventListener("touch", onTouch)

		----------------------------------------------------------
		----------------------------------------------------------
		--- FÍSICA E CRIAÇÃO DO CHÃO

		physics.start()
		physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, gravity = 0 })

		local groundMin = 300
		local groundMax = 340
		local groundLevel = groundMin
		 
		for a = 1, 8, 1 do
		--AQUI GERAMOS O NOSSO CHÃO
		local newBlock
		newBlock = display.newImage("ui/adult/ground.png")
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
		    local typeCol = math.random(1, 2);

		    if(typeCol == 1) then
			    obstacles[obstaclesCounter] = display.newImageRect("ui/adult/deadblast.png", 30, 50)
		    	obstacles[obstaclesCounter].type = "ALEGRIA"
		    else
		    	obstacles[obstaclesCounter] = display.newImageRect("ui/adult/deadblast.png", 30, 50)
		    	obstacles[obstaclesCounter].type = "SAUDE"
			end

		    obstacles[obstaclesCounter].x = display.contentWidth + 50
		    obstacles[obstaclesCounter].y = yVal
		    mainGroup:insert(obstacles[obstaclesCounter])
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
		    local typeCol = math.random(1, 2);

		    if(typeCol == 1) then
		    	collectibles[collectiblesCounter] = display.newImageRect("ui/adult/blast.png", 30, 50)
		    	collectibles[collectiblesCounter].type = "ALEGRIA"
		    	happiness = happiness - 1
		    	happinessText.text = happiness .. "%"
		    else
		    	collectibles[collectiblesCounter] = display.newImageRect("ui/adult/vaccine.png", 15, 50)
		    	collectibles[collectiblesCounter].type = "SAUDE"
		    	health = health - 1
		    	healthText.text = health .. "%"
			end

		    collectibles[collectiblesCounter].x = display.contentWidth + 50
		    collectibles[collectiblesCounter].y = yVal
		    
			mainGroup:insert(collectibles[collectiblesCounter])
		    collectibles[collectiblesCounter].name = "COLECIONAVEL"
		    collectibles[collectiblesCounter].id = collectiblesCounter
		    physics.addBody(collectibles[collectiblesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })
		    collectiblesCounter = collectiblesCounter + 1

		    
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
			meters = meters + 1
			scoreMeters.text = "score:  " .. meters

			speed = speed + 0.01
			if aux <= 6 then
				showCollectibles()
			else
				showObstacles()
			end
		end

		local function update( event )
			moveCollectibles()
			moveObstacles()
			updateBackgrounds()
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

				    	if(event.other.type == "ALEGRIA") then
				    		happiness = happiness + 1
				    		happinessText.text = happiness .. "%"
				    	else 
				    		health = health + 1
				    		healthText.text = health .. "%"
						
				    	end
				    	
				    	meters = meters + 1
						scoreMeters.text = "Score:  " .. meters
				    	collectiblesDisappear = collectiblesDisappear + 1
				    	timer.performWithDelay(1, function()
				    		event.other.alpha = 0
		                	event.other = nil
		            	end, 1)
		            	event.other:removeSelf();
				    end

				    if( event.other.name == "OBSTACLE") then

				    	if(event.other.type == "ALEGRIA") then
				    		happiness = happiness - 50
				    		if happiness > 0 then
								happinessText.text = happiness .. "%"
								timer.performWithDelay(1, function()
					    			event.other.alpha = 0
			                		event.other = nil
			            		end, 1)
			            		event.other:removeSelf();
							else
								audio.stop(1)
								composer.gotoScene( "scene.gameover", { time=800, effect="crossFade" } )
							end
				    	else 
				    		health = health - 50
				    		if health > 0 then
								healthText.text = health .. "%"
								timer.performWithDelay(1, function()
					    			event.other.alpha = 0
			                		event.other = nil
			            		end, 1)
			            		event.other:removeSelf();
							else
								composer.gotoScene( "scene.gameover", { time=800, effect="crossFade" } )
							end						
				    	end
				    	
				    	obstaclesDisappear = obstaclesDisappear + 1						
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

	elseif ( phase == "did" ) then

		physics.pause()
		composer.removeScene("adultLevel")
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