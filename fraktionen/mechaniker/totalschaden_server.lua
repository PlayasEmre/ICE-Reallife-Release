--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre and n0pe                ||
--||   Version: 5.0                                   ||
--\\                                                  //

local function addTotalschadenToVehicle(veh, owner, Slot)
    if veh then
        if owner and Slot then
            setElementHealth(veh, 250)
            setVehicleDamageProof(veh, true)
            MtxSetElementData(veh, "totalschaden", 1)
			setVehicleEngineState ( veh, false )
			MtxSetElementData ( veh, "engine", false )
			dbExec ( handler, "UPDATE vehicles SET totalschaden = ?  WHERE UID=? AND Slot=?", 1, playerUID[owner], Slot ) 
			MtxSetElementData ( veh, "locked", true )
            local driver = getVehicleOccupant(veh, 0)
            if driver then
                outputChatBox("Dein Fahrzeug hat einen Totalschaden - Kontaktiere einen Mechaniker für Hilfe!", driver, 255, 255, 0)
            end
        end
    end
end

--[[addCommandHandler("removeT", function(player,cmd,target)
	local target = getPlayerFromName(target)
    local veh = getPedOccupiedVehicle(player)
	if isMechaniker(player) and veh and target then
		if MtxGetElementData(veh, "totalschaden") == 1 then
			if MtxGetElementData(target,"money") >= 1500 or MtxGetElementData(player,"money") >= 2000 then
				setElementHealth(veh, 1000)
				setVehicleDamageProof(veh, false)
				MtxSetElementData(veh, "totalschaden", 0)
				MtxSetElementData(target,"money",tonumber(MtxGetElementData(target,"money")) - 1500)
				MtxSetElementData(player,"money",tonumber(MtxGetElementData(player,"money")) + 2000)
				dbExec(handler, "UPDATE vehicles SET totalschaden = ? WHERE UID=? AND Slot=?", 0, playerUID[MtxGetElementData(veh, "owner")], MtxGetElementData(veh, "carslotnr_owner"))
				outputChatBox("Dein Motor wurde repariert", target, 255, 255, 0)
				outputChatBox("Sie erhalten betrag 2000 "..Tables.waehrung.."", player, 255, 255, 0)
				outputChatBox("Du hast deine Rechnung bezahlt! 1500 "..Tables.waehrung.."", target, 255, 255, 0)
			else outputChatBox("Du hast zu wenig Geld dabei! 1500 "..Tables.waehrung.."", target, 255, 255, 0) end
		else outputChatBox("Das Fahrzeug hat keinen Totalschaden!", player, 125, 0, 0) end
	end
end)--]]

addEventHandler("onVehicleDamage", root, function(loss)
    local owner = MtxGetElementData(source, "owner")
    local Slot = MtxGetElementData(source, "carslotnr_owner")
    if owner and Slot then
        if getElementHealth(source) - loss <= 250 then
            addTotalschadenToVehicle(source, owner, Slot)
        end
    end
end)