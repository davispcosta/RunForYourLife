local composer = require("composer")
local base = require( "base")
local sounds = require( "soundsfile" )

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


local months = 0
local years = 0
local scoreAge
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
	display.remove(pauseGroup)
	gamePaused = false
end

function pauseGame()
	gamePaused = true
	playerT:pause()
	physics.pause()
	timer.pause(movementLoop)
	timer.pause(emergeLoop)
	pauseGroup = display.newGroup()

	pauserect = display.newRect(0, 0, display.contentWidth+100, 640)
	pauserect.x = display.contentWidth/2
	pauserect:setFillColor(0)
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)
	pauseGroup:insert(pauserect)

	resumebox = display.newImageRect("ui/menu/box.png", display.contentWidth/2+200, display.contentHeight/2+100 )
		resumebox.x = display.contentWidth/2
		resumebox.y = display.contentHeight/2
		pauseGroup:insert(resumebox)

	resumebtn = display.newImageRect("ui/pause/resumebtn.png", 50, 50)
		resumebtn.x = display.contentWidth/2 - 150
		resumebtn.y = 100
		resumebtn:addEventListener("tap", resumeGame)
		pauseGroup:insert(resumebtn)

	resumeText = display.newText("CONTINUAR", 0, 0, "zorque.ttf", 25)
	resumeText:setFillColor(0.2)
	resumeText.x = display.contentWidth/2  - 40
	resumeText.y = 100
	pauseGroup:insert(resumeText)

	musicText = display.newText("Música", 0, 0, "zorque.ttf", 20)
	musicText:setFillColor(0.2)
	musicText.x = display.contentWidth/2 - 50
	musicText.y = 140
	pauseGroup:insert(musicText)
	
	local musicon = display.newImageRect("ui/menu/soundson.png", 70, 30)
	musicon.x = display.contentWidth/2+50
	musicon.y = display.contentHeight/2 - 20
	pauseGroup:insert(musicon)
	local musicoff = display.newImage("ui/menu/soundsoff.png", 70, 30)
	musicoff.x = display.contentWidth/2+50
	musicoff.y = display.contentHeight/2 - 20
	musicoff.isVisible = false
	pauseGroup:insert(musicoff)
		
	local function onTap( self, event )
		musicon.isVisible = not musicon.isVisible
		musicoff.isVisible = not musicoff.isVisible
		if(musicon.isVisible) then
			musicon.width = 70
			musicon.height = 30
		else 
			musicoff.width = 70
			musicoff.height = 30
		end
		return true
	end 
	musicon:addEventListener( "tap", onTap )
	musicoff:addEventListener( "tap", onTap )

	soundText = display.newText("Sons", 0, 0, "zorque.ttf", 20)
	soundText:setFillColor(0.2)
	soundText.x = display.contentWidth/2 - 50
	soundText.y = 180
	pauseGroup:insert(soundText)

	local soundon = display.newImageRect("ui/menu/soundson.png", 70, 30)
	soundon.x = display.contentWidth/2+50
	soundon.y = display.contentHeight/2 + 20
	pauseGroup:insert(soundon)
	
	local soundoff = display.newImage("ui/menu/soundsoff.png", 70, 30)
	soundoff.x = display.contentWidth/2+50
	soundoff.y = display.contentHeight/2 + 20
	soundoff.isVisible = false
	pauseGroup:insert(soundoff)
	
	local function onTap( self, event )
		soundon.isVisible = not soundon.isVisible
		soundoff.isVisible = not soundoff.isVisible
		if(soundon.isVisible) then
			soundon.width = 70
			soundon.height = 30
		else 
			soundoff.width = 70
			soundoff.height = 30
		end
		
		return true
	end 
	soundon:addEventListener( "tap", onTap )
	soundoff:addEventListener( "tap", onTap )

	languageText = display.newText("Idioma", 0, 0, "zorque.ttf", 20)
	languageText:setFillColor(0.2)
	languageText.x = display.contentWidth/2 - 50
	languageText.y = 220
	pauseGroup:insert(languageText)

	local englishon = display.newImageRect("ui/menu/englishon.png", 70, 30)
	englishon.x = display.contentWidth/2+50
	englishon.y = display.contentHeight/2 + 60
	pauseGroup:insert(englishon)
	
	local portugueseon = display.newImage("ui/menu/portugueseon.png", 70, 30)
	portugueseon.x = display.contentWidth/2+50
	portugueseon.y = display.contentHeight/2 + 60
	portugueseon.isVisible = false
	pauseGroup:insert(portugueseon)
		
	local function onTap( self, event )
		portugueseon.isVisible = not portugueseon.isVisible
		englishon.isVisible = not englishon.isVisible
		if(portugueseon.isVisible) then
			portugueseon.width = 70
			portugueseon.height = 30
		else 
			englishon.width = 70
			englishon.height = 30
		end
		
		return true
	end 
	portugueseon:addEventListener( "tap", onTap )
	englishon:addEventListener( "tap", onTap )
		
	menubtn = display.newImageRect("ui/menu/backbtn.png", 120, 40)
	menubtn.x = display.contentWidth/2 + 180
	menubtn.y = display.contentHeight/2 + 110
	pauseGroup:insert(menubtn)
	menubtn:addEventListener("tap", function()
		display.remove(pauseGroup)		
		composer.gotoScene("scene.menu")
	end
	)
