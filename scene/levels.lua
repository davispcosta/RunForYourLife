local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local myData = require( "data" )
local starVertices = { 0,-8,1.763,-2.427,7.608,-2.472,2.853,0.927,4.702,6.472,0.0,3.0,-4.702,6.472,-2.853,0.927,-7.608,-2.472,-1.763,-2.427 }

local function handleCancelButtonEvent()
	composer.gotoScene("scene.menu")
end

local function handleLevelSelect( event )
	if ( "ended" == event.phase ) then
	
		myData.settings.currentLevel = event.target.id
		audio.stop(1)
		if(event.target.id == '1') then
			composer.gotoScene( "scene.babyLevel", { effect="crossFade", time=333 } )
		elseif ( event.target.id == '2') then
			composer.gotoScene( "scene.childLevel", { effect="crossFade", time=333 } )
		elseif ( event.target.id == '3') then
			composer.gotoScene( "scene.youngLevel", { effect="crossFade", time=333 } )
		elseif ( event.target.id == '4') then
			composer.gotoScene( "scene.adultLevel", { effect="crossFade", time=333 } )
		else
			composer.gotoScene( "scene.oldLevel", { effect="crossFade", time=333 } )
		end		
	end
end

function scene:create( event )
	local sceneGroup = self.view

	local background = display.newImageRect( sceneGroup, "ui/menu/background.png", 580, 300 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert( background )

	local levelSelectGroup = display.newGroup()

	local xOffset = -100
	local yOffset = -50
	local cellCount = 1

	local buttons = {}

	for i = 1, myData.maxLevels do
		buttons[i] = widget.newButton({
			id = tostring(i),
			width = 80,
			height = 60,
			defaultFile = myData.settings.levels[i].background,
			onEvent = handleLevelSelect,
		})

		buttons[i].x = xOffset
		buttons[i].y = yOffset
		levelSelectGroup:insert( buttons[i] )

		if ( myData.settings.unlockedLevels == nil ) then
			myData.settings.unlockedLevels = 1
		end
		if ( i <= myData.settings.unlockedLevels ) then
			buttons[i]:setEnabled( true )
			buttons[i].alpha = 1.0
		else 
			buttons[i]:setEnabled( false ) 
			buttons[i].alpha = 0.5 
		end 
		
		local star = {} 
		if ( myData.settings.levels[i] and myData.settings.levels[i].stars and myData.settings.levels[i].stars > 0 ) then
			for j = 1, myData.settings.levels[i].stars do
				star[j] = display.newPolygon( 0, 0, starVertices )
				star[j]:setFillColor( 1, 0.9, 0 )
				star[j].strokeWidth = 1
				star[j]:setStrokeColor( 1, 0.8, 0 )
				star[j].x = buttons[i].x + (j * 16) - 32
				star[j].y = buttons[i].y + 8
				levelSelectGroup:insert( star[j] )
			end
		end
		
		xOffset = xOffset + 100
		cellCount = cellCount + 1
		if ( cellCount > 3 ) then
		cellCount = 1
		xOffset = -100
		yOffset = yOffset + 80
		end
	end
	
	sceneGroup:insert( levelSelectGroup )
	levelSelectGroup.x = display.contentCenterX
	levelSelectGroup.y = display.contentCenterY
	
	local doneButton = display.newImageRect( sceneGroup, "ui/menu/backbtn.png", 150, 50 )
	doneButton.x = display.contentCenterX
	doneButton.y = display.contentHeight - 40
	doneButton:addEventListener( "tap", handleCancelButtonEvent)
	
	sceneGroup:insert( doneButton )
end

-- On scene show...
function scene:show( event )
	local sceneGroup = self.view
	if ( event.phase == "did" ) then
	end
end

-- On scene hide...
function scene:hide( event )
	local sceneGroup = self.view
	if ( event.phase == "will" ) then
	end
end

-- On scene destroy...
function scene:destroy( event )
	local sceneGroup = self.view   
end

-- Composer scene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
