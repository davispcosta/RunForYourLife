display.setStatusBar(display.HiddenStatusBar)
 
local backbackground = display.newImage("images/background.png")
backbackground.x = 240
backbackground.y = 160
 
local backgroundfar = display.newImage("images/bgfar1.png")
backgroundfar.x = 480
backgroundfar.y = 160

local backgroundnear1 = display.newImage("images/bgnear2.png")
backgroundnear1.x = 240
backgroundnear1.y = 160
 
local backgroundnear2 = display.newImage("images/bgnear2.png")
backgroundnear2.x = 760
backgroundnear2.y = 160

--variable to hold our game's score
local score = 0
--scoreText is another variable that holds a string that has the score information
--when we update the score we will always need to update this string as well
--*****Note for android users, you may need to include the file extension of the font
-- that you choose here, so it would be BorisBlackBloxx.ttf there******
local scoreText = display.newText("score: " .. score, 0, 0, "BorisBlackBloxx", 30)
--This is important because if you dont have this line the text will constantly keep
--centering itself rather than aligning itself up neatly along a fixed point
scoreText.x = 60
scoreText.y = 30

--AQUI IMPLEMENTAMOS NOSSO PLAYER

local sheetOptions =
{
    width = 100,
    height = 69,
    numFrames = 4
}

local sheet_player = graphics.newImageSheet( "images/mansheet.png", sheetOptions)

local sequences_running = {
    {
        name = "normalRun",
        start = 1,
        count = 4,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local player = display.newSprite(sheet_player, sequences_running)
player.name = 'JOGADOR'
player.x = 80
player.y = 230
player:setSequence( "sequences_running" )
player:play()

--AQUI TERMINA IMPLEMENTAÇÃO DO PLAYER

local blocks = display.newGroup()

local physics = require "physics"
physics.start()
physics.addBody(player, "dynamic", { density = 1, friction = 0, bounce = 0 })
 
local groundMin = 300
local groundMax = 340
local speed = 5;
local groundLevel = groundMin
 
for a = 1, 8, 1 do
--AQUI GERAMOS O NOSSO CHÃO
local newBlock
newBlock = display.newImage("images/ground.png")
newBlock.name = "CHAO"
-- REPOSICIONANDO O CHÃO
newBlock.x = (a * 79) - 79
newBlock.y = groundLevel
physics.addBody(newBlock, "static",  { density = 0, friction = 0, bounce = 0 })
blocks:insert(newBlock)
end

local count = 0
local function update( event )

speed = speed + 0.01
count = count + 0.2
if(count == 1) then
    score = score + 1
    scoreText.text = "score: " .. score
    count = 0
end
updateBackgrounds()
end
 
function updateBackgrounds()

backgroundfar.x = backgroundfar.x - (speed/55)
backgroundnear1.x = backgroundnear1.x - (speed/5)

if(backgroundnear1.x < -239) then
backgroundnear1.x = 760
end
 
backgroundnear2.x = backgroundnear2.x - (speed/5)
if(backgroundnear2.x < -239) then
backgroundnear2.x = 760
end
end

local limit = 0
function onTouch(event)
	if(event.phase == "began" and limit < 1) then
		player:setLinearVelocity(0, -200)
		limit = limit + 1
	end
end

local function onLocalCollision( self, event )
    print( event.target.name )        --the first object in the collision
    print( event.other.name )         --the second object in the collision
    print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    print( event.otherElement )  --the element (number) of the second object which was hit in the collision

    if( event.other.name == "CHAO") then
    	limit = 0
    end
end
player.collision = onLocalCollision
player:addEventListener( "collision" )


Runtime:addEventListener("touch", onTouch)
timer.performWithDelay(1, update, -1)


local x = display.contentWidth
local y = display.contentHeight
local zombies = {}
local zombieCounter = 0

showZombies = function()

    --Gives a value from 1 to y
    local yVal = math.random(100, y-80)

    --spawn your zombie
    zombies[zombieCounter] = display.newImage("images/blast.png")
    zombies[zombieCounter].x = 100
    zombies[zombieCounter].y = yVal
    --set a tag for this zombie namely "myName"     
    zombies[zombieCounter].myName = zombieCounter

    while zombies[zombieCounter].x ~= 0 do
        zombies[zombieCounter].x = zombies[zombieCounter].x - 1
    end
    zombieCounter = zombieCounter + 1
end
timer.performWithDelay( 1000, showZombies, -1 )