end

function lvl:createPlayer(playerSheet, sequence)
	
	local normalOptions =
	{
		width = 48,
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
	player.x = 130
	player.y = 250
	player:setSequence("normalRun")
	player:play()	

	playerT = player
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
		header:setFillColor(0.607, 0.164, 0.580)
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

function lvl:createScoreAge()
	scoreAge = display.newText(months .. " Meses", 0, 0, "zorque.ttf", 30)
	scoreAge.x = display.contentCenterX
	scoreAge.y = display.contentHeight-20
	if(months == 12) then
		years = years + 1
		months = 0
	end
	yearText = ""
	monthText = ""
	if(years > 0 )then
		if years == 1 then
			yearText = years .." Ano e "
		else 
			yearText = years .." Anos e "
		end	
	end
	if months == 1 then
		monthText = months .. " Mês"
	else 
		monthText = months .. " Meses"
	end
	scoreAge.text = yearText .. monthText
	uiGroup:insert(scoreAge)
	return scoreAge
end

function lvl:addAge()
	months = months + 1;
	if(months == 12) then
		years = years + 1
		months = 0
	end
	yearText = ""
	monthText = ""
	if(years > 0 )then
		if years == 1 then
			yearText = years .." Ano e "
		else 
			yearText = years .." Anos e "
		end	
	end
	if months == 1 then
		monthText = months .. " Mês"
	else 
		monthText = months .. " Meses"
	end
	scoreAge.text = yearText .. monthText

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
	print( "--- ENTROU FUNC ---" )
	health = health - score
	healthText.text = health .. "%"
	print( "--- FUNC REDHEL ---" )
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
	 
	for a = 1, 9, 1 do
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

function lvl:moveFloor(blocks)
	for a = 1, blocks.numChildren, 1 do
		
	   if(a > 1) then
	   		newX = (blocks[a - 1]).x + 79
	   else
			newX = (blocks[9]).x + 70
	   end
		
	   if((blocks[a]).x < -80) then
	   		(blocks[a]).x, (blocks[a]).y = newX, 300
	   else
	   		(blocks[a]):translate(-5, 0)
	   end
		
	end
end

function lvl:createObstacle(currentLevel)

	local yVal = math.random(100, display.contentHeight-80)
	local numObst = math.random(1, base.levels[currentLevel].numObstacles)
	
	obstacles[obstaclesCounter] = display.newImageRect(base.levels[currentLevel].obstacles[numObst].path, 55, 55)
	obstacles[obstaclesCounter].x = display.contentWidth + 50
	obstacles[obstaclesCounter].y = yVal
	obstacles[obstaclesCounter].name = "OBSTACLE"
	obstacles[obstaclesCounter].id = obstaclesCounter
	obstacles[obstaclesCounter].type = base.levels[currentLevel].obstacles[numObst].type		
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
	
	collectibles[collectiblesCounter] = display.newImageRect(base.levels[currentLevel].collectibles[numColl].path, 55, 55)
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

function lvl:getYears()
	return years
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

function lvl:celebratePlayer(playerOld, playerNew)
	playerOld:removeSelf()

	local celebratingOptions =
	{
		width = 60,
		height = 69,
		numFrames = 4
	}

	local sheet_player
	local player 

	local sequencesPlayer = {{
		name = "celebrating",
		start = 1,
		count = 4,
		time = 400,
		loopCount = 1,
		loopDirection = "forward"
	}}

	sheet_player = graphics.newImageSheet(playerNew, celebratingOptions)	
	player = display.newSprite(sheet_player, sequencesPlayer)		
	
	player.name = 'JOGADOR'
	player.x = 130
	player.y = 250
	player:setSequence("celebrating")
	player:play()	

	playerT = player
	return player
end


return lvl
