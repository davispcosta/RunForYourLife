
-- Include modules/libraries
local composer = require( "composer")
local widget = require( "widget" )
local sounds = require( "soundsfile" )

-- Create a new Composer scene
local scene = composer.newScene()

local function gotoMenu()
	composer.gotoScene( "scene.menu" )
end

function scene:create( event )

	local sceneGroup = self.view

	playgameMusic(adultbgmusic)
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "ui/gameover/background.png", 600, 400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local backButton = display.newImageRect( sceneGroup, "ui/gameover/backbtn.png", 200, 65 )
	backButton.x = display.contentCenterX 
	backButton.y = display.contentCenterY + 100

	backButton:addEventListener( "tap", gotoMenu )
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