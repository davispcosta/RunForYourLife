
local composer = require("composer")
local physics = require("physics")

local sounds = require( "soundsfile" )

local level = require("leveltemplate")

local scene = composer.newScene()

composer.recycleOnSceneChange = true

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local jumpLimit = 0

-----------------------------------
-----------------------------------
--- SCENE EVENT FUNCTIONS

function scene:create( event )
	
	local sceneGroup = self.view
	level:setCurrentLevel(1)
	playGameMusic(babybgmusic)
	audio.setVolume( 0.50, { channel=1 } ) 

	background = level:createBackground(level:getCurrentLevel())
	backGroup:insert(background)

	player = level:createPlayer("ui/baby/normal-sprite.png", "running")
	mainGroup:insert(player)

	level:setValues(100,100,100,0)		
		
	local numShoots = level:createScoreProjectiles()
	uiGroup:insert(numShoots)

	local age = level:createScoreAge()
	uiGroup:insert(age)

	physics.start()		
	
	local floor = level:createFloor("ui/baby/ground.png")
	mainGroup:insert(floor)
		
	physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0})
	player.isFixedRotation=true	
	player.gravityScale = 0.8

	local function creationLoop(event)
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
		level:moveFloor(floor)
		
		back = level:updateBackground(level:getCurrentLevel())
		backGroup:insert(back)
	end

	movementLoop = timer.performWithDelay(1, update, -1)
	emergeLoop = timer.performWithDelay(1000, creationLoop, -1 )

	local function playerCollision( self, event )
		
		if(event.other.name == "CHAO") then	
			jumpLimit = 0
		end

		if( event.other.name == "COLECIONAVEL") then
			playSFX(bubblepop)

			if event.other.type == "health" then
				level:addHealth(1)
			end
			if event.other.type == "shoot" then
				level:addProjectiles(5)
			end
			level:addAge()

			level:collideCollectible()
			timer.performWithDelay(1, function()
				event.other.alpha = 0
		        event.other = nil
		    end, 1)
			event.other:removeSelf();
			
			if(level:getYears() == 5) then
				goToNextLevel()				
			end
		end

		if( event.other.name == "OBSTACLE") then
			playSFX(losesound)
			
			level:reduceHealth(10)			
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

	function goToNextLevel()
		timer.performWithDelay(500, function()
			playSFX(lvlupsound)			
		end)
		local playery = player.y
		local playerx = player.x
		player = level:celebratePlayer(player, "ui/baby/celebrating.png")
		player.y = playery
		player.x = playerx
		timer.performWithDelay(1, function()
			physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0 })						
		end)
		jumpbtn:removeEventListener("touch", jumpbtn)
		downbtn:removeEventListener("touch", downbtn)		
		shootbtn:removeEventListener("touch", shootbtn)
		mainGroup:insert(player)
		timer.pause(emergeLoop)
		timer.pause(movementLoop)	

		toLeft = timer.performWithDelay(1, function()
			player.x = player.x - 1
			if(player.x < 0) then
				composer.gotoScene("scene.congratulations")
			end
		end, -1)
		timer.pause(toLeft)

		timer.performWithDelay(1500, function()
			playery = player.y
			playerx = player.x
			player:removeSelf()
			player = level:createPlayer("ui/baby/normal-sprite.png", "normalRun")
			player.x = playerx
			player.xScale = -1
			player.y = playery
			mainGroup:insert(player)
			timer.resume(toLeft)
			physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, gravity = 0 })			
			player:setSequence("normalRun")
			player:play()
		end)
	end

	jumpbtn = display.newImageRect("ui/base/jumpbtn.png", 60, 60)
	jumpbtn.x = 0
	jumpbtn.y = display.contentHeight - 35

	function jumpbtn:touch(event)		
		if(event.phase == "began") then
			jumpLimit = jumpLimit + 1				
			if jumpLimit < 2 then
				if(player.sequence == "crowling") then
					player:removeSelf()
					player = level:createPlayer("ui/baby/normal-sprite.png", "normalRun")
					mainGroup:insert(player)
					physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, gravity = 0 })			
					player.isFixedRotation=true						
					player:setSequence("normalRun")
					player:play()
					player.collision = playerCollision			
					player:addEventListener("collision")
				else
					playSFX(jumpsound)					
					player:setLinearVelocity(0, -240)
				end
				
			end	
		end
	end
	jumpbtn:addEventListener("touch", jumpbtn)
	uiGroup:insert(jumpbtn)

	downbtn = display.newImageRect("ui/base/downbtn.png", 60, 60)
	downbtn.x = 70
	downbtn.y = display.contentHeight - 35
	function downbtn:touch(event)	
		if(event.phase == "began") then			
			if(jumpLimit == 0) then
				local playerx = player.x
				local playery = player.y
				player:removeSelf()
				player = level:createPlayer("ui/baby/crowling.png", "crowling")
				player.x = playerx
				player.y = playery
				mainGroup:insert(player)
				physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, gravity = 0 })			
				player.isFixedRotation=true					
				player.collision = playerCollision
				player:addEventListener("collision")
			end
		end
	end	
	downbtn:addEventListener("touch", downbtn)
	uiGroup:insert(downbtn)

	shootbtn = display.newImageRect("ui/base/shootbtn.png", 60, 60)
	shootbtn.x = display.contentWidth 
	shootbtn.y = display.contentHeight - 35

	local function shootCollision( self, event )
		
		if( event.other.name == "COLECIONAVEL") then
			level:addHealth(1)
			level:addAge()

			level:collideCollectible()
			timer.performWithDelay(1, function()
				event.other.alpha = 0
		        event.other = nil
		    end, 1)
			event.other:removeSelf();
			event.target:removeSelf();
			
			if(level:getYears() == 5) then
				goToNextLevel()	
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
			if(level:getNumProjectiles()  > 0) then
				local projectile = display.newImageRect("ui/baby/bear.png", 30, 30 )
				projectile.x = player.x
				projectile.y = player.y
				physics.addBody(projectile, 'dynamic')
				projectile.gravityScale = 0
				projectile.isSensor = true
				projectile.name = "PROJECTILE"
				projectile:setLinearVelocity( 150, 0 )
				projectile.collision = shootCollision
				projectile:addEventListener("collision")
				mainGroup:insert(projectile)
				level:reduceProjectiles(1)													
			end
		end
	end	
	shootbtn:addEventListener("touch", shootbtn)
	uiGroup:insert(shootbtn)
		
	local header = level:buildHeader(true, false, false, false)
	uiGroup:insert(header)

	level:buildPause(player)

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
		if(toLeft ~= nil) then
			timer.cancel(toLeft)			
		end
		level:destroy()		
		display.remove(mainGroup)
		display.remove(uiGroup)
		display.remove(backGroup)		
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