
-- Include modules/libraries
local composer = require("composer")
local physics = require("physics")

local level = require("leveltemplate")
local sounds = require( "soundsfile" )

local scene = composer.newScene()
composer.recycleOnSceneChange = true

local player 

local gamePaused = false
local movementLoop
local emergeLoop

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

function scene:create( event )
	local sceneGroup = self.view
		level:setCurrentLevel(4)
	
		background = level:createBackground(level:getCurrentLevel())
		backGroup:insert(background)
	
		player = level:createPlayer("ui/adult/normal-sprite.png")
		mainGroup:insert(player)
	
		level:setValues(100,100,100,100)
		local header = level:buildHeader(true, true, true, true)
		uiGroup:insert(header)
	
		level:buildPause(player)

		local numShoots = level:createScoreProjectiles()
		uiGroup:insert(numShoots)
			
		local meters = level:createScoreMeters()
		uiGroup:insert(meters)
	
		physics.start()		
	
		local floor = level:createFloor("ui/adult/ground.png")
		mainGroup:insert(floor)
	
		physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, gravity = 0 })
	
		local function creationLoop( event )
			local aux = math.random(0, 10)
	
			if aux <= 6 then
				obstacle = level:createObstacle(level:getCurrentLevel())
				mainGroup:insert(obstacle)
			else
				collectible = level:createCollectible(level:getCurrentLevel())
				mainGroup:insert(collectible)
			end
		end
	
		local function update( event )
			level:moveCollectibles()
			level:moveObstacles()
			
			back = level:updateBackground(level:getCurrentLevel())
			backGroup:insert(back)
		end
		
		movementLoop = timer.performWithDelay(1, update, -1)
		emergeLoop = timer.performWithDelay(1000, creationLoop, -1 )
	
		local function playerCollision( self, event )
			print( "--- COLISAO ---" )
			print( event.target.name )        --the first object in the collision
			print( event.other.name )         --the second object in the collision
						
			if( event.other.name == "CHAO") then
				jumpLimit = 0
			end
	
			if( event.other.name == "COLECIONAVEL") then
				if event.other.type == "health" then
					level:addHealth(1)
				end
				if event.other.type == "money" then
					level:addMoney(1)
				end
				if event.other.type == "happiness" then
					level:addHappiness(1)
				end
				if event.other.type == "shoot" then
					level:addProjectiles(5)
				end
				level:addMeters()
	
				level:collideCollectible()
				timer.performWithDelay(1, function()
					event.other.alpha = 0
					event.other = nil
				end, 1)
				event.other:removeSelf();
	
				if(level:getMeters() == 5) then
					composer.gotoScene( "scene.congratulations", { effect="crossFade", time=333 } )
				end
			end
	
			if( event.other.name == "OBSTACLE") then
				if event.other.type == "health" then
					level:reduceHealth(10)
				end
				if event.other.type == "money" then
					level:reduceMoney(10)
				end
				if event.other.type == "happiness" then
					level:reduceHappiness(10)
				end

				level:collideObstacle()
				if level:isAlive() then
					timer.performWithDelay(1, function()
						event.other.alpha = 0
						event.other = nil
					end, 1)
					event.other:removeSelf();
				else
					composer.gotoScene( "scene.gameover", { time=800, effect="crossFade" } )
				end				    	
			end
		end
		player.collision = playerCollision
		player:addEventListener("collision")
	
		jumpbtn = display.newImageRect("ui/base/jumpbtn.png", 40, 40)
		jumpbtn.x = 20
		jumpbtn.y = display.contentHeight - 40
		uiGroup:insert(jumpbtn)
			
		function jumpbtn:touch(event)
			if(event.phase == "began" and jumpLimit < 1) then
				player:setLinearVelocity(0, -240)
				jumpLimit = jumpLimit + 1
			end
		end
		jumpbtn:addEventListener("touch", jumpbtn)

		shootbtn = display.newImageRect("ui/base/shootbtn.png", 40, 40)
		shootbtn.x = display.contentWidth 
		shootbtn.y = display.contentHeight - 40
	
		local function shootCollision( self, event )
			print( "--- COLISAO ---" )
			print( event.target.name )        --the first object in the collision
			print( event.other.name )         --the second object in the collision
	
			if( event.other.name == "COLECIONAVEL") then
				if event.other.type == "health" then
					level:addHealth(1)
				end
				if event.other.type == "money" then
					level:addMoney(1)
				end
				if event.other.type == "happiness" then
					level:addHappiness(1)
				end
				level:addMeters()
	
				level:collideCollectible()
				timer.performWithDelay(1, function()
					event.other.alpha = 0
					event.other = nil
				end, 1)
				event.other:removeSelf();
				event.target:removeSelf();
				
				if(level:getMeters() == 5) then
					composer.gotoScene( "scene.congratulations", { effect="crossFade", time=333 } )
				end
			end
	
			if( event.other.name == "OBSTACLE") then
				level:collideObstacle()
				timer.performWithDelay(1, function()
					event.other.alpha = 0
					event.other = nil
				end, 1)
				event.other:removeSelf();
				event.target:removeSelf();	    	
			end
		end
	
		function shootbtn:touch(event)	
			if(event.phase == "began") then
				if(level:getNumProjectiles() > 0) then
					local projectile = display.newImageRect("ui/adult/suitcase.png", 30, 30 )
					projectile.x = player.x
					projectile.y = player.y
					physics.addBody(projectile, 'dynamic')
					projectile.gravityScale = 0
					projectile.isSensor = true
					projectile.name = "PROJECTILE"
					projectile:setLinearVelocity( 150, 0 )
					projectile.collision = shootCollision
					projectile:addEventListener("collision")
					level:reduceProjectiles(1)
				end
			end
		end	
		shootbtn:addEventListener("touch", shootbtn)
		uiGroup:insert(shootbtn)
	
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
		Runtime:removeEventListener( "collision", playerCollision)
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