local base = require( "base")

local lvl = {} 
local uiGroup = display.newGroup()
local collectGroup = display.newGroup()

local background
local backgroundnear1
local backgroundnear2

local healthText
local health = 0
local happinessText
local happiness = 0
local money = 0
local moneyText
local wedding = 0
local weddingText

local meters = 0
local scoreMeters
local speed = 40;
local jumpLimit = 0

local gamePaused = false
local playerT

local obstacles = {}
local obstaclesCounter = 0
local obstaclesDisappear = 0
local numProjectile = 10

local collectibles = {}
local collectiblesCounter = 0
local collectiblesDisappear = 0

local currentLevel

function resumeGame()
	playerT:play()
	physics.start()
	timer.resume(movementLoop)
	timer.resume(emergeLoop)
	resumebox:removeSelf()
	resumebtn:removeSelf()
	resumeText:removeSelf()
	pauserect:removeSelf()
	gamePaused = false
end

function pauseGame()
	gamePaused = true

	playerT:pause()
	physics.pause()
	timer.pause(movementLoop)
	timer.pause(emergeLoop)

	pauserect = display.newRect(0, 0, display.contentWidth+100, 640)
	pauserect.x = display.contentWidth/2
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)

	resumebox = display.newImageRect("ui/pause/box.png", display.contentWidth/2, display.contentHeight/2 )
		resumebox.x = display.contentWidth/2
		resumebox.y = display.contentHeight/2 

	resumebtn = display.newImageRect("ui/pause/resumebtn.png", 60, 60)
		resumebtn.x = display.contentWidth/2
		resumebtn.y = display.contentHeight/2 + 20
		resumebtn:addEventListener("tap", resumeGame)

	resumeText = display.newText("CONTINUAR", 0, 0, "zorque.ttf", 35)
	resumeText:setFillColor(0.2)
	resumeText.x = display.contentWidth/2 
	resumeText.y = 130

end

function lvl:createPlayer(playerSheet, sequence)
	
	local normalOptions =
	{
		width = 47,
		height = 69,
		numFrames = 5
	}

	local crowlingOptions =
	{
		width = 61,
		height = 46,
		numFrames = 4
	}

	local sheet_player
	local player 

	if(sequence == "crowling") then
		local sequencesPlayer = {{
			name = "crowling",
			start = 1,
			count = 4,
			time = 400,
			loopCount = 0,
			loopDirection = "forward"
		}}

		sheet_player = graphics.newImageSheet(playerSheet, crowlingOptions)	
		player = display.newSprite(sheet_player, sequencesPlayer)		
	else
		local sequencesPlayer = {{
			name = "normalRun",
			start = 1,
			count = 4,
			time = 400,
			loopCount = 0,
			loopDirection = "forward"
		},
		{
			name = "jumping",
			start = 5,
			count = 1,
			time = 400,
			loopCount = 0,
			loopDirection = "forward"
		}}
		sheet_player = graphics.newImageSheet(playerSheet, normalOptions)
		player = display.newSprite(sheet_player, sequencesPlayer)			
	end
	player.name = 'JOGADOR'
	player.x = 80
	player.y = 250
	player.isFixedRotation=true
	player:setSequence("normalRun")
	player:play()	

	return player
end

function lvl:buildPause(player)
		local pausebtn = display.newImageRect("ui/pause/pausebtn.png", 30, 30)
		pausebtn.x = display.contentWidth
		pausebtn.y = 25
		pausebtn:addEventListener("tap", pauseGame)
		playerT = player
		print('---JOGADOR')
		print(playerT)
		headerGroup:insert(pausebtn)
end

function lvl:buildHeader(healthBoolean, happinessBoolean, moneyBoolean, weddingBoolean)
	headerGroup = display.newGroup()
	local header = display.newRect( 0, 0, display.contentWidth+100, 100 )
		header.x = display.contentWidth/2
		header.y = 0
		header:setFillColor(1, 0.75, 0.14)
		headerGroup:insert(header)

	if(healthBoolean == true) then
		healthText = display.newText(health .. "%", 0, 0, "zorque.ttf", 30)
		healthText.x = 45
		healthText.y = 25
		headerGroup:insert(healthText)

		local healthIcon = display.newImageRect("ui/adult/health.png", 20, 20)
		healthIcon.x = -10
		healthIcon.y = 25
		headerGroup:insert(healthIcon)
	end

	if(happinessBoolean == true) then
		happinessText = display.newText(happiness .. "%", 0, 0, "zorque.ttf", 30)
		happinessText.x = 165
		happinessText.y = 25
		headerGroup:insert(happinessText)

		local happinessIcon = display.newImageRect("ui/adult/happiness.png", 20, 20)
		happinessIcon.x = 110
		happinessIcon.y = 25
		headerGroup:insert(happinessIcon)
	end

	if(moneyBoolean == true) then
		moneyText = display.newText(money .. "%", 0, 0, "zorque.ttf", 30)
		moneyText.x = 285
		moneyText.y = 25
		headerGroup:insert(moneyText)

		local moneyIcon = display.newImageRect("ui/adult/money.png", 20, 20)
		moneyIcon.x = 230
		moneyIcon.y = 25
		headerGroup:insert(moneyIcon)
	end

	if(weddingBoolean == true) then
		weddingText = display.newText(wedding .. "%", 0, 0, "zorque.ttf", 30)
		weddingText.x = 400
		weddingText.y = 25
		headerGroup:insert(weddingText)

		local weddingIcon = display.newImageRect("ui/adult/wedding.png", 20, 20)
		weddingIcon.x = 350
		weddingIcon.y = 25
		headerGroup:insert(weddingIcon)
	end

	return headerGroup
