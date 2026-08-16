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
			setVehicleLocked ( veh, true )
            local driver = getVehicleOccupant(veh, 0)
            if driver then
                outputChatBox("Dein Fahrzeug hat einen Totalschaden - Kontaktiere einen Mechaniker für Hilfe!", driver, 255, 255, 0)
            end
        end
    end
end

addEventHandler("onVehicleDamage", root, function(loss)
    local owner = MtxGetElementData(source, "owner")
    local Slot = MtxGetElementData(source, "carslotnr_owner")
    if owner and Slot then
        if getElementHealth(source) - loss <= 250 then
            addTotalschadenToVehicle(source, owner, Slot)
        end
    end
end)