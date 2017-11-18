
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

	nextbox = display.newImageRect("ui/nextLevel/box.png", 600, 320)
		nextbox.x = display.contentCenterX
		nextbox.y = display.contentCenterY
	mainGroup:insert(nextbox)
		
	cake = display.newImageRect("ui/nextLevel/cake.png", 200, 200)
	cake.x = display.contentWidth/2 + 150
	cake.y = display.contentHeight/2 + 80
	mainGroup:insert(cake)	
	
	descriptionText = display.newText("PARABÉNS", 0, 0, "zorque.ttf", 50)
	descriptionText:setFillColor(150/255, 114/255, 77/255)
	descriptionText.x = display.contentWidth/2 - 70
	descriptionText.y = 100
	mainGroup:insert(descriptionText)	

	congratulationsText = display.newText("AGORA.. ENVELHEÇA!", 0, 0, "zorque.ttf", 20)
	congratulationsText:setFillColor(150/255, 114/255, 77/255)
	congratulationsText.x = display.contentWidth/2 - 70
	congratulationsText.y = 150
	mainGroup:insert(congratulationsText)

	nextbtn = display.newImageRect("ui/nextLevel/nextbtn.png", 170, 60)
		nextbtn.x = display.contentCenterX - 80
		nextbtn.y = display.contentCenterY + 80
		nextbtn:addEventListener("tap", function()
			lvl = level:getCurrentLevel() + 1
			level:setCurrentLevel(lvl)
			if(lvl == 1) then
				composer.gotoScene( "scene.babyLevel", { effect="crossFade", time=333 } )
			elseif (lvl == 2) then
				composer.gotoScene( "scene.childLevel", { effect="crossFade", time=333 } )
			elseif (lvl == 3) then
				composer.gotoScene( "scene.youngLevel", { effect="crossFade", time=333 } )
			elseif (lvl == 4) then
				composer.gotoScene( "scene.adultLevel", { effect="crossFade", time=333 } )
			else
				composer.gotoScene( "scene.oldLevel", { effect="crossFade", time=333 } )
			end			
		end)
	mainGroup:insert(nextbtn)

	local baloon01 = display.newImageRect("ui/nextLevel/baloon01.png", 50, 100)
	baloon01.x = display.contentCenterX + 220
	baloon01.y = display.contentCenterY
	mainGroup:insert(baloon01)

	local baloon02 = display.newImageRect("ui/nextLevel/baloon02.png", 50, 100)
	baloon02.x = display.contentCenterX - 220
	baloon02.y = display.contentCenterY + 50
	mainGroup:insert(baloon02)

	local baloon03 = display.newImageRect("ui/nextLevel/baloon03.png", 50, 100)
	baloon03.x = display.contentCenterX + 150
	baloon03.y = display.contentCenterY - 70
	mainGroup:insert(baloon03)
	
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
			baloon01.y = baloon01.y + 1
			baloon02.y = baloon02.y - 1
			baloon03.y = baloon03.y - 1

			countMove = countMove + 1
		else
			baloon01.y = baloon01.y - 1
			baloon02.y = baloon02.y + 1
			baloon03.y = baloon03.y + 1

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
		display.remove(mainGroup)
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