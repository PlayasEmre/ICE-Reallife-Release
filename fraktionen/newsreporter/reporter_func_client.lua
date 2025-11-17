--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local screenX, screenY = guiGetScreenSize ()

local function drawTheMapForReporter ( )
	dxDrawImage ( 0, 0, screenX, screenY, ":"..getResourceName(getThisResource()).."/images/radar/map.jpg"
end 


addCommandHandler ( "reporterstart", function ( )
	addEventHandler ( "onClientRender", root, drawTheMapForReporter )
end )