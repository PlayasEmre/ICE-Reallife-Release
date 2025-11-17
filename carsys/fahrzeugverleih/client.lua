--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local Scooterrental_SF_BHF_BuyMarker = createMarker(-1982.4754638672,168.45883178711,27.6875,"cylinder",-0.95,255,255,255,160)
local Scooter = {Window={},Button={},Gridlist={},GridlistColumn={},Label={},Edit={},Image={},Tabpanel={},Tab={},}

function openScooterBuy_GUI(player)
	if player == localPlayer then
		if getElementData(localPlayer,"ElementClicked") == false then
			if not isPedInVehicle(localPlayer) then
				showCursor(true)
				setElementData(localPlayer,"ElementClicked",true)
				Scooter.Window[1]=dgsCreateWindow(830,420,340,200,"Rollerverleih",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
				dgsWindowSetSizable(Scooter.Window[1],false)
				dgsWindowSetMovable(Scooter.Window[1],false)
				Scooter.Button[1]=dgsCreateButton(310,-25,30,25,"×",false,Scooter.Window[1],_,_,_,_,_,_,tocolor(200,50,50,255),tocolor(250,20,20,255),tocolor(150,50,50,255),true)
				dgsSetProperty(Scooter.Button[1],"textSize",{1.6,1.6})
				
				Scooter.Label[1]=dgsCreateLabel(10,20,200,60,"Hier kannst du dir ein Roller ausleihen Roller kostet 30 "..Tables.waehrung.."",false,Scooter.Window[1])
			
				Scooter.Button[2]=dgsCreateButton(60,100,230,45,"Roller ausleihen",false,Scooter.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),nil,nil,true)
			   
				
				addEventHandler("onDgsMouseClick",Scooter.Button[2],
					function(btn,state)
						if btn == "left" and state == "up" then
							dgsCloseWindow(Scooter.Window[1])
							showCursor(false)
							setElementData(localPlayer,"ElementClicked",false)
							triggerServerEvent("onServerRentRoller",localPlayer,localPlayer)
						end
					end,
				false)
				
				addEventHandler("onDgsMouseClick",Scooter.Button[1],
					function(btn,state)
						if btn == "left" and state == "up" then
							dgsCloseWindow(Scooter.Window[1])
							showCursor(false)
							setElementData(localPlayer,"ElementClicked",false)
						end
					end,
				false)
			end
		end
	end
end
addEventHandler("onClientMarkerHit",Scooterrental_SF_BHF_BuyMarker,openScooterBuy_GUI)