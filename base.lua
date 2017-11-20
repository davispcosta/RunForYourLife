local base = {}
    base.levels = {}

    --------------------------------------
    --------------------------------------
    -------------- LEVELS ----------------
    --------------------------------------
    --------------------------------------

        --------------------------------------
        --- BABY LEVEL ---
        -------------------------------------
        
        base.levels[1] = {}
            base.levels[1].background = "ui/baby/background.png"
            base.levels[1].numBackgroundsNear = 7
            base.levels[1].backgroundNear = {}

                base.levels[1].backgroundNear[1] = {}
                base.levels[1].backgroundNear[1].path = "ui/baby/door.png"
                base.levels[1].backgroundNear[1].y = 200
                
                base.levels[1].backgroundNear[2] = {}
                base.levels[1].backgroundNear[2].path = "ui/baby/plant.png"
                base.levels[1].backgroundNear[2].y = 200
                
                base.levels[1].backgroundNear[3] = {}
                base.levels[1].backgroundNear[3].path = "ui/baby/boxes.png"
                base.levels[1].backgroundNear[3].y = 230
                
                base.levels[1].backgroundNear[4] = {}
                base.levels[1].backgroundNear[4].path = "ui/baby/table.png"
                base.levels[1].backgroundNear[4].y = 250
                
                base.levels[1].backgroundNear[5] = {}
                base.levels[1].backgroundNear[5].path = "ui/baby/abajurs.png"
                base.levels[1].backgroundNear[5].y = 100

                base.levels[1].backgroundNear[6] = {}
                base.levels[1].backgroundNear[6].path = "ui/baby/photos.png"
                base.levels[1].backgroundNear[6].y = 200

                base.levels[1].backgroundNear[7] = {}
                base.levels[1].backgroundNear[7].path = "ui/baby/baloons.png"
                base.levels[1].backgroundNear[7].y = 200

            base.levels[1].collectibles = {}
            base.levels[1].numCollectibles = 2

                base.levels[1].collectibles[1]={}
                base.levels[1].collectibles[1].type = "health"
                base.levels[1].collectibles[1].path = "ui/collect/blast.png"

                base.levels[1].collectibles[2]={}
                base.levels[1].collectibles[2].type = "shoot"
                base.levels[1].collectibles[2].path = "ui/collect/bear.png"

            base.levels[1].obstacles = {}
            base.levels[1].numObstacles = 1
            
                base.levels[1].obstacles[1] = {}
                base.levels[1].obstacles[1].type = "health"
                base.levels[1].obstacles[1].path = "ui/collect/dicese.png"

        --------------------------------------
        --- CHILD LEVEL ---
        -------------------------------------
            
        base.levels[2] = {}
            base.levels[2].background = "ui/child/background.png"
            base.levels[2].numBackgroundsNear = 7
            base.levels[2].backgroundNear = {}

                base.levels[2].backgroundNear[1] = {}
                base.levels[2].backgroundNear[1].path = "ui/child/door.png"
                base.levels[2].backgroundNear[1].y = 126
                
                base.levels[2].backgroundNear[2] = {}
                base.levels[2].backgroundNear[2].path = "ui/child/door02.png"
                base.levels[2].backgroundNear[2].y = 126
                
                base.levels[2].backgroundNear[3] = {}
                base.levels[2].backgroundNear[3].path = "ui/child/clock.png"
                base.levels[2].backgroundNear[3].y = 100
                
                base.levels[2].backgroundNear[4] = {}
                base.levels[2].backgroundNear[4].path = "ui/baby/table.png"
                base.levels[2].backgroundNear[4].y = 185
                
                base.levels[2].backgroundNear[5] = {}
                base.levels[2].backgroundNear[5].path = "ui/child/lockers.png"
                base.levels[2].backgroundNear[5].y = 155

                base.levels[2].backgroundNear[6] = {}
                base.levels[2].backgroundNear[6].path = "ui/child/board.png"
                base.levels[2].backgroundNear[6].y = 130

                base.levels[2].backgroundNear[7] = {}
                base.levels[2].backgroundNear[7].path = "ui/child/chair.png"
                base.levels[2].backgroundNear[7].y = 192
            
            base.levels[2].collectibles = {}
            base.levels[2].numCollectibles = 3
            
                base.levels[2].collectibles[1]={}
                base.levels[2].collectibles[1].type = "health"
                base.levels[2].collectibles[1].path = "ui/collect/pills.png"

                base.levels[2].collectibles[2]={}
                base.levels[2].collectibles[2].type = "happiness"
                base.levels[2].collectibles[2].path = "ui/collect/carts.png"

                base.levels[2].collectibles[3]={}
                base.levels[2].collectibles[3].type = "shoot"
                base.levels[2].collectibles[3].path = "ui/collect/ball.png"

            base.levels[2].obstacles = {}
            base.levels[2].numObstacles = 2
            
                base.levels[2].obstacles[1] = {}    
                base.levels[2].obstacles[1].type = "health"
                base.levels[2].obstacles[1].path = "ui/collect/dicese.png"

                base.levels[2].obstacles[2] = {}    
                base.levels[2].obstacles[2].type = "happiness"
                base.levels[2].obstacles[2].path = "ui/collect/badvibe.png"

        --------------------------------------
        --- YOUNG LEVEL ---
        -------------------------------------
            
        base.levels[3] = {}
            base.levels[3].background = "ui/young/background.png"
            base.levels[3].numBackgroundsNear = 6
            base.levels[3].backgroundNear = {}

                base.levels[3].backgroundNear[1] = {}
                base.levels[3].backgroundNear[1].path = "ui/young/globe.png"
                base.levels[3].backgroundNear[1].y = 90
                
                base.levels[3].backgroundNear[2] = {}
                base.levels[3].backgroundNear[2].path = "ui/young/bluelight.png"
                base.levels[3].backgroundNear[2].y = 126
                
                base.levels[3].backgroundNear[3] = {}
                base.levels[3].backgroundNear[3].path = "ui/young/pinkbluelight.png"
                base.levels[3].backgroundNear[3].y = 100
                
                base.levels[3].backgroundNear[4] = {}
                base.levels[3].backgroundNear[4].path = "ui/young/redlight.png"
                base.levels[3].backgroundNear[4].y = 185
                
                base.levels[3].backgroundNear[5] = {}
                base.levels[3].backgroundNear[5].path = "ui/young/stereo.png"
                base.levels[3].backgroundNear[5].y = 90

                base.levels[3].backgroundNear[6] = {}
                base.levels[3].backgroundNear[6].path = "ui/young/yellowlight.png"
                base.levels[3].backgroundNear[6].y = 130

            base.levels[3].collectibles = {}
            base.levels[3].numCollectibles = 5        

                base.levels[3].collectibles[1]={}
                base.levels[3].collectibles[1].type = "health"
                base.levels[3].collectibles[1].path = "ui/collect/pills.png"

                base.levels[3].collectibles[2]={}
                base.levels[3].collectibles[2].type = "money"
                base.levels[3].collectibles[2].path = "ui/collect/money.png"

                base.levels[3].collectibles[3]={}
                base.levels[3].collectibles[3].type = "happiness"
                base.levels[3].collectibles[3].path = "ui/collect/carts.png"

                base.levels[3].collectibles[4]={}
                base.levels[3].collectibles[4].type = "shoot"
                base.levels[3].collectibles[4].path = "ui/collect/phone.png"

                base.levels[3].collectibles[5]={}
                base.levels[3].collectibles[5].type = "love"
                base.levels[3].collectibles[5].path = "ui/collect/star.png"

            base.levels[3].obstacles = {}
            base.levels[3].numObstacles = 3
            
                base.levels[3].obstacles[1] = {}    
                base.levels[3].obstacles[1].type = "health"
                base.levels[3].obstacles[1].path = "ui/collect/dicese.png"

                base.levels[3].obstacles[2] = {}    
                base.levels[3].obstacles[2].type = "money"
                base.levels[3].obstacles[2].path = "ui/collect/debt.png"

                base.levels[3].obstacles[3] = {}    
                base.levels[3].obstacles[3].type = "happiness"
                base.levels[3].obstacles[3].path = "ui/collect/badvibe.png"

        --------------------------------------
        --- ADULT LEVEL ---
        -------------------------------------

        base.levels[4] = {}
        base.levels[4].background = "ui/adult/background.png"
        base.levels[4].numBackgroundsNear = 5
        base.levels[4].backgroundNear = {}
            base.levels[4].backgroundNear[1] = {}
            base.levels[4].backgroundNear[1].path = "ui/adult/building01.png"
            base.levels[4].backgroundNear[1].y = 120

            base.levels[4].backgroundNear[2] = {}
            base.levels[4].backgroundNear[2].path = "ui/adult/building02.png"
            base.levels[4].backgroundNear[2].y = 120
            
            base.levels[4].backgroundNear[3] = {}
            base.levels[4].backgroundNear[3].path = "ui/adult/building03.png"
            base.levels[4].backgroundNear[3].y = 120

            base.levels[4].backgroundNear[4] = {}
            base.levels[4].backgroundNear[4].path = "ui/adult/building04.png"
            base.levels[4].backgroundNear[4].y = 150

            base.levels[4].backgroundNear[5] = {}
            base.levels[4].backgroundNear[5].path = "ui/adult/hydrant.png"
            base.levels[4].backgroundNear[5].y = 200
        
        base.levels[4].collectibles = {}
        base.levels[4].numCollectibles = 4    

            base.levels[4].collectibles[1]={}
            base.levels[4].collectibles[1].type = "health"
            base.levels[4].collectibles[1].path = "ui/collect/pills.png"

            base.levels[4].collectibles[2]={}
            base.levels[4].collectibles[2].type = "money"
            base.levels[4].collectibles[2].path = "ui/collect/money.png"

            base.levels[4].collectibles[3]={}
            base.levels[4].collectibles[3].type = "happiness"
            base.levels[4].collectibles[3].path = "ui/collect/carts.png"

            base.levels[4].collectibles[4]={}
            base.levels[4].collectibles[4].type = "shoot"
            base.levels[4].collectibles[4].path = "ui/collect/suitcase.png"

        base.levels[4].obstacles = {}
        base.levels[4].numObstacles = 3
             
            base.levels[4].obstacles[1] = {}    
            base.levels[4].obstacles[1].type = "health"
            base.levels[4].obstacles[1].path = "ui/collect/dicese.png"

            base.levels[4].obstacles[2] = {}    
            base.levels[4].obstacles[2].type = "money"
            base.levels[4].obstacles[2].path = "ui/collect/debt.png"

            base.levels[4].obstacles[3] = {}    
            base.levels[4].obstacles[3].type = "happiness"
            base.levels[4].obstacles[3].path = "ui/collect/badvibe.png"


        --------------------------------------
        --- OLD LEVEL ---
        -------------------------------------
        
        base.levels[5] = {}
        base.levels[5].background = "ui/old/background.png"
        base.levels[5].numBackgroundsNear = 4
        base.levels[5].backgroundNear = {}
            base.levels[5].backgroundNear[1] = {}
            base.levels[5].backgroundNear[1].path = "ui/old/tree.png"
            base.levels[5].backgroundNear[1].y = 220

            base.levels[5].backgroundNear[2] = {}
            base.levels[5].backgroundNear[2].path = "ui/old/rocks.png"
            base.levels[5].backgroundNear[2].y = 250
            
            base.levels[5].backgroundNear[3] = {}
            base.levels[5].backgroundNear[3].path = "ui/old/tent.png"
            base.levels[5].backgroundNear[3].y = 220

            base.levels[5].backgroundNear[4] = {}
            base.levels[5].backgroundNear[4].path = "ui/old/fances.png"
            base.levels[5].backgroundNear[4].y = 220
        
        base.levels[5].collectibles = {}
        base.levels[5].numCollectibles = 4   

            base.levels[5].collectibles[1]={}
            base.levels[5].collectibles[1].type = "health"
            base.levels[5].collectibles[1].path = "ui/collect/pills.png"

            base.levels[5].collectibles[2]={}
            base.levels[5].collectibles[2].type = "money"
            base.levels[5].collectibles[2].path = "ui/collect/money.png"

            base.levels[5].collectibles[3]={}
            base.levels[5].collectibles[3].type = "happiness"
            base.levels[5].collectibles[3].path = "ui/collect/carts.png"

            base.levels[5].collectibles[4]={}
            base.levels[5].collectibles[4].type = "shoot"
            base.levels[5].collectibles[4].path = "ui/collect/dentuce.png"

        base.levels[5].obstacles = {}
        base.levels[5].numObstacles = 3
            
            base.levels[5].obstacles[1] = {}    
            base.levels[5].obstacles[1].type = "health"
            base.levels[5].obstacles[1].path = "ui/collect/dicese.png"

            base.levels[5].obstacles[2] = {}    
            base.levels[5].obstacles[2].type = "money"
            base.levels[5].obstacles[2].path = "ui/collect/debt.png"

            base.levels[5].obstacles[3] = {}    
            base.levels[5].obstacles[3].type = "happiness"
            base.levels[5].obstacles[3].path = "ui/collect/badvibe.png"

    --------------------------------------
    --------------------------------------
    ----------- ACHIEVEMENTS -------------
    --------------------------------------
    --------------------------------------

    base.numAchievements = 7
    base.achievements = {}

        base.achievements[1] = {}
        base.achievements[1].title = "Saúde de Ferro"    
        base.achievements[1].description = "lorem Ipslum lallalalala"

        base.achievements[2] = {}
        base.achievements[2].title = "CDF"    
        base.achievements[2].description = "lorem Ipslum lallalalala"

        base.achievements[3] = {}
        base.achievements[3].title = "Rebelde"    
        base.achievements[3].description = "lorem Ipslum lallalalala"

        base.achievements[4] = {}
        base.achievements[4].title = "Apaixonado"    
        base.achievements[4].description = "lorem Ipslum lallalalala"

        base.achievements[5] = {}
        base.achievements[5].title = "Milionário"    
        base.achievements[5].description = "lorem Ipslum lallalalala"

        base.achievements[6] = {}
        base.achievements[6].title = "Recém-Casado"    
        base.achievements[6].description = "lorem Ipslum lallalalala"

        base.achievements[7] = {}
        base.achievements[7].title = "Aposentado"    
        base.achievements[7].description = "lorem Ipslum lallalalala"
    
    --------------------------------------
    --------------------------------------
    ------------- SETTINGS ---------------
    --------------------------------------
    --------------------------------------

return base