-----------------------------------------------------------------------------------------
--
-- ***PLANET POOL***
-- Andrea Raccanelli, Federico Viol, Gabriele Pilotto
-- FILENAME: level_P1L1.lua
-- LOCATION: .\.\Gioco\Risorse\Livelli\P1L1\level_P1L1.lua
-- DESCRIZIONE: pianeta 1 livello 1
--
-----------------------------------------------------------------------------------------

-- CARICAMENTO E SET UP --

-- Libreria composer per gestione scene + creazione scena
local composer = require("composer") 
local scene = composer.newScene() 

-- Libreria physics per il motore fisico
local physics = require("physics") 

-- Librerie caricamento mappe
local tiled = require "com.ponywolf.ponytiled" 
local json = require "json" 

-----------------------------------------------------------------------------------------

-- DICHIARAZIONI VARIABILI LOCALI --
local hole
local line
local map
local mapData
local cue
local blackBall
local whiteBall
local resartButton
local homeButton
local whiteInHole = false
local blackInHole = false
local alreadyWarned = false
local SFX_ballInHole
local SFX_ballVSball
local SFX_shore
local SFX_cue
local music
local pathSFX
local pathMusic
local pathXP
local angleDeg
local pullNumber = 0
local localXP = 0
local newXP
local oldXP
local reset
local displayXP
local levelDirectory
local level


-----------------------------------------------------------------------------------------

-- CREAZIONE DI FUNZIONI GLOBALI --
--
-- Funzione per verificare se tutte le palline sono ferme
local function reposition()
    if whiteBall.isAwake == false and blackBall.isAwake == false then
        cue.x = 135
        cue.y = 240
        cue.rotation = 0
        Runtime:removeEventListener("enterFrame", reposition)
    end
end

-- Funzione per calcolo angolo stecca
local function angleCalc(event)
    if whiteBall.x ~= nil and whiteBall.y ~= nil then
        coordX = event.x-whiteBall.x
        coordY = event.y-whiteBall.y
        angleRad = math.atan2(coordY,coordX)
        angleDeg = math.deg(angleRad) - 90
    end
end

-- Funzione per l'applicazione della forza a whiteBall
local function shoot(xForce,yForce)
	whiteBall:applyLinearImpulse(xForce,yForce,whiteBall.x,whiteBall.y)
    whiteBall.linearDamping = 1.5
    pullNumber = pullNumber + 1
    audio.play(SFX_cue, {channel=5})
end

-- Funzione lancio
local function launch(event)
    transition.cancel(cue)
    display.remove(line)
    line=nil
    xForce = (whiteBall.x-event.x)*3
    yForce = (whiteBall.y-event.y)*3
    shoot(xForce,yForce)
    -- ascoltatore per riposizionamento stecca
    Runtime:addEventListener("enterFrame", reposition)
end

-- Funzione per il disegno della traiettoria e il tiro di whiteBall
local function drawLine(event)
    -- se la whiteBall è ferma (inattiva)
    if whiteBall.isAwake == false then
        -- durante l'evento touch (quindi durante la mira)
        if event.phase=="moved" then
                if line ~= nil then
                    display.remove(line)
                    line = nil
                end
                line = display.newLine(whiteBall.x, whiteBall.y, event.x, event.y)
                line.strokeWidth = 8
                line:setStrokeColor(0,0,0)
            end
            -- al termine dell'evento touch (quindi post mira)
            if event.phase=="ended" then
                cue.x = event.x
                cue.y = event.y 
                cue.rotation = angleDeg
                transition.to(cue, {time = 150, 
                                    x = whiteBall.x, 
                                    y = whiteBall.y, 
                                    transition=easing.inOutExpo,
                                    onComplete=launch(event)})    
        end	
    end 
end

-- Verifica che il tocco non sia nella barra nera (per non creare conflitti con i tasti)
local function checkY(event)
    if event.y>92 then
        drawLine(event)
    else
        display.remove(line)
        line = nil
    end
