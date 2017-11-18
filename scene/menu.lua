

-- Include modules/libraries
local composer = require( "composer")
local loadsave = require( "loadsave")

composer.recycleOnSceneChange = true

local physics = require("physics")
local widget = require( "widget" )
local sounds = require( "soundsfile" )
local base = require( "base")

-- Create a new Composer scene
local scene = composer.newScene()
local movementCloudLoop
local movementStar01Loop
local movementStar02Loop
local movementStar03Loop

local function gotoGame()
	playSFX(menupicksound)
	composer.gotoScene( "scene.babyLevel" )
end

local function openLevels()
	playSFX(menupicksound)
	composer.gotoScene( "scene.levels" )
end

local function openTutorial()
	playSFX(menupicksound)
	composer.gotoScene( "scene.tutorial" )
end

local function openAchievements()
	playSFX(menupicksound)	
	achievementsGroup = display.newGroup()

	pauserect = display.newRect(0, 0, display.contentWidth+100, 640)
	pauserect.x = display.contentWidth/2
	pauserect:setFillColor(0,0,0)
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)
	achievementsGroup:insert(pauserect)

	resumebox = display.newImageRect("ui/menu/box.png", 680, 320)
	resumebox.x = display.contentWidth/2
	resumebox.y = display.contentHeight/2 
	achievementsGroup:insert(resumebox)

	titleText = display.newText("ACHIEVEMENTS", 0, 0, "zorque.ttf", 30)
	titleText:setFillColor(0.2)
	titleText.x = 100
	titleText.y = 70
	achievementsGroup:insert(titleText)

	backbtn = display.newImageRect("ui/menu/backbtn.png", 120, 40)
	backbtn.x = display.contentWidth/2 + 200
	backbtn.y = 70
	achievementsGroup:insert(backbtn)
	backbtn:addEventListener("tap", function()
		display.remove(achievementsGroup)
	end
	)

	local scrollView = widget.newScrollView{
		left = -50,
		leftPadding = 50,
		top = 90,
		width = display.contentWidth+100,
		height = display.contentHeight/2,
		horizontalScrollDisabled = false ,
		hideBackground = true,
		verticalScrollDisabled = true ,
	}
	local xPos = 85
	local yPos = 120
	for i = 1, base.numAchievements do 		
		rect = display.newRect(xPos, yPos, 150, 200)
		achievementsGroup:insert(rect)
		scrollView:insert(rect);
		achievementsGroup:insert(scrollView)
		
		icon = display.newImageRect("ui/collect/star.png", 50, 50)
		icon.x = xPos 
		icon.y = yPos - 50
		scrollView:insert(icon)
		
		titleText = display.newText(base.achievements[i].title, xPos, yPos, "zorque.ttf", 15)
		titleText:setFillColor(0.2)
		achievementsGroup:insert(titleText)
		scrollView:insert(titleText)

		descriptionText = display.newText(base.achievements[i].description, xPos, yPos+15, "zorque.ttf", 5)
		descriptionText:setFillColor(0.2)
		achievementsGroup:insert(descriptionText)
		scrollView:insert(descriptionText)
		
		xPos = xPos + 200
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
	creditsbtn:addEventListener("tap", function()
		composer.gotoScene( "scene.credits" )
	end
	)

	musicText = display.newText("Música", 0, 0, "zorque.ttf", 20)
	musicText:setFillColor(0.2)
	musicText.x = display.contentWidth/2 - 50
	musicText.y = 120
	settingGroup:insert(musicText)

	local musicon = display.newImageRect("ui/menu/soundson.png", 70, 30)
	musicon.x = display.contentWidth/2+50
	musicon.y = display.contentHeight/2 - 40
	musicon.width = 70
	musicon.height = 30
	settingGroup:insert(musicon)
	local musicoff = display.newImage("ui/menu/soundsoff.png", 70, 30)
	musicoff.width = 70
	musicoff.height = 30
	musicoff.x = display.contentWidth/2+50
	musicoff.y = display.contentHeight/2 - 40
	settingGroup:insert(musicoff)
	if(loadedSettings.musicOn == true) then
		musicon.isVisible = true
		musicoff.isVisible = false
	else
		musicon.isVisible = false
		musicoff.isVisible = true
	end
	
local function onTap( self, event )
		musicon.isVisible = not musicon.isVisible
		musicoff.isVisible = not musicoff.isVisible
		if(musicon.isVisible) then
			loadedSettings.musicOn = true
			audio.setVolume( 0.75, { channel=1 } )			
		else 
			loadedSettings.musicOn = false
			audio.setVolume( 0, { channel=1 } )			
		end
		loadsave.saveTable(loadedSettings, "settings.json")
	end 
	musicon:addEventListener("tap", onTap )
	musicoff:addEventListener("tap", onTap )

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


function scene:create(event)

	local sceneGroup = self.view
	physics:start()
	
	playGameMusic(menubgmusic)
	
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
	local bubble01 = display.newImageRect(sceneGroup, "ui/collect/bubble.png",30, 30)
	bubble01.x = display.contentCenterX  + 170
	bubble01.y = display.contentCenterY - 100

	local star02 = display.newImageRect(sceneGroup, "ui/collect/star.png",60, 60)
	star02.x = display.contentCenterX  + 220
	star02.y = display.contentCenterY + 30
	local bubble02 = display.newImageRect(sceneGroup, "ui/collect/bubble.png",60, 60)
	bubble02.x = display.contentCenterX  + 220
	bubble02.y = display.contentCenterY + 30

	local star03 = display.newImageRect(sceneGroup, "ui/collect/star.png",60, 60)
	star03.x = 50
	star03.y = display.contentCenterY
	local bubble03 = display.newImageRect(sceneGroup, "ui/collect/bubble.png",60, 60)
	bubble03.x = 50
	bubble03.y = display.contentCenterY

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

	local helpButton = display.newImageRect( sceneGroup, "ui/menu/helpbtn.png", 40, 40 )
	helpButton.x = display.contentWidth
	helpButton.y = 50

	playButton:addEventListener( "tap", gotoGame )
	lvlButton:addEventListener("tap", openLevels)
	achievementButton:addEventListener("tap", openAchievements)
	settingsButton:addEventListener("tap", openSettings)
	helpButton:addEventListener("tap", openTutorial)

	local countMoveStar01 = 0
	downStar01 = true
	local function moveStar01()

		if countMoveStar01 == 20 then
			downStar01 = false
		end
		
		if countMoveStar01 == 0 then
			downStar01 = true
		end

		if downStar01 == true then
			star01.y = star01.y + 1
			star01.x = star01.x + 0.5
			bubble01.y = bubble01.y + 1
			bubble01.x = bubble01.x + 0.5
				
			countMoveStar01 = countMoveStar01 + 1
		else
			star01.y = star01.y - 1
			star01.x = star01.x - 0.5
			bubble01.y = bubble01.y - 1				
			bubble01.x = bubble01.x - 0.5
			countMoveStar01 = countMoveStar01 - 1
		end
	end
	movementStar01Loop = timer.performWithDelay(40, function()
		moveStar01()
	end, -1)
	bubble01:addEventListener("tap", function()
		playSFX(bubblepop)
		bubble01:removeSelf()
		timer.cancel(movementStar01Loop)
		physics.addBody(star01, "dynamic", { density = 0, gravityScale=0})
		star01:setLinearVelocity(0, -200)
	end)

	local countMoveStar02 = 0
	downStar02 = true
	local function moveStar02()

		if countMoveStar02 == 20 then
			downStar02 = false
		end
		
		if countMoveStar02 == 0 then
			downStar02 = true
		end

		if downStar02 == true then
			star02.y = star02.y - 1
			bubble02.y = bubble02.y - 1
			countMoveStar02 = countMoveStar02 + 1
		else
			star02.y = star02.y + 1
			bubble02.y = bubble02.y + 1
			countMoveStar02 = countMoveStar02 - 1
		end
	end
	movementStar02Loop = timer.performWithDelay(60, function()
		moveStar02()
	end, -1)
	bubble02:addEventListener("tap", function()
		playSFX(bubblepop)		
		bubble02:removeSelf()
		timer.cancel(movementStar02Loop)
		physics.addBody(star02, "dynamic", { density = 1, gravityScale=0})
		star02:setLinearVelocity(0, -200)
	end)

	local countMoveStar03 = 0
	downStar03 = true
	local function moveStar03()

		if countMoveStar03 == 20 then
			downStar03 = false
		end
		
		if countMoveStar03 == 0 then
			downStar03 = true
		end

		if downStar03 == true then
			star03.y = star03.y + 1
			star03.x = star03.x + 0.5
			bubble03.y = bubble03.y + 1
			bubble03.x = bubble03.x + 0.5
			countMoveStar03 = countMoveStar03 + 1
		else
			star03.y = star03.y - 1
			star03.x = star03.x - 0.5
			bubble03.y = bubble03.y - 1
			bubble03.x = bubble03.x - 0.5
			countMoveStar03 = countMoveStar03 - 1
		end
	end
	movementStar03Loop = timer.performWithDelay(50, function()
		moveStar03()
	end, -1)
	bubble03:addEventListener("tap", function()
		playSFX(bubblepop)		
		bubble03:removeSelf()
		timer.cancel(movementStar03Loop)
		physics.addBody(star03, "dynamic", { density = 1, gravityScale=0})
		star03:setLinearVelocity(0, -200)
	end)

	local countMoveClouds = 0
	downClouds = true
	local function moveClouds()

		if countMoveClouds == 20 then
			downClouds = false
		end
		
		if countMoveClouds == 0 then
			downClouds = true
		end

		if downClouds == true then
			cloud01.y = cloud01.y + 1
			cloud02.y = cloud02.y - 1
			
			countMoveClouds = countMoveClouds + 1
		else
			cloud01.y = cloud01.y - 1
			cloud02.y = cloud02.y + 1
			
			countMoveClouds = countMoveClouds - 1
		end
	end
	movementCloudLoop = timer.performWithDelay(100, function()
		moveClouds()
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
		timer.cancel(movementCloudLoop)
		timer.cancel(movementStar01Loop)
		timer.cancel(movementStar02Loop)
		timer.cancel(movementStar03Loop)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene("menu")
		composer.hideOverlay()
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