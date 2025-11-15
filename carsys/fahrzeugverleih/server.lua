--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local faggioroller = {}

function RentScooter_Func(player)
		local x,y,z = getElementPosition(player)
		
		if faggioroller[player] ~= nil then
			destroyElement(faggioroller[player])
			faggioroller[player] = nil
		end  
		
	if tonumber(MtxGetElementData(player,"wanteds")) == 0 then
		if MtxGetElementData(player,"money") >= 30 then
			MtxSetElementData(player,"money",tonumber(MtxGetElementData(player,"money")) - 30)
		if getDistanceBetweenPoints3D(-1983.5,167.5,27.7,getElementPosition(player)) < 10 then
			faggioroller[player] = createVehicle(462,-1986.1845703125,170.8291015625,27.6875,0,0,90,getPlayerName(player))
			MtxSetElementData(faggioroller[player],"owner",getPlayerName(player))
			setVehicleColor(faggioroller[player],0,255,0,0,255,0)
			setElementFrozen(faggioroller[player],true)
			setTimer(setElementFrozen,500,1,faggioroller[player],false)
			warpPedIntoVehicle(player,faggioroller[player])
			infobox(player,"Du hast dir ein Faggio ausgeliehen!",7500,0,255,0)
			infobox(player,"Du hast dein Faggio für 10 minuten ausgeliehen!",7500,0,255,0)
			triggerEvent("set:task",player,player,"give:Roller")
			destroyNewElement()
			removeEventHandler ( "onPlayerQuit", player, RestroyScooter_Func )
			addEventHandler ( "onPlayerQuit", player, RestroyScooter_Func )
			end
		else outputChatBox("Nicht genug Geld auf der Hand! 30 "..Tables.waehrung.."",player) end
	else outputChatBox("Da du Wanteds hast, kannst du keinen Roller leihen!",player) end
end
addEvent("onServerRentRoller",true)
addEventHandler("onServerRentRoller",root,RentScooter_Func)

function destroyNewElement()
	if isElement(faggioroller[player]) then
		setTimer(destroyElement,10*60*1000,1,faggioroller[player])
		faggioroller[player] = nil 
	end	
end

function RestroyScooter_Func(player,cmd)
	if(player and isElement(player)and getElementType(player)=="player")or(source and isElement(source)and getElementType(source)=="player")then
		if not isElement(player)then
			player=source
		end
		if cmd~="droller" then
			if faggioroller[player]then
				destroyElement(faggioroller[player])
				faggioroller[player]=nil
			end
		elseif isAdminLevel(player,2)then
			for i,v in pairs(faggioroller)do
				destroyElement(v)
				faggioroller[i]=nil
			end
			outputChatBox("Du hast alle Roller zerstört!",player,0,200,0)
		end
	elseif source and isElement(source)and getElementType(source)=="player" then
		if faggioroller[source]then
			destroyElement(faggioroller[source] )
			faggioroller[source]=nil
		end
	end
end