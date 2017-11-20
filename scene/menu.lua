

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
	
	function musicon:tap(event)
		print("MUSICON TOUCH")
		loadedSettings.musicOn = false		
		musicon.isVisible = false
		musicoff.isVisible = true
		audio.setVolume(0, {channel = 1})
		loadsave.saveTable(loadedSettings, "settings.json")	
	end 
	musicon:addEventListener("tap", musicon )
	settingGroup:insert(musicon)
	
	
	function musicoff:tap(event)
		print("MUSICOFF TOUCH")
		loadedSettings.musicOn = true		
		musicon.isVisible = true
		musicoff.isVisible = false
		playGameMusic(menubgmusic)								
		audio.setVolume(0.75, {channel = 1})
		loadsave.saveTable(loadedSettings, "settings.json")		
	end 
	musicoff:addEventListener("tap", musicoff)

	soundText = display.newText("Sons", 0, 0, "zorque.ttf", 20)
	soundText:setFillColor(0.2)
	soundText.x = display.contentWidth/2 - 50
	soundText.y = 160
	settingGroup:insert(soundText)	

	local soundon = display.newImageRect("ui/menu/soundson.png", 70, 30)
	soundon.x = display.contentWidth/2+50
	soundon.y = display.contentHeight/2
	soundon.width = 70
	soundon.height = 30
	
	local soundoff = display.newImage("ui/menu/soundsoff.png", 70, 30)
	soundoff.x = display.contentWidth/2+50
	soundoff.y = display.contentHeight/2
	soundoff.width = 70
	soundoff.height = 30

	if(loadedSettings.soundOn == true) then
		soundon.isVisible = true
		soundoff.isVisible = false
	else
		soundon.isVisible = false
		soundoff.isVisible = true
	end
	
	function soundon:tap(event)
		loadedSettings.soundOn = false		
		soundon.isVisible = false
		soundoff.isVisible = true
		audio.setVolume(0, {channel = 2})
		loadsave.saveTable(loadedSettings, "settings.json")
	end 
	soundon:addEventListener("tap", soundon)
	settingGroup:insert(soundon)

	function soundoff:tap(event)
		loadedSettings.soundOn = true		
		soundon.isVisible = true
		soundoff.isVisible = false
		audio.setVolume(0.75, {channel = 2})
		loadsave.saveTable(loadedSettings, "settings.json")
	end 
	soundoff:addEventListener("tap", soundoff)	
	settingGroup:insert(soundoff)	
	
end


function scene:create(event)

	local sceneGroup = self.view
	physics:start()

	playGameMusic(menubgmusic)
	print("CREATE")
	
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

	local settingsButton = display.newImageRect( sceneGroup, "ui/menu/settingsbtn.png", 70, 50 )
	settingsButton.x = display.contentCenterX + 160
	settingsButton.y = display.contentCenterY + 100

	local helpButton = display.newImageRect( sceneGroup, "ui/menu/helpbtn.png", 70, 50 )
	helpButton.x = display.contentCenterX + 80
	helpButton.y = display.contentCenterY + 100

	playButton:addEventListener( "tap", gotoGame )
	lvlButton:addEventListener("tap", openLevels)
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