end

function lvl:createScoreProjectiles()
	numShoots = display.newText("x" .. numProjectile, 0, 0, "zorque.ttf", 30)
	numShoots.x = display.contentCenterX + 180
	numShoots.y = display.contentHeight-20
	uiGroup:insert(numShoots)
	return numShoots
end

function lvl:createScoreMeters()
	scoreMeters = display.newText("score:  " .. meters, 0, 0, "zorque.ttf", 30)
	scoreMeters.x = display.contentCenterX
	scoreMeters.y = display.contentHeight-20
	uiGroup:insert(scoreMeters)
	return scoreMeters
end

function lvl:addMeters()
	meters = meters + 1;
	scoreMeters.text = "Score:  " .. meters
end

function lvl:addProjectiles(score)
	numProjectile = numProjectile + score
	numShoots.text = "x" .. numProjectile	
end

function lvl:reduceProjectiles(score)
	numProjectile = numProjectile - score
	numShoots.text = "x" .. numProjectile	
end

function lvl:getNumProjectiles()
	return numProjectile
end

function lvl:addHealth(score)
	health = health + score
	healthText.text = health .. "%"
end

function lvl:reduceHealth(score)
	health = health - score
	healthText.text = health .. "%"
end

function lvl:addMoney(score)
	money = money + score
	moneyText.text = money .. "%"
end

function lvl:reduceMoney(score)
	money = money - score
	moneyText.text = money .. "%"
end

function lvl:addHappiness(score)
	happiness = happiness + score
	happinessText.text = happiness .. "%"
end

function lvl:reduceHappiness(score)
	happiness = happiness - score
	happinessText.text = happiness .. "%"
end

function lvl:isAlive()
	if( health>0 and happiness>0 and money>0) then
		return true
	else
		return false
	end
end

function lvl:setValues(healthValue, moneyValue, happinessValue, weddingValue)
	health = healthValue
	money = moneyValue
	happiness = happinessValue
	wedding = weddingValue
end

