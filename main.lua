-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"

-- REMOVE 'BOTTOM BAR' NO ANDROID 
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
  native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end

-- RESERVA CANAIS DE ÁUDIO PARA 1- MENU 2- BACKGROUND 3- INTERAÇÕES
audio.reserveChannels(3)

-- VAI PARA O MENU
composer.gotoScene( "scene.menu", { params={ } } )

