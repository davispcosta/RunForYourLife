-- Include modules/libraries
local composer = require( "composer")
local widget = require( "widget" )
local sounds = require( "soundsfile" )
local level = require("leveltemplate")
-- Create a new Composer scene
local scene = composer.newScene()

local mainGroup = display.newGroup()

function scene:create( event )

	local sceneGroup = self.view

	box = display.newImageRect("ui/menu/box.png", 600, 320)
		box.x = display.contentCenterX
		box.y = display.contentCenterY
    mainGroup:insert(box)

    developmentText = display.newText("Desenvolvimento e Design", 0, 0, "zorque.ttf", 30)
	developmentText:setFillColor(150/255, 114/255, 77/255)
	developmentText.x = display.contentWidth/2
	developmentText.y = 75
	mainGroup:insert(developmentText)	

	developerText = display.newText("Davi S. P. Costa", 0, 0, "zorque.ttf", 20)
	developerText:setFillColor(150/255, 114/255, 77/255)
	developerText.x = display.contentWidth/2 
	developerText.y = 100
    mainGroup:insert(developerText)
    
    supportText = display.newText("Apoio", 0, 0, "zorque.ttf", 30)
	supportText:setFillColor(150/255, 114/255, 77/255)
	supportText.x = display.contentWidth/2
	supportText.y = 150
	mainGroup:insert(supportText)	

	friendsText = display.newText("Adriano Augusto | Emerson Araujo | Christian Nogueira", 0, 0, "zorque.ttf", 15)
	friendsText:setFillColor(150/255, 114/255, 77/255)
	friendsText.x = display.contentWidth/2
	friendsText.y = 180
    mainGroup:insert(friendsText)
    
    friendsText = display.newText("Synara Soares | Eduardo Campos | Dario Gabriel", 0, 0, "zorque.ttf", 15)
	friendsText:setFillColor(150/255, 114/255, 77/255)
	friendsText.x = display.contentWidth/2
	friendsText.y = 195
	mainGroup:insert(friendsText)
    
    friendsText = display.newText("Manoel Silva | Iago Santos | Madson Chavante", 0, 0, "zorque.ttf", 15)
	friendsText:setFillColor(150/255, 114/255, 77/255)
	friendsText.x = display.contentWidth/2
	friendsText.y = 210
	mainGroup:insert(friendsText)
	
	soundText = display.newText("Som e Música", 0, 0, "zorque.ttf", 30)
	soundText:setFillColor(150/255, 114/255, 77/255)
	soundText.x = display.contentWidth/2 - 150
	soundText.y = 240
	mainGroup:insert(soundText)

	siteText = display.newText("opengameart.org", 0, 0, "zorque.ttf", 15)
	siteText:setFillColor(150/255, 114/255, 77/255)
	siteText.x = display.contentWidth/2 - 150
	siteText.y = 265
	mainGroup:insert(siteText)

	soundText = display.newText("Fonte", 0, 0, "zorque.ttf", 30)
	soundText:setFillColor(150/255, 114/255, 77/255)
	soundText.x = display.contentWidth/2 + 130
	soundText.y = 240
	mainGroup:insert(soundText)

	siteText = display.newText("1001freefonts.com/zorque.font", 0, 0, "zorque.ttf", 15)
	siteText:setFillColor(150/255, 114/255, 77/255)
	siteText.x = display.contentWidth/2 + 130
	siteText.y = 265
	mainGroup:insert(siteText)
    
	backbtn = display.newImageRect("ui/menu/backbtn.png", 120, 40)
	backbtn.x = display.contentWidth/2 + 200
	backbtn.y = 30
	mainGroup:insert(backbtn)
	backbtn:addEventListener("tap", function()
		composer.gotoScene( "scene.menu" )
	end
	)
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
		display.remove(mainGroup)	
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