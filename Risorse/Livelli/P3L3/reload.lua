-----------------------------------------------------------------------------------------
--
-- ***PLANET POOL***
-- Andrea Raccanelli, Federico Viol, Gabriele Pilotto
-- FILENAME: reload.lua
-- LOCATION: .\Gioco\Risorse\Livelli\P3L3\reload.lua
-- DESCRIZIONE: scena intermedia per il ricaricamento del livello
--
-----------------------------------------------------------------------------------------

-- CARICAMENTO E SET UP LIBRERIE --

-- Libreria composer per gestione scene + creazione scena
local composer = require("composer")
local scene = composer.newScene()

-----------------------------------------------------------------------------------------

-- DICHIARAZIONI VARIABILI LOCALI --
local img

-----------------------------------------------------------------------------------------

-- FUNZIONI --
local function returnToLevel()
    composer.removeScene(".Risorse.Livelli.P3L3.level_P3L3")
    local options = {effect = "crossFade", time = 100}
	composer.gotoScene(".Risorse.Livelli.P3L3.level_P3L3", options)	
	return true
end

-----------------------------------------------------------------------------------------

-- SCENA --

-- create() → codice di precaricamento scena (pre-visualizzazione)
function scene:create(event)
    local sceneGroup = self.view
    img = display.newImageRect(sceneGroup, "/Risorse/Livelli/P3L3/Caricamento.png", 1920, 1080 )
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

    elseif ( phase == "did" ) then -- se la scena è visualizzata..
        timer.performWithDelay(250,returnToLevel)
    end
end

-- GESTIONE ASCOLTATORI E RETURN SCENA
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene