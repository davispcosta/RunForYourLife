local lvl = {}
local headerGroup = display.newGroup()
local uiGroup = display.newGroup()

local healthText
local health = 100
local happinessText
local happiness = 100
local money = 100
local wedding = 100

local meters = 0
local scoreMeters

local gamePaused = false
local playerT

function resumeGame()
	playerT:play()
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
	print('-JOGADOR')
	print(playerT)
	playerT:pause()
	physics.pause()
	timer.pause(movementLoop)
	timer.pause(emergeLoop)

	pauserect = display.newRect(0, 0, display.contentWidth+100, 640)
	pauserect.x = display.contentWidth/2
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)

	resumebox = display.newRect( 0, 0, display.contentWidth/2, display.contentHeight/2 )
		resumebox.x = display.contentWidth/2
		resumebox.y = display.contentHeight/2 
		resumebox:setFillColor(1, 1, 1)

	resumebtn = display.newImageRect("ui/menu/resumebtn.png", 60, 60)
		resumebtn.x = display.contentWidth/2
		resumebtn.y = display.contentHeight/2 
		resumebtn:addEventListener("tap", resumeGame)


end

function lvl:buildPause(player)
		local pausebtn = display.newImageRect("ui/menu/pausebtn.png", 30, 30)
		pausebtn.x = display.contentWidth
		pausebtn.y = 25
		pausebtn:addEventListener("tap", pauseGame)
		playerT = player
		print('---JOGADOR')
		print(playerT)
		headerGroup:insert(pausebtn)
end

function lvl:buildHeader(healthBoolean, happinessBoolean, moneyBoolean, weddingBoolean)

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

function lvl:createScoreMeters()
	scoreMeters = display.newText("score:  " .. meters, 0, 0, "zorque.ttf", 30)
	scoreMeters.x = display.contentWidth-100
	scoreMeters.y = display.contentHeight-30
	uiGroup:insert(scoreMeters)
	return scoreMeters
end

function lvl:addMeters()
	meters = meters + 1;
	scoreMeters.text = "Score:  " .. meters
end

function lvl:addHealth(score)
	health = health + score
	healthText.text = health .. "%"
end

function lvl:reduceHealth(score)
	health = health - score
	healthText.text = health .. "%"
end

function lvl:isAlive()
	if( health>0 and happiness>0 and money>0) then
		return true
	else
		return false
	end
end


return lvl
