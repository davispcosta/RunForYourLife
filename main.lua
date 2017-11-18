
local composer = require "composer"
local loadsave = require( "loadsave")

-- REMOVE 'BOTTOM BAR' NO ANDROID 
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
  native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end

loadedSettings = loadsave.loadTable("settings.json")
if loadedSettings == nil then
	settings = {}
	settings.soundOn = true
	settings.musicOn = true
	loadsave.saveTable( settings, "settings.json")
	loadedSettings = loadsave.loadTable("settings.json")
end

if(loadedSettings.musicOn == true) then
	audio.setVolume( 0.75, { channel=1 } )
else
	audio.setVolume( 0, { channel=1 } )
end


function splashScreen()

	--logo = display.newImage("ui/splash.png")

	--logo.alpha = 1
	--logo.x = display.contentCenterX
	--logo.y = display.contentCenterY
	
	--transition.to(logo, {transition = easing.outSine, time = 500, delay = 2000, alpha = 0})

	composer.gotoScene( "scene.menu", { params={ } } )
end

-- VAI PARA O MENU
splashScreen()

