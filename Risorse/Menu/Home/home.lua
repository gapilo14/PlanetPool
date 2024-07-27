-----------------------------------------------------------------------------------------
--
-- ***PLANET POOL***
-- Andrea Raccanelli, Federico Viol, Gabriele Pilotto
-- FILENAME: level_P1L2.lua
-- LOCATION: .\.\Gioco\main.lua
-- DESCRIZIONE: file d'avvio gioco
--
-----------------------------------------------------------------------------------------

-- CARICAMENTO E SET UP LIBRERIE --

-- Libreria composer per gestione scene + creazione scena
local composer = require("composer")
local scene = composer.newScene()

-----------------------------------------------------------------------------------------

-- DICHIARAZIONI VARIABILI LOCALI --
local background
local play
local settings
local XP
local displayXP
local pathXP
local pathLevel
local actualXP
local level
local music

-----------------------------------------------------------------------------------------

-- FUNZIONI --
-- Funzione per accedere alle settings
local function goToSettings()
    composer.removeScene(".Risorse.Menu.Audio.volume")
    composer.gotoScene(".Risorse.Menu.Audio.volume")
    display.remove( displayXP )
end

-- Funzione per leggere il punteggio
local function readXP()
    local oldFileXP, errorString = io.open(pathXP, "r")
    if not oldFileXP then
        io.open(pathXP, "w")
        actualXP = 0
    else
        actualXP = oldFileXP:read("*n")
        io.close(oldFileXP)
        XP = actualXP
    end
    
    oldFileXP = nil
end

-- Funzione per recuperare l'ultimo livello giocato
local function lastLevel()
    local levelStatus, errorString = io.open(pathLevel, "r")
    if not levelStatus then
        io.open(pathLevel, "w")
        level = 1
    else
        nowLevel = levelStatus:read("*n")
        io.close(levelStatus)
        level = nowLevel
    end
    levelStatus = nil
end

local function setVolumeMusic()
    local fileHandleMusic, errorString = io.open(pathMusic, "r" )
    if not fileHandleMusic then
        print( "Errore Music: " .. errorString )
    else
        contentsMusic = fileHandleMusic:read("*n")
        audio.setVolume(contentsMusic, {channel = 1, loop = -1})
        io.close( fileHandleMusic )
    end
    if audio.isChannelPlaying(1) == false then
        audio.play(music)
    end
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


-- Funzione per l'avvio dell'ultimo livello
local function goToLevel()
    composer.removeScene(".Risorse.Livelli." .. levelDirectory .. ".reload")
    composer.gotoScene(".Risorse.Livelli." .. levelDirectory .. ".reload")
    display.remove( displayXP )
    audio.stop()
end
-----------------------------------------------------------------------------------------

-- SCENA --

-- create() → codice di precaricamento scena (pre-visualizzazione)
function scene:create(event)
    local sceneGroup = self.view
    background = display.newImageRect(sceneGroup, "/Risorse/Menu/Home/Sfondo.png", 1920, 1080)
    play = display.newImageRect(sceneGroup, "/Risorse/Menu/Home/Bottone Gioca.png", 342, 188)
    settings = display.newImageRect(sceneGroup, "/Risorse/Menu/Home/Icona impostazioni.png", 88, 88)
    music = audio.loadSound("/Risorse/Menu/Home/Musica.mp3")
    pathMusic = system.pathForFile("/Risorse/Menu/Audio/music_level", system.DocumentDirectory)


    -- caricamento file XP
    pathXP = system.pathForFile( "xp", system.DocumentsDirectory )
    readXP()
    
    -- caricamento livelli
    pathLevel = system.pathForFile( "level", system.DocumentsDirectory )
    lastLevel()
    
    -- Richiamo funzione per il percorso
    pathCalc()
    

end

-- show() → codice eseguito poco prima della visualizzazione o durante visualizzazione della scena
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then  -- se la scena è quasi visualizzata...
               
        background.x = display.contentCenterX
        background.y = display.contentCenterY

        if XP ~= nil  then
            displayXP = display.newText(XP .." punti", 153, 42, "/Risorse/Moduli/DigitalDisco.ttf", 60 )
        end
        
        settings.anchorX = 0
        settings.anchorY = 0
        settings.x = 1800
        settings.y = 2
        settings:addEventListener("tap", goToSettings)

        play.anchorX = 0
        play.anchorY = 0
        play.x = 789
        play.y = 673
        play:addEventListener("tap", goToLevel)

    elseif ( phase == "did" ) then -- se la scena è visualizzata..
        -- chiusura di tutte le scene in memoria per ottimizzazione
        setVolumeMusic()
        composer.removeHidden()
    end
end

-- GESTIONE ASCOLTATORI E RETURN SCENA
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene
