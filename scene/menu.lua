

-- Include modules/libraries
local composer = require( "composer")
local widget = require( "widget" )
local sounds = require( "soundsfile" )
local base = require( "base")

-- Create a new Composer scene
local scene = composer.newScene()
local movementLoop

local function gotoGame()
	playSFX(menupicksound)
	composer.gotoScene( "scene.babyLevel" )
end

local function openLevels()
	playSFX(menupicksound)
	composer.gotoScene( "scene.levels" )
end

local function openAchievements()
	achievementsGroup = display.newGroup()
	
	pauserect = display.newRect(0, 0, display.contentWidth+100, 640)
	pauserect.x = display.contentWidth/2
	pauserect:setFillColor(0,0,0)
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)
	achievementsGroup:insert(pauserect)

	resumebox = display.newImageRect("ui/menu/box.png", 700, 400)
	resumebox.x = display.contentWidth/2
	resumebox.y = display.contentHeight/2 
	achievementsGroup:insert(resumebox)

	backbtn = display.newImageRect("ui/menu/backbtn.png", 120, 40)
	backbtn.x = display.contentWidth/2 - 100
	backbtn.y = display.contentHeight/2 + 110
	achievementsGroup:insert(backbtn)
	backbtn:addEventListener("tap", function()
		display.remove(achievementsGroup)
	end
	)

	local scrollView = widget.newScrollView{
		left = 10,
		top = 60,
		width = display.contentWidth,
		height = display.contentHeight/2,
		bottomPadding = 50,
		horizontalScrollDisabled = true ,
		verticalScrollDisabled = false ,
	}
	local xPos = 85
	local yPos = 120
	local cellCount = 0
	for i = 1, base.numAchievements do 
		if(cellCount == 3) then
			xPos = 85
			yPos = yPos + 100
			cellCount = 0
		end
		
		rect = display.newRect(xPos, yPos, 120, 50)
		achievementsGroup:insert(rect)
		scrollView:insert(rect);
		achievementsGroup:insert(scrollView)		
		
		titleText = display.newText(base.achievements[i].title, xPos, yPos, "zorque.ttf", 10)
		titleText:setFillColor(0.2)
		achievementsGroup:insert(titleText)
		scrollView:insert(titleText);
		
		descriptionText = display.newText(base.achievements[i].description, xPos, yPos+15, "zorque.ttf", 5)
		descriptionText:setFillColor(0.2)
		achievementsGroup:insert(descriptionText)
		scrollView:insert(descriptionText);
		
		xPos = xPos + 150
		cellCount = cellCount + 1		
	end
end

local function openSettings()
	playSFX(menupicksound)
	settingGroup = display.newGroup()

	pauserect = display.newRect(0, 0, display.contentWidth+100, 640)
	pauserect.x = display.contentWidth/2
	pauserect:setFillColor(0,0,0)
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)
	settingGroup:insert(pauserect)

	resumebox = display.newImageRect("ui/menu/box.png", 400, 200)
		resumebox.x = display.contentWidth/2
		resumebox.y = display.contentHeight/2 
		settingGroup:insert(resumebox)
		
	backbtn = display.newImageRect("ui/menu/backbtn.png", 120, 40)
	backbtn.x = display.contentWidth/2 - 100
	backbtn.y = display.contentHeight/2 + 110
	settingGroup:insert(backbtn)
	backbtn:addEventListener("tap", function()
		display.remove(settingGroup)
	end
	)

	creditsbtn = display.newImageRect("ui/menu/creditsbtn.png", 120, 40)
	creditsbtn.x = display.contentWidth/2 + 100
	creditsbtn.y = display.contentHeight/2 + 110
	settingGroup:insert(creditsbtn)

	musicText = display.newText("Música", 0, 0, "zorque.ttf", 20)
	musicText:setFillColor(0.2)
	musicText.x = display.contentWidth/2 - 50
	musicText.y = 120
	settingGroup:insert(musicText)

	local musicon = display.newImageRect("ui/menu/soundson.png", 70, 30)
	musicon.x = display.contentWidth/2+50
	musicon.y = display.contentHeight/2 - 40
	settingGroup:insert(musicon)
	local musicoff = display.newImage("ui/menu/soundsoff.png", 70, 30)
	musicoff.x = display.contentWidth/2+50
	musicoff.y = display.contentHeight/2 - 40
	settingGroup:insert(musicoff)
	musicoff.isVisible = false
		
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
	soundText.y = 160
	settingGroup:insert(soundText)	

	local soundon = display.newImageRect("ui/menu/soundson.png", 70, 30)
	soundon.x = display.contentWidth/2+50
	soundon.y = display.contentHeight/2
	settingGroup:insert(soundon)	
	
	local soundoff = display.newImage("ui/menu/soundsoff.png", 70, 30)
	soundoff.x = display.contentWidth/2+50
	soundoff.y = display.contentHeight/2
	soundoff.isVisible = false
	settingGroup:insert(soundoff)	
	
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
	languageText.y = 200
	settingGroup:insert(languageText)		

	local englishon = display.newImageRect("ui/menu/englishon.png", 70, 30)
	englishon.x = display.contentWidth/2+50
	englishon.y = display.contentHeight/2 + 40
	settingGroup:insert(englishon)		
	
	local portugueseon = display.newImage("ui/menu/portugueseon.png", 70, 30)
	portugueseon.x = display.contentWidth/2+50
	portugueseon.y = display.contentHeight/2 + 40
	settingGroup:insert(portugueseon)			
	portugueseon.isVisible = false
		
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
	
end


function scene:create( event )

	local sceneGroup = self.view
	
	playgameMusic(menubgmusic)
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, 580, 400 )
	background:setFillColor(0.39,0.78,0.81)
	sceneGroup:insert(background)

	local cloud01 = display.newImageRect(sceneGroup, "ui/menu/cloud01.png",580, 320)
	cloud01.x = display.contentCenterX 
	cloud01.y = display.contentCenterY

	local cloud02 = display.newImageRect(sceneGroup, "ui/menu/cloud02.png",580, 320)
	cloud02.x = display.contentCenterX 
	cloud02.y = display.contentCenterY + 20

	local star01 = display.newImageRect(sceneGroup, "ui/collect/star.png",30, 30)
	star01.x = display.contentCenterX  + 170
	star01.y = display.contentCenterY - 100

	local star02 = display.newImageRect(sceneGroup, "ui/collect/star.png",60, 60)
	star02.x = display.contentCenterX  + 220
	star02.y = display.contentCenterY + 30

	local star03 = display.newImageRect(sceneGroup, "ui/collect/star.png",60, 60)
	star03.x = 50
	star03.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "ui/menu/logo.png", 230, 180)
	title.x = display.contentCenterX 
	title.y = display.contentCenterY - 30

	local playButton = display.newImageRect( sceneGroup, "ui/menu/playbtn.png", 150, 50 )
	playButton.x = display.contentCenterX - 120
	playButton.y = display.contentCenterY + 100

	local lvlButton = display.newImageRect( sceneGroup, "ui/menu/lvlbtn.png", 70, 50 )
	lvlButton.x = display.contentCenterX
	lvlButton.y = display.contentCenterY + 100

	local achievementButton = display.newImageRect( sceneGroup, "ui/menu/achievementbtn.png", 70, 50 )
	achievementButton.x = display.contentCenterX + 80
	achievementButton.y = display.contentCenterY + 100

	local settingsButton = display.newImageRect( sceneGroup, "ui/menu/settingsbtn.png", 70, 50 )
	settingsButton.x = display.contentCenterX + 160
	settingsButton.y = display.contentCenterY + 100

	playButton:addEventListener( "tap", gotoGame )
	lvlButton:addEventListener("tap", openLevels)
	achievementButton:addEventListener("tap", openAchievements)
	settingsButton:addEventListener("tap", openSettings)

	local countMove = 0
	down = true
	local function moveObjects()

		if countMove == 20 then
			down = false
		end
		
		if countMove == 0 then
			down = true
		end

		if down == true then
			star01.y = star01.y + 1
			star01.x = star01.x + 0.5

			star02.y = star02.y - 1
			star02.x = star02.x - 0.5

			star03.y = star03.y - 1

			cloud01.y = cloud01.y + 1 
			cloud02.y = cloud02.y - 1

			countMove = countMove + 1
		else
			star01.y = star01.y - 1
			star01.x = star01.x - 0.5

			star02.y = star02.y + 1
			star02.x = star02.x + 0.5

			star03.y = star03.y + 1

			cloud01.y = cloud01.y - 1 
			cloud02.y = cloud02.y + 1

			countMove = countMove - 1
		end
	end
	movementLoop = timer.performWithDelay(50, function()
		moveObjects()
	end, -1)
	
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		timer.cancel(movementLoop)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
-- -----------------------------------------------------------------------------------



return scene