--MUSIC 
menubgmusic = audio.loadStream ("sound/menu.mp3")
gameoverbgmusic = audio.loadStream ("sound/death_is_just_another_path.mp3")
babybgmusic = audio.loadStream ("sound/baby_song.mp3")
childbgmusic = audio.loadStream ("sound/school_of_quirks.mp3")
youngbgmusic = audio.loadStream ("sound/a_journey_awaits.mp3")
adultbgmusic = audio.loadStream ("sound/busy_day_at_the_market.wav")
oldbgmusic = audio.loadStream ("sound/school_of_quirks.mp3")

--SOUND
bubblepop = audio.loadSound ("sound/pop.mp3")
losesound = audio.loadSound ("sound/lose.wav")
menupicksound = audio.loadSound ("sound/menu_pick.wav")
jumpsound = audio.loadSound ("sound/jump.wav")
shootsound = audio.loadSound ("sound/huh.wav")
lvlupsound = audio.loadSound ("sound/chipquest.wav")
 
audio.reserveChannels (2) 

function playSFX (soundfile) 
	audio.play(soundfile, {channel =  2})
end 
 
function playGameMusic(soundfile)
	audio.play (soundfile, {channel = 1, loops = -1 , fadein=2500})	
end
 
function resetMusic (soundfile)
 
if musicisOn == true then 
	audio.stop(1)
	audio.rewind (gamebgmusic)
end
 
end
 
function pauseMusic (soundfile)
	if musicisOn == true then 
		audio.pause()
	end
end
 
function resumeMusic (channel)
	if musicisOn == true then 
		audio.resume(channel)
	end
end