function lvl:createBackground(currentLevel)
	local backGroup = display.newGroup()

	background = display.newImageRect(backGroup, base.levels[currentLevel].background, 600, 250 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	backGroup:insert(background)

	local aux1 = math.random(1, base.levels[currentLevel].numBackgroundsNear)	
	backgroundnear1 = display.newImage(base.levels[currentLevel].backgroundNear[aux1].path)
	backgroundnear1.y = base.levels[currentLevel].backgroundNear[aux1].y
	backgroundnear1.x = 240
	
	backGroup:insert(backgroundnear1)

	local aux2 = math.random(1, base.levels[currentLevel].numBackgroundsNear)
	
	backgroundnear2 = display.newImage(base.levels[currentLevel].backgroundNear[aux2].path)
	backgroundnear2.x = 760
	backgroundnear2.y = base.levels[currentLevel].backgroundNear[aux2].y
	backGroup:insert(backgroundnear2)

	return backGroup

end

function lvl:updateBackground(currentLevel)
	local backGroup = display.newGroup()

	backgroundnear1.x = backgroundnear1.x - (speed/5)

	if(backgroundnear1.x < -239) then
		local aux1 = math.random(1, base.levels[currentLevel].numBackgroundsNear)
		backgroundnear1:removeSelf()
		backgroundnear1 = display.newImage(base.levels[currentLevel].backgroundNear[aux1].path)
		backgroundnear1.y = base.levels[currentLevel].backgroundNear[aux1].y
		backgroundnear1.x = 760
		
		backGroup:insert(backgroundnear1)
	end

	backgroundnear2.x = backgroundnear2.x - (speed/5)
	if(backgroundnear2.x < -239) then
		local aux2 = math.random(1, base.levels[currentLevel].numBackgroundsNear)
		backgroundnear2:removeSelf()
		backgroundnear2 = display.newImage(base.levels[currentLevel].backgroundNear[aux2].path)
		backgroundnear2.y = base.levels[currentLevel].backgroundNear[aux2].y
		backgroundnear2.x = 760
		
		backGroup:insert(backgroundnear2)
	end

	return backGroup
end

function lvl:createFloor(groundImg)
	floorGroup = display.newGroup()
	local groundMin = 300
	local groundMax = 340
	local groundLevel = groundMin
	 
	for a = 1, 8, 1 do
		--AQUI GERAMOS O NOSSO CHÃO
		local newBlock
		newBlock = display.newImage(groundImg)
		newBlock.name = "CHAO"
		-- REPOSICIONANDO O CHÃO
		newBlock.x = (a * 79) - 85
		newBlock.y = groundLevel
		physics.addBody(newBlock, "static",  { density = 0, friction = 0, bounce = 0 })
		floorGroup:insert(newBlock)
	end

	return floorGroup
end

function lvl:createObstacle(currentLevel)

	local yVal = math.random(100, display.contentHeight-80)
	local numObst = math.random(1, base.levels[currentLevel].numObstacles)
	
	obstacles[obstaclesCounter] = display.newImageRect(base.levels[currentLevel].obstacles[numObst].path, 60, 60)
	obstacles[obstaclesCounter].x = display.contentWidth + 50
	obstacles[obstaclesCounter].y = yVal
	obstacles[obstaclesCounter].name = "OBSTACLE"
	obstacles[obstaclesCounter].id = obstaclesCounter
	physics.addBody(obstacles[obstaclesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })

	obstaclesCounter = obstaclesCounter + 1
	return obstacles[obstaclesCounter - 1]
end
function lvl:createObstacle(currentLevel)

	local yVal = math.random(100, display.contentHeight-80)
	local numObst = math.random(1, base.levels[currentLevel].numObstacles)
	
	obstacles[obstaclesCounter] = display.newImageRect(base.levels[currentLevel].obstacles[numObst].path, 60, 60)
	obstacles[obstaclesCounter].x = display.contentWidth + 50
	obstacles[obstaclesCounter].y = yVal
	obstacles[obstaclesCounter].name = "OBSTACLE"
	obstacles[obstaclesCounter].type = base.levels[currentLevel].obstacles[numObst].type	
	obstacles[obstaclesCounter].id = obstaclesCounter
	physics.addBody(obstacles[obstaclesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })

	obstaclesCounter = obstaclesCounter + 1
	return obstacles[obstaclesCounter - 1]
end

function lvl:moveObstacles()
	for a = 0, obstaclesCounter, 1 do
		if obstacles[a] ~= nil and obstacles[a].x ~= nil then
			if obstacles[a].x < -100 then
				obstaclesDisappear = obstaclesDisappear + 1
				timer.performWithDelay(1, function()
					obstacles[a] = nil;
				end, 1)
			else
				obstacles[a].x = obstacles[a].x  - (5/2) -- spped/2
			end
		end
	end
end

function lvl:collideCollectible()
	obstaclesDisappear = obstaclesDisappear + 1
end

function lvl:collideObstacle()
	obstaclesDisappear = obstaclesDisappear + 1
end

function lvl:createCollectible(currentLevel)
	local yVal = math.random(100, display.contentHeight-80)
	
	local numColl = math.random(1, base.levels[currentLevel].numCollectibles)
	
	collectibles[collectiblesCounter] = display.newImageRect(base.levels[currentLevel].collectibles[numColl].path, 60, 60)
	collectibles[collectiblesCounter].x = display.contentWidth + 50
	collectibles[collectiblesCounter].y = yVal
	collectibles[collectiblesCounter].name = "COLECIONAVEL"
	collectibles[collectiblesCounter].type = base.levels[currentLevel].collectibles[numColl].type
	collectibles[collectiblesCounter].id = collectiblesCounter
	physics.addBody(collectibles[collectiblesCounter], "kinematic",  { isSensor = true, gravity = 0, density=0.0 })
	
	collectiblesCounter = collectiblesCounter + 1

	return collectibles[collectiblesCounter - 1]
end

function lvl:moveCollectibles()
	for a = 0, collectiblesCounter, 1 do
		if collectibles[a] ~= nil and collectibles[a].x ~= nil then
			if collectibles[a].x < -100 then
				collectiblesDisappear = collectiblesDisappear + 1
				timer.performWithDelay(1, function()
					collectibles[a] = nil;
				end, 1)
			else
				collectibles[a].x = collectibles[a].x  - (5/2)  -- spped/2
			end
		end
	end
end

function lvl:getMeters()
	return meters
end

function lvl:getCurrentLevel()
	return currentLevel
end

function lvl:setCurrentLevel(numCurrent)
	currentLevel = numCurrent
end

function lvl:getJumpLimit()
	return jumpLimit
end

function lvl:setJumpLimit(num)
	jumpLimit = jumpLimit
end

function lvl:destroy()
	display.remove(collectGroup)
	obstacles = {}
	collectibles = {}
	collectiblesCounter = 0
	obstaclesCounter = 0
	score = 0
end


return lvl
