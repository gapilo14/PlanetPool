-----------------------------------------------------------------------------------------
--
-- ***PLANET POOL***
-- Andrea Raccanelli, Federico Viol, Gabriele Pilotto
-- FILENAME: scena1.lua
-- LOCATION: .\Gioco\Risorse\Livelli\PostLevel\scena1.lua
-- DESCRIZIONE: prima scena dei titoli di coda
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
local function nextScene()
    composer.removeScene(".Risorse.Livelli.PostLevel.scena2")
    local options = {effect = "crossFade", time = 250}
	composer.gotoScene(".Risorse.Livelli.PostLevel.scena2", options)	
	return true
end

-----------------------------------------------------------------------------------------

-- SCENA --

-- create() → codice di precaricamento scena (pre-visualizzazione)
function scene:create(event)
    local sceneGroup = self.view
    img = display.newImageRect(sceneGroup, "/Risorse/Livelli/PostLevel/SF1.png", 1920, 1080 )
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
        timer.performWithDelay(2500, nextScene)
    end
end

-- GESTIONE ASCOLTATORI E RETURN SCENA
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene