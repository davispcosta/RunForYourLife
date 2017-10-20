

-- Include modules/libraries
local composer = require( "composer")
local widget = require( "widget" )
local sounds = require( "soundsfile" )

-- Create a new Composer scene
local scene = composer.newScene()

local function gotoGame()
	playSFX(menupicksound)
	composer.gotoScene( "scene.babyLevel" )
end

local function openlevels()
	playSFX(menupicksound)
	composer.gotoScene( "scene.levels" )
end

local function openOptions()
	playSFX(menupicksound)
	resumebox = display.newRect( 0, 0, display.contentWidth/2, display.contentHeight/2 )
		resumebox.x = display.contentWidth/2
		resumebox.y = display.contentHeight/2 
		resumebox:setFillColor(1, 1, 1)

	resumebtn = display.newImageRect("ui/menu/resumebtn.png", 60, 60)
		resumebtn.x = display.contentWidth/2
		resumebtn.y = display.contentHeight/2 
end


function scene:create( event )

	local sceneGroup = self.view
	
	playgameMusic(menubgmusic)
	
	local background = display.newImageRect( sceneGroup, "ui/menu/background.png", 580, 300 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "ui/logo.png", 230, 180)
	title.x = display.contentCenterX - 110
	title.y = display.contentCenterY

	local playButton = display.newImageRect( sceneGroup, "ui/menu/playbtn.png", 150, 50 )
	playButton.x = display.contentCenterX + 120
	playButton.y = display.contentCenterY - 60

	local lvlButton = display.newImageRect( sceneGroup, "ui/menu/lvlbtn.png", 150, 50 )
	lvlButton.x = display.contentCenterX + 120
	lvlButton.y = display.contentCenterY

	local achievementButton = display.newImageRect( sceneGroup, "ui/menu/achievementbtn.png", 70, 50 )
	achievementButton.x = display.contentCenterX + 80
	achievementButton.y = display.contentCenterY + 60

	local settingsButton = display.newImageRect( sceneGroup, "ui/menu/settingsbtn.png", 70, 50 )
	settingsButton.x = display.contentCenterX + 160
	settingsButton.y = display.contentCenterY + 60

	playButton:addEventListener( "tap", gotoGame )
	lvlButton:addEventListener("tap", openlevels)
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
		-- Code here runs when the scene is on screen (but is about to go off screen)

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