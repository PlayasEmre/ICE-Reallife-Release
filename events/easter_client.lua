--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

-- Tabelle

local gHalloweenButton = {}


function closeHalloweenGUI ( )
	if isElement(gWindow["halloweenMenue"]) then
		destroyElement ( gWindow["halloweenMenue"] )
		showCursor ( false )
		setElementClicked ( false )
	end
end

function createHalloweenGUI (btn,state)

	if event.isHalloween then
	
		if getElementClicked () then
			return
		end

		showCursor ( true )
		setElementClicked ( true )
		
		local x, y = guiGetScreenSize()
		local windowx = x/2 - 627/2
		local windowy = y/2 - 221/2
        if btn == "left" and state == "down" then end
		gWindow["halloweenMenue"] = dgsCreateWindow( windowx, windowy, 627, 221, "Deine-Kürbis-Anzahl "..vioClientGetElementData ( "easterEggs" ).." ", false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
		gHalloweenButton[1] = dgsCreateButton( 10, 25, 147, 65, "Premium\nfuer 60 Kuerbisse", false, gWindow["halloweenMenue"] )
		gHalloweenButton[2] = dgsCreateButton( 10, 95, 147, 65, "Geld\nfuer 50 Kuerbisse", false, gWindow["halloweenMenue"] )
		gHalloweenButton[3] = dgsCreateButton( 162, 25, 147, 65, "Süßigkeiten\nfuer Kuerbisse 10", false, gWindow["halloweenMenue"] )
		gHalloweenButton[4] = dgsCreateButton( 162, 95, 147, 65, "", false, gWindow["halloweenMenue"] )
		gHalloweenButton[5] = dgsCreateButton( 314, 25, 147, 65, "", false, gWindow["halloweenMenue"] )
		gHalloweenButton[6] = dgsCreateButton( 314, 95, 147, 65, "", false, gWindow["halloweenMenue"] )
		gHalloweenButton[7] = dgsCreateButton( 467, 25, 147, 65, "", false, gWindow["halloweenMenue"] )
		gHalloweenButton[8] = dgsCreateButton( 467, 95, 147, 65, "", false, gWindow["halloweenMenue"] )
		gHalloweenButton[9] = dgsCreateButton( 601, -25, 25, 22,"×",false, gWindow["halloweenMenue"],tocolor(255,0,0,255),tocolor(255,0,0,255))
		dgsSetProperty(gHalloweenButton[9],"textSize",{1.6,1.6})
		
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[9],
			function ( )
				closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[1],
			function ( )
				triggerServerEvent ( "buyEasterBonus", lp, "premium" )
				closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[2],
			function ( )
				triggerServerEvent ( "buyEasterBonus", lp, "money" )
				closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[3],
			function ( )
				triggerServerEvent ( "buyEasterBonus", lp, "Süßigkeit" )
				 closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[4],
			function ( )
				--triggerServerEvent ( "buyEasterBonus", lp, "" )
				 closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[5],
			function ( )
				--triggerServerEvent ( "buyEasterBonus", lp, "" )
				  closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[6],
			function ( )
				--triggerServerEvent ( "buyEasterBonus", lp, "" )
				  closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[7],
			function ( )
				--triggerServerEvent ( "buyEasterBonus", lp, "" )
				  closeHalloweenGUI ( )
			end, false )
			
		addEventHandler ( "onDgsMouseClick", gHalloweenButton[8],
			function ( )
				--triggerServerEvent ( "buyEasterBonus", lp, "" )
				  closeHalloweenGUI ( )
			end, false )
	end
end
addCommandHandler("halloween",createHalloweenGUI)
bindKey("H","down",createHalloweenGUI)