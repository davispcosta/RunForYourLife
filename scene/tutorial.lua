local composer = require( "composer" )
local physics = require("physics")

local level = require("leveltemplate")
local scene = composer.newScene()

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

   local sceneGroup = self.view
   level:setCurrentLevel(1)
   
   background = level:createBackground(level:getCurrentLevel())
   backGroup:insert(background)

   player = level:createPlayer("ui/baby/normal-sprite.png", "running")

   level:setValues(100,100,100,100)		
       
   local numShoots = level:createScoreProjectiles()
   uiGroup:insert(numShoots)

   local age = level:createScoreAge()
   uiGroup:insert(age)

   physics.start()		
   
   local floor = level:createFloor("ui/baby/ground.png")
   mainGroup:insert(floor)
       
   physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0})
   player.isFixedRotation=true	
   player.gravityScale = 0.8

   local function update( event )
        level:moveFloor(floor)
        
        back = level:updateBackground(level:getCurrentLevel())
        backGroup:insert(back)
   end
   movementLoop = timer.performWithDelay(1, update, -1)

   jumpbtn = display.newImageRect("ui/base/jumpbtn.png", 60, 60)
   jumpbtn.x = 0
   jumpbtn.y = display.contentHeight - 35
   uiGroup:insert(jumpbtn)   

   downbtn = display.newImageRect("ui/base/downbtn.png", 60, 60)
   downbtn.x = 70
   downbtn.y = display.contentHeight - 35
   uiGroup:insert(downbtn)

   shootbtn = display.newImageRect("ui/base/shootbtn.png", 60, 60)
   shootbtn.x = display.contentWidth 
   shootbtn.y = display.contentHeight - 35
   uiGroup:insert(shootbtn)   

   local header = level:buildHeader(true, false, false, false)
   uiGroup:insert(header)

   tutorialBox = display.newImageRect("ui/menu/box.png", 200, 200)
   tutorialBox.x = display.contentWidth/2 + 100
   tutorialBox.y = display.contentHeight/2
   mainGroup:insert(tutorialBox)

   tutoTitle = display.newText("MOVIMENTO", 0, 0, "zorque.ttf", 20)
   tutoTitle.x = display.contentWidth/2 + 100
   tutoTitle.y = display.contentHeight/2 - 50
   mainGroup:insert(tutoTitle)

   local options = {
	    text = "A vida está sempre em movimento, e da mesma forma, nosso personagem também! Sem apertar qualquer botão, você estará sempre indo pra frente.",     
        x = display.contentWidth/2 + 100,
        y = display.contentHeight/2 + 100,
        width = 180,
        height = display.contentWidth/1.8,
	    font = "zorque.ttf",   
	    fontSize = display.contentHeight/30,
	    align = "left"  -- Alignment parameter
    }    
   local tutoDescription = display.newText(options)
   mainGroup:insert(tutoDescription)

   nextbtn = display.newImageRect("ui/base/jumpbtn.png", 30, 30)
   nextbtn.rotation = 90
   nextbtn.x = display.contentWidth/2 + 180
   nextbtn.y = display.contentHeight/2 + 70
   uiGroup:insert(nextbtn)   

   hand = display.newImageRect("ui/menu/hand.png", 50, 30)
   hand.x = 200
   hand.y = 100
   mainGroup:insert(hand)
   
    jumpLoop = timer.performWithDelay(2000, function()
    player:setLinearVelocity(0, -240)
    end, -1)
    timer.pause(jumpLoop)
   function jumpTuto()

        player:setLinearVelocity(0, -240)
        timer.resume(jumpLoop)
        hand.x = 0
        hand.rotation = 90
        hand.y = display.contentHeight - 100

        tutoTitle.text = "O PULO"
        tutoDescription.text = "Você vai precisar se desviar de obstáculos e alcançar colecionáveis. Para isso temos a função de pulo!"
   end

   function downTuto()
        timer.pause(jumpLoop)
        local playerx = player.x
        local playery = player.y
        player:removeSelf()
        player = level:createPlayer("ui/baby/crowling.png", "crowling")
        player.x = playerx
        player.y = playery
        mainGroup:insert(player)
        physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, gravity = 0 })		

        hand.x = 70
        hand.y = display.contentHeight - 100

        tutoTitle.text = "AGACHAR"
        tutoDescription.text = "Enquanto ainda jovem, você também pode usar a habilidade de agachar. Mas saiba, a partir da fase adulta, você está ficando velho e não pode ficar mais agachando"
   end

   shootLoop = timer.performWithDelay(1000, function()
        if(level:getNumProjectiles()  > 0) then
            local projectile = display.newImageRect("ui/baby/bear.png", 30, 30 )
            projectile.x = player.x
            projectile.y = player.y
            physics.addBody(projectile, 'dynamic')
            projectile.gravityScale = 0
            projectile.isSensor = true
            projectile.name = "PROJECTILE"
            projectile:setLinearVelocity( 150, 0 )
            backGroup:insert(projectile)
            level:reduceProjectiles(1)													
        end
    end, -1)
   timer.pause(shootLoop)
   function shootTuto()

        player:removeSelf()
        player = level:createPlayer("ui/baby/normal-sprite.png", "normalRun")
        physics.addBody(player, "dynamic", { density = 0, friction = 0, bounce = 0, gravity = 0 })			
        player:setSequence("normalRun")
        player:play()
        
        level:addProjectiles(90)
        timer.resume(shootLoop)

        hand.x = display.contentWidth 
        hand.y = display.contentHeight - 100

        tutoTitle.text = "ATIRAR"
        tutoDescription.text = "Para facilitar sua vida, temos atiráveis. Objetos que você pode usar para lançar e destruir obstáculos, colecionar bolhas ou atingir inimigos"
   end
   
   function looseTuto()

    tutorialBox.x = tutorialBox.x - 50
    tutoTitle.x = tutoTitle.x - 50
    tutoDescription.x = tutoDescription.x - 50
    nextbtn.x = nextbtn.x - 50
    hand.x = display.contentCenterX + 180
    
    tutoTitle.text = "GASTÁVEL"
    tutoDescription.text = "Cuidado! Não vá ficar gastando, pois o tiro é algo consumível. E você precisará ficar colecionando mais."
   end


   local function creationLoop(event)
        local aux = math.random(0, 10)

        if aux <= 6 then
            obstacle = level:createObstacle(level:getCurrentLevel())
            backGroup:insert(obstacle)
        else
            collectible = level:createCollectible(level:getCurrentLevel())
            backGroup:insert(collectible)
        end
    end

    local function updateBubbles( event )
		level:moveCollectibles()
		level:moveObstacles()
	end

   movementBubblesLoop = timer.performWithDelay(1, updateBubbles, -1)
   timer.pause(movementBubblesLoop)
   emergeLoop = timer.performWithDelay(1000, creationLoop, -1 )
   timer.pause(emergeLoop)
   function bubblesTuto()
        player:removeSelf()
        hand.alpha = 0
        timer.resume(movementBubblesLoop)
        timer.resume(emergeLoop)
        tutoTitle.text = "BOLHAS"
        tutoDescription.text = "Elas trazem do melhor e do pior. Cuidado com as avermelhadas, elas fazem você perder porcentagens. As esverdeadas dão score e porcentagem positiva. E as transparentes são tiros."
    end

    function porcentagesTuto()
        hand.alpha = 1
        hand.rotation = -90
        hand.x = 30
        hand.y = 100

        level:reduceHealth(50)

        tutoTitle.text = "PORCENTAGENS"
        tutoDescription.text = "Mantenha seus scores positivos. Pois tendo qualquer porcentagem zerada fará você perder!"
    end

   nextCount = 0
   function nextbtn:touch(event)	
        if(event.phase == "began") then
            if(nextCount == 0) then
                jumpTuto()
            elseif(nextCount == 1) then
                downTuto()
            elseif(nextCount == 2) then
                shootTuto()
            elseif(nextCount == 3) then
                looseTuto()
            elseif(nextCount == 4) then
                bubblesTuto()
            elseif(nextCount == 5) then
                porcentagesTuto()
            elseif(nextCount == 6) then
                composer.gotoScene( "scene.menu")
            end
            nextCount = nextCount + 1            
        end
    end	
    nextbtn:addEventListener("touch", nextbtn)
    mainGroup:insert(player)
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
        timer.cancel(movementLoop)
        timer.cancel(movementBubblesLoop)
        timer.cancel(jumpLoop)
        timer.cancel(shootLoop)        
        timer.cancel(emergeLoop)
        level:destroy()		
        display.remove(mainGroup)
        display.remove(uiGroup)
        display.remove(backGroup)		
    elseif ( phase == "did" ) then
        physics.pause()
        composer.removeScene("tutorial")
        composer.hideOverlay()
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