-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
soundisOn = true 
musicisOn = true 


-- REMOVE 'BOTTOM BAR' NO ANDROID 
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
  native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end


function splashScreen()

	logo = display.newImage("ui/splash.png")

	logo.alpha = 1
	logo.x = display.contentCenterX
	logo.y = display.contentCenterY

	transition.to(logo, {transition = easing.outSine, time = 500, delay = 2000, alpha = 0})

	composer.gotoScene( "scene.menu", { params={ } } )
end

-- VAI PARA O MENU
splashScreen()

