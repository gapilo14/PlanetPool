-----------------------------------------------------------------------------------------
--
-- ***PLANET POOL***
-- Andrea Raccanelli, Federico Viol, Gabriele Pilotto
-- FILENAME: scena4.lua
-- LOCATION: .\Gioco\Risorse\Livelli\PostLevel\scena4.lua
-- DESCRIZIONE: quarta scena titoli di coda
--
-----------------------------------------------------------------------------------------

-- CARICAMENTO E SET UP LIBRERIE --

-- Libreria composer per gestione scene + creazione scena
local composer = require("composer")
local scene = composer.newScene()

-----------------------------------------------------------------------------------------

-- DICHIARAZIONI VARIABILI LOCALI --
local img
local XP
local button

-----------------------------------------------------------------------------------------

-- FUNZIONI --
local function exit()
    native.requestExit()
end

-- Funzione per la lettura dell'XP
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
-----------------------------------------------------------------------------------------

-- SCENA --

-- create() → codice di precaricamento scena (pre-visualizzazione)
function scene:create(event)
    local sceneGroup = self.view

    pathXP = system.pathForFile( "xp", system.DocumentsDirectory )
    readXP()

    img = display.newImageRect(sceneGroup, "/Risorse/Livelli/PostLevel/SF4.png", 1920, 1080 )
    button = display.newImageRect(sceneGroup, "/Risorse/Livelli/PostLevel/Tasto esci.png", 388, 154)
end

-- show() → codice eseguito poco prima della visualizzazione o durante visualizzazione della scena
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then  -- se la scena è quasi visualizzata...
        img.anchorX = 0
        img.anchorY = 0
        img.x = 0
        img.y = 0

        button.anchorX = 0
        button.anchorY = 0
        button.x = 766
        button.y = 852
        button:addEventListener("tap", exit)

        if XP ~= nil  then
            displayXP = display.newText(XP .." punti", display.contentCenterX, 666, "/Risorse/Moduli/DigitalDisco.ttf", 175)
            displayXP.align = "center"
        end

    elseif ( phase == "did" ) then
        
    end
end

-- GESTIONE ASCOLTATORI E RETURN SCENA
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene