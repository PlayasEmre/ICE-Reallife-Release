--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local screenX, screenY = guiGetScreenSize ()
local reporterMapTimer = nil

local function drawTheMapForReporter ( )
	dxDrawImage ( 0, 0, screenX, screenY, ":"..getResourceName(getThisResource()).."/images/radar/map.jpg" )
end

local function hideReporterMap ( )
	removeEventHandler ( "onClientRender", root, drawTheMapForReporter )
end

-- Klammerfehler behoben (Datei war dadurch komplett kaputt/lud gar nicht).
-- Ausserdem: Karte blieb bisher fuer immer sichtbar (kein Weg, sie zu schliessen)
-- und stapelte bei mehrfachem Aufruf zusaetzliche Render-Handler. Jetzt: nicht
-- doppelt registrieren, automatisch nach 15 Sekunden ausblenden, und ein
-- manueller Befehl zum vorzeitigen Schliessen.
addCommandHandler ( "reporterstart", function ( )
	removeEventHandler ( "onClientRender", root, drawTheMapForReporter )
	addEventHandler ( "onClientRender", root, drawTheMapForReporter )
	if isTimer ( reporterMapTimer ) then
		killTimer ( reporterMapTimer )
	end
	reporterMapTimer = setTimer ( hideReporterMap, 15000, 1 )
end )

addCommandHandler ( "reporterstop", hideReporterMap )