end

-- Funzione per lettura XP globale
local function readXP()
    local actualXP
    local oldFileXP, errorString = io.open(pathXP, "r")
    if not oldFileXP then
        io.open(pathXP, "w")
    else
        actualXP = oldFileXP:read("*n")
        io.close(oldFileXP)
        oldXP = actualXP
        if oldXP == nil then
            oldXP = 0
        end
    end
    oldFileXP = nil
end

-- Funzione per aggiornamento XP globale
local function updateXP()
    newXP = localXP + oldXP
    local newFileXP, errorString = io.open(pathXP, "w")
    if not newFileXP then
        print("Errore XP: " ..errorString)
    else
        newFileXP:write(newXP)
        io.close(newFileXP)
    end
    newFileXP = nil
end

-- Funzione per il conteggio del punteggio
local function calcXP() 
    if pullNumber == 1 then
        localXP = 25
    elseif pullNumber == 2 then
        localXP = 18
    elseif pullNumber == 3 then
        localXP = 15
    elseif pullNumber == 4 then
        localXP = 12
    elseif pullNumber == 5 then
        localXP = 10
    elseif pullNumber == 6 then
        localXP = 8
    elseif pullNumber == 7 then
        localXP = 6
    elseif pullNumber == 8 then
        localXP = 4
    elseif pullNumber == 9 then
        localXP = 2
    elseif pullNumber == 10 then
        localXP = 1
    else
        localXP = 0
    end
    updateXP()
end

local function lastLevel()
    local levelStatus, errorString = io.open(pathLevel, "r")
    if not levelStatus then
        print("Errore livelli" .. errorString)
    else
        nowLevel = levelStatus:read("*n")
        io.close(levelStatus)
        level = nowLevel
        if level == nil then
            level = 1
        end
    end
    levelStatus = nil
end

-- Funzione per calcolo percorso
local function pathCalc()
    if level == 1 then
        levelDirectory = "P1L1"
    elseif level == 2 then
        levelDirectory = "P1L2"
    elseif level == 3 then
        levelDirectory = "P1L3"
    elseif level == 4 then
        levelDirectory = "P1L4"
    elseif level == 5 then
        levelDirectory = "P1L5"
    elseif level == 6 then
        levelDirectory = "P2L1"
    elseif level == 7 then
        levelDirectory = "P2L2"
    elseif level == 8 then
        levelDirectory = "P2L3"
    elseif level == 9 then
        levelDirectory = "P2L4"
    elseif level == 10 then
        levelDirectory = "P3L1"
    elseif level == 11 then
        levelDirectory = "P3L2"
    elseif level == 12 then
        levelDirectory = "P3L3"
    elseif level == 13 then
        levelDirectory = "P4L1"
    elseif level == 14 then
        levelDirectory = "P4L2"
    elseif level == 15 then
        levelDirectory = "P5L1"
    end
end

-- Funzione per il ritorno alla home
local function goToHome()
    composer.removeScene(".Risorse.Menu.Home.home")
    composer.gotoScene(".Risorse.Menu.Home.home")
    audio.stop()
end

-- Funzione per il riavvio del livello 
local function goToReload()
    if reset ~= nil then
        display.remove(reset)
        display.remove(loseScreen)    
    end
    composer.removeScene(".Risorse.Livelli.P1L1.reload")
    composer.gotoScene(".Risorse.Livelli.P1L1.reload")
    audio.stop()

end

-- Funzione per il livello successivo
local function goToNextLevel()
    composer.removeScene(".Risorse.Livelli." .. levelDirectory .. ".reload")
    composer.gotoScene(".Risorse.Livelli." .. levelDirectory .. ".reload")
    display.remove( displayXP )
    display.remove( winScreen )
    display.remove( continue )
    audio.stop()
end

-- Funzione per aggiornale il file level
local function levelUpdate()
    local newLevel, errorString = io.open(pathLevel, "w")
    if not newLevel then
        print("Errore write Level: " ..errorString)
    else
        newLevel:write(level)
        io.close(newLevel)
    end
    newLevel = nil
end

-- Funzione per il popup vittoria livello
local function winPopup()
    -- caricamento, posizionamento e applicazione dissolvenza alla grafica per la vittoria
    winScreen = display.newImageRect("/Risorse/Livelli/P1L1/Hai Vinto.png", 1920, 1080)
    winScreen.anchorX = 0
    winScreen.anchorY = 0
    winScreen.x = 0
    winScreen.y = 0
    winScreen.alpha = 0
    transition.to(winScreen, {alpha=1, time = 80})
    -- caricamento, posizionamento e assegnazione listener al pulsante
    continue = display.newImageRect("/Risorse/Livelli/P1L1/Continua.png", 388, 154)
    continue.anchorX = 0
    continue.anchorY = 0
    continue.x = 766
    continue.y = 671
    continue.alpha = 0
    transition.to(continue, {alpha=1, time = 80})
    continue:addEventListener("tap", goToNextLevel )
    -- richiama la funzione per il calcolo degli XP
    calcXP()
    -- mostra i punti ottenuti
    displayXP = display.newText( "+" .. localXP .." punti", 959, 565, "/Risorse/Moduli/DigitalDisco.ttf", 80 )
    -- update livello
    
    level = level+1
    -- Richiamo funzione per il percorso
    pathCalc()

    -- RIchiamo funzione per l'aggiornamento del file level
    levelUpdate()
end

-- Funzione in caso di buca della pallina bianca
local function wrongBall()
    -- caricamento, posizionamento e applicazione dissolvenza alla grafica per la vittoria
    loseScreen = display.newImageRect("/Risorse/Livelli/P1L1/Hai Perso.png", 1920, 1080)
    loseScreen.anchorX = 0
    loseScreen.anchorY = 0
    loseScreen.x = 0
    loseScreen.y = 0
    loseScreen.alpha = 0
    transition.to(loseScreen, {alpha=1, time = 80})

    -- carivamento, posizionamento e assegnazione listener al pulsante
    reset = display.newImageRect("/Risorse/Livelli/P1L1/Riprova.png", 388, 154)
    reset.anchorX = 0
    reset.anchorY = 0
    reset.x = 766
    reset.y = 671
    reset.alpha = 0
    transition.to(reset, {alpha=1, time = 80})
    reset:addEventListener("tap", goToReload)
    alreadyWarned = true
end

-- Funzione per comprendere se la pallina bianca è rimasta fuori
local function checkRegularity()
    if whiteInHole == true and alreadyWarned == false then
        wrongBall()
    elseif whiteInHole == false then
        winPopup()
    end
end

-- Funzione per la gestione della pallina bianca in buca
local function whiteBallHoleCollision(event)
    local collidedObject = event.other
    if event.phase=="began" then 
        if collidedObject.name=="hole" then
            whiteBall:removeSelf() 
            whiteInHole = true
            audio.play(SFX_ballInHole, {channel = 3})
            Runtime:removeEventListener("touch",checkY)
            checkRegularity()
        end 
    end
end

-- Funzione per la gestione della pallina nera in buca
local function blackBallHoleCollision(event)
    local collidedObject = event.other
    if event.phase=="began" then 
        if collidedObject.name=="hole" then 
            blackBall:removeSelf() 
            blackInHole = true
            audio.play(SFX_ballInHole, {channel = 3})
            Runtime:removeEventListener("touch", checkY) 
            timer.performWithDelay(3000, checkRegularity)
        end 
    end
end

-- Funzione per impostare il volume della musica
local function setVolumeMusic()
    local fileHandleMusic, errorString = io.open(pathMusic, "r" )
    if not fileHandleMusic then
        print( "Errore Music: " .. errorString )
    else
        contentsMusic = fileHandleMusic:read("*n")
        audio.setVolume(contentsMusic, {channel = 1})
        io.close( fileHandleMusic )
    end
    audio.play(music)
end

-- Funzione per impostare il volume degli SFX
local function setVolumeSFX()
    local fileHandleSFX, errorString = io.open(pathSFX, "r")
    if not fileHandleSFX then
        print( "Errore SFX: " .. errorString )
    else
        contentsSFX = fileHandleSFX:read("*n")
        audio.setVolume(contentsSFX, {channel = 2})
        audio.setVolume(contentsSFX, {channel = 3})
        audio.setVolume(contentsSFX, {channel = 4})
        audio.setVolume(contentsSFX, {channel = 5})
        audio.setVolume(contentsSFX, {channel = 6})
        io.close( fileHandleSFX )
    end
end

-- Funzione per il suono sponda
local function ballHitShore(event)
    local collidedObject = event.other
    if event.phase=="began" then
        if collidedObject.name=="hitbox" then
            audio.play(SFX_shore, {channel = 2})
        end
    end
end

-- Funzione per il suono tra palline
local function ballHitBall(event)
    local collidedObject = event.other
    if event.phase=="began" then
        if collidedObject.name=="ball" then
            audio.play(SFX_ballVSball, {channel = 4})
        end
    end
end

    ---CHEAT AREA----
    local function debug_cheat(event)
        if event.keyName == "tab" then
            blackBall.x = 1574 
            blackBall.y = 586
            return true
        else
            return false
        end
    end

-----------------------------------------------------------------------------------------
-- SCENA --

-- create() → codice di precaricamento scena (pre-visualizzazione)
function scene:create(event)
    local sceneGroup = self.view 
    -- caricamento della mappa
    mapData = json.decodeFile(system.pathForFile("Risorse/Livelli/P1L1/map_P1L1.json", system.ResourceDirectory))

    -- caricamento file volumi
    pathSFX = system.pathForFile("/Risorse/Menu/Audio/sfx_level", system.DocumentDirectory)
    pathMusic = system.pathForFile("/Risorse/Menu/Audio/music_level", system.DocumentDirectory)

    -- caricamento file XP
    pathXP = system.pathForFile( "xp", system.DocumentsDirectory )

    -- caricamento livelli
    pathLevel = system.pathForFile( "level", system.DocumentsDirectory )
    lastLevel()

    -- qui ci sarebbe il load delle risorse ma dava problemi con reload
end

-- show() → codice eseguito poco prima della visualizzazione o durante visualizzazione della scena
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then  -- se la scena è quasi visualizzata. In questa sezione viene composta la scena (posizionamento risorse)
            -- qui ci sarebbe stato i posizionamento ma dava problemi con il reload

    elseif ( phase == "did" ) then -- se la scena è visualizzata...
        -- avvio e settaggio motore fisico
        physics.start() 
        physics.setGravity(0,0) 
        --physics.setDrawMode("hybrid") 

        -- caricamento degli effetti sonori + musica
        SFX_ballInHole = audio.loadSound("/Risorse/Livelli/P1L1/Palla buca.mp3")
        SFX_ballVSball = audio.loadSound("/Risorse/Livelli/P1L1/Palla contro palla.mp3")
        SFX_shore = audio.loadSound("/Risorse/Livelli/P1L1/Sponda.mp3")
        SFX_cue = audio.loadSound("/Risorse/Livelli/P1L1/Stecca.mp3")
        music = audio.loadSound("/Risorse/Livelli/P1L1/Musica.mp3")

        -- settaggio volume
        setVolumeSFX()
        setVolumeMusic()

        -- caricamento della mappa e inserimento in sceneGroup
        map = tiled.new(mapData, "Risorse/Livelli/P1L1") 
        sceneGroup:insert(map) 

        -- recupero del'XP attuale
        readXP()

        -- caricamento della pallina bianca, posizionamento, messa in primo piano, assegnazione del corpo fisico, attivazione del collisore
        whiteBall = display.newImageRect(sceneGroup, "/Risorse/Livelli/P1L1/Palla Bianca.png", 150, 150 )
        whiteBall.x = 659
        whiteBall.y = 589
        whiteBall:toFront()
        physics.addBody(whiteBall,"dynamic", {radius=20,density=10, friction=5, bounce=0.3})
        whiteBall.isFixedRotation = true 
        whiteBall.name = "ball"
        whiteBall.collision = whiteBallHoleCollision("white")
        whiteBall:addEventListener( "collision", whiteBallHoleCollision)
        whiteBall.collision = ballHitBall("white")
        whiteBall:addEventListener( "collision", ballHitBall)
        whiteBall.collision = ballHitShore("white")
        whiteBall:addEventListener( "collision", ballHitShore)

        -- caricamento della pallina nera, posizionamento, messa in primo piano, assegnazione del corpo fisico, attivazione del collisore
        blackBall = display.newImageRect(sceneGroup, "/Risorse/Livelli/P1L1/Palla Nera.png", 150, 150 )
        blackBall.x = 1508 
        blackBall.y = 589
        blackBall:toFront()
        physics.addBody(blackBall,"dynamic", {radius=20,density=10, friction=50, bounce=0,3})
        blackBall.linearDamping = 1.5
        blackBall.isFixedRotation = true 
        blackBall.name = "ball"
        blackBall.collision = blackBallHoleCollision("black")
        blackBall:addEventListener( "collision", blackBallHoleCollision)
        blackBall.collision = ballHitBall("black")
        blackBall:addEventListener( "collision", ballHitBall)
        blackBall.collision = ballHitShore("black")
        blackBall:addEventListener( "collision", ballHitShore)

        -- caricamento della stecca
        cue = display.newImageRect(sceneGroup, "/Risorse/Livelli/P1L1/SteccaP1.png", 26, 721)
        cue.anchorY = 0
        cue.x = 135
        cue.y = 240
        cue:toFront()

        -- caricamento pulsante reset, posizionamento, messa in primo piano, attivazione del listener
        resetButton = display.newImageRect(sceneGroup, "/Risorse/Livelli/P1L1/Freccia Bianca.png", 88, 88) 
        resetButton.x = 1724 
        resetButton.y = 46
        resetButton:toFront() 
        resetButton:addEventListener("tap", goToReload)

        -- caricamento pulsante home, posizionamento, messa in primo piano, attivazione del listener
        homeButton = display.newImageRect(sceneGroup, "/Risorse/Livelli/P1L1/Casa.png", 88, 88)
        homeButton.x = 1844 
        homeButton.y = 46
        homeButton:toFront() 
        homeButton:addEventListener("tap", goToHome)

        -- recupero della buca e identificazione come sensore
        hole = map:findObject(hole) 
        hole.isSensor = true

        -- associazione all'evento touch la funzione drawLine
        Runtime:addEventListener("touch", checkY) 
        Runtime:addEventListener("touch", angleCalc)

    end
end

-- hide() → codice eseguito subito dopo o dopo la visualizzazione della scena
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- codice da eseguire quando sta per uscire la scena dalla visualizzazione (es. mettere in pausa il motore fisico)
        physics.stop()
    elseif ( phase == "did" ) then
        -- codice da eseguire una volta uscita la scena (in genere non si mette nulla qui)
    end
end

-- destroy() → codice per distruggere la scena (e ottimizzare le risorse hardware)
function scene:destroy(event)
    local sceneGroup = self.view

end


-----------------------------------------------------------------------------------------


-- GESTIONE ASCOLTATORI E RETURN SCENA
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

    ---CHEAT AREA---
    Runtime:addEventListener("key", debug_cheat)


return scene