-----------------------------------------------------------------------------------------
--
-- ***PLANET POOL***
-- Andrea Raccanelli, Federico Viol, Gabriele Pilotto
-- FILENAME: volume.lua
-- LOCATION: .\Gioco\Risorse\Menu\Audio\volume.lua
-- DESCRIZIONE: Menù volumi gioco e crediti gioco
--
-----------------------------------------------------------------------------------------

-- CARICAMENTO E SET UP LIBRERIE --

-- Libreria composer per gestione scene + creazione scena
local composer = require("composer")
local scene = composer.newScene()

-----------------------------------------------------------------------------------------

-- DICHIARAZIONI VARIABILI LOCALI --

local bar1
local bar2
local contentsMusic
local contentsSFX
local homeButton
local leftMargin
local pathMusic
local pathSFX
local rightMargin
local sfondo
local slider1
local slider2
local volMusic
local volSFX

-----------------------------------------------------------------------------------------

-- DICHIARAZIONI FUNZIONI LOCALI --

-- Funzione per tornare alla home
local function goToHome(event)
    composer.removeScene(".Risorse.Menu.Home.home")
    composer.gotoScene(".Risorse.Menu.Home.home")
end

-- Funzione per scrivere nel file il nuovo valore del volume effetti
function writeSFX()
    local fileHandleSFX, errorString = io.open(pathSFX, "w+")
        if not fileHandleSFX then
            print( "File error: " .. errorString )
        else
            fileHandleSFX:write(volSFX)
            io.close( fileHandleSFX )
        end
end

-- Funzione per scrivere nel file il nuovo valore del volume musica
local function writeMusic()
    local fileHandleMusic, errorString = io.open(pathMusic, "w+")
        if not fileHandleMusic then
            print( "File error: " .. errorString )
        else
            fileHandleMusic:write(volMusic)
            io.close( fileHandleMusic )
        end
end

-- Funzione per muovere lo slider musica
local function moveSlider1(event)
  	if event.phase == "began" then
        slider1.offsetX = event.x - slider1.x
        display.currentStage:setFocus(slider1)
    end
	
	if event.phase == "moved" then
		if slider1.x <= rightMargin and slider1.x >= leftMargin then
			slider1.x = event.x-slider1.offsetX
		end
		if slider1.x > rightMargin then
			slider1.x = rightMargin
        end
		if slider1.x < leftMargin then
		    slider1.x = leftMargin
		end
	end

    volMusic = (slider1.x-1181)/487

	if event.phase == "ended" then
	    display.currentStage:setFocus(nil)
        writeMusic()
	end
    return true
end

-- Funzione per muovere lo slider SFX
local function moveSlider2(event)
    if event.phase == "began" then
        slider2.offsetX = event.x - slider2.x
        display.currentStage:setFocus(slider2)
    end

    if event.phase == "moved" then
        if slider2.x <= rightMargin and slider2.x >= leftMargin then
            slider2.x = event.x-slider2.offsetX
        end
        if slider2.x > rightMargin then
            slider2.x = rightMargin
        end
        if slider2.x < leftMargin then
            slider2.x = leftMargin
        end
    end

    volSFX = (slider2.x-1181)/487

    if event.phase == "ended" then
        display.currentStage:setFocus(nil)
        writeSFX()
    end
    return true
end

-----------------------------------------------------------------------------------------

-- SCENA --

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then         

    elseif ( phase == "did" ) then 

        -- Percorsi per l'accesso dei files
        pathSFX = system.pathForFile("/Risorse/Menu/Audio/sfx_level", system.DocumentDirectory)
        pathMusic = system.pathForFile("/Risorse/Menu/Audio/music_level", system.DocumentDirectory)

        -- Recupero livelli SFX salvati
        local fileHandleSFX, errorString = io.open(pathSFX, "r")
        if not fileHandleSFX then
            print( "Errore SFX: " .. errorString )
        else
            contentsSFX = fileHandleSFX:read("*n")
            volSFX = contentsSFX
            io.close( fileHandleSFX )
        end

        -- Recupero livelli musica salvati
        local fileHandleMusic, errorString = io.open(pathMusic, "r" )
        if not fileHandleMusic then
            print( "Errore Music: " .. errorString )
        else
            contentsMusic = fileHandleMusic:read("*n")
            volMusic = contentsMusic
            io.close( fileHandleMusic )
        end

        -- Posizionamento e caricamento dello sfondo
        sfondo = display.newImageRect(sceneGroup, "/Risorse/Menu/Audio/Sfondo.png", 1920, 1080)
        sfondo.x = display.contentCenterX
        sfondo.y = display.contentCenterY

        -- Posizionamento, caricamento, messa in primo piano della barra musica
        bar1 = display.newImageRect(sceneGroup, "/Risorse/Menu/Audio/Bar.png", 587, 52)
        bar1.anchorX = 0
        bar1.anchorY = 0
        bar1.x = 1131
        bar1.y = 206
        bar1:toFront()

        -- Posizionamento, caricamento, messa in primo piano della barra SFX
        bar2 = display.newImageRect(sceneGroup, "/Risorse/Menu/Audio/Bar.png", 587, 52)
        bar2.anchorX = 0
        bar2.anchorY = 0
        bar2.x = 1131
        bar2.y = 307
        bar2:toFront()

        -- Posizionamento, caricamento, messa in primo piano dello slider musica
        slider1 = display.newImageRect(sceneGroup, "/Risorse/Menu/Audio/Slider.png", 33, 83)
        slider1.x = (volMusic*487)+1181 -- il valore muta al variare del volume salvato nella path
        slider1.anchorY = 0
        slider1.y = 191
        slider1:toFront()
        
        -- Posizionamento, caricamento, messa in primo piano dello slider sfx
        slider2 = display.newImageRect(sceneGroup, "/Risorse/Menu/Audio/Slider.png", 33, 83)
        slider2.x = (volSFX*487)+1181 -- il valore muta al variare del volume salvato nella path
        slider2.anchorY = 0
        slider2.y = 292
        slider2:toFront()

        -- caricamento pulsante home, posizionamento, messa in primo piano, attivazione del listener
        homeButton = display.newImageRect(sceneGroup, "/Risorse/Menu/Audio/Casa.png", 88, 88)
        homeButton.x = 1844 
        homeButton.y = 46
        homeButton:toFront() 
        homeButton:addEventListener("tap", goToHome)

        -- Assegnazione valori massimi e minimi per lo spostamento dello slider
        leftMargin = 1181
        rightMargin = 1668

        -- Assegnazione listener per gli sliders
        slider1:addEventListener("touch",moveSlider1) 
        slider2:addEventListener("touch",moveSlider2)
    end
end

-----------------------------------------------------------------------------------------

-- GESTIONE ASCOLTATORI E RETURN SCENA
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene