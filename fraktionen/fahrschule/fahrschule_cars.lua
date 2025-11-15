fahrschulVehicles = {}

function fahrschuleVehicles(player,seat)
	local veh = source
	if seat == 0 and fahrschulVehicles[veh] == true then
	    --if not isFahrschuleDuty ( player ) and MtxGetElementData( player, "inpruefung") == true and isElementFrozen(veh) == true then
		    outputChatBox("Viel Spaß beim fahren", player, 125, 125, 0)
			outputChatBox("Man sollte in der Prüfung nicht das Fahrzeug verlassen", player, 125, 125, 0)
			setElementFrozen(veh,false)
			setVehicleDamageProof(veh, true)
		--elseif not isFahrschuleDuty ( player ) then
			--opticExitVehicle ( player )
			--outputChatBox ( "Du bist nicht als Fahrlehrer im Dienst", player, 125, 0, 0 )
		--end
	end
end
addEventHandler ( "onVehicleEnter",root,fahrschuleVehicles)

function createfahrschulVehicle ( model, x, y, z, rx, ry, rz )
	local veh = createVehicle ( model, x, y, z, rx, ry, rz )
	setVehicleColor ( veh, 224, 255, 255, 224, 255, 255, 224, 255, 255 )
	setVehiclePaintjob ( veh, 3 )
	setElementHealth ( veh, 1700 )
	toggleVehicleRespawn ( veh, true )
	setVehicleRespawnDelay ( veh, FCarDestroyRespawn * 1000 * 60 )
	setVehicleIdleRespawnDelay ( veh, FCarIdleRespawn * 1000 * 60 )
	fahrschulVehicles[veh] = true
	setElementFrozen(veh,true)
	addEventHandler ( "onVehicleExplode",veh,function()
		setTimer(createfahrschulVehicle, 1 * 60 * 1000, 1, model, x, y, z, rx, ry, rz)
	end)
end


createfahrschulVehicle(405,-1768.2,-132.0,3.4,0,0,270)
createfahrschulVehicle(405,-1768.2,-135.8,3.4,0,0,270)
createfahrschulVehicle(579,-1768.2,-139.9,3.5,0,0,270)
createfahrschulVehicle(579,-1768.2,-144.2,3.5,0,0,270)
createfahrschulVehicle(487,-1765.0,-179.6,3.6,0,0,270)
createfahrschulVehicle(487,-1765.0,-168.1,3.6,0,0,270)
createfahrschulVehicle(487,-1765.0,-157.4,3.6,0,0,270)
createfahrschulVehicle(515,-1708.9,-134.0,4.1,0,0,135)
createfahrschulVehicle(515,-1705.1,-137.8,4.1,0,0,135)
createfahrschulVehicle(468,-1737.3,-170.0,3.2,0,0,48)
createfahrschulVehicle(468,-1740.2,-172.8,3.2,0,0,48)
createfahrschulVehicle(468,-1743.3,-175.7,3.2,0,0,48)
createfahrschulVehicle(468,-1746.2,-178.4,3.2,0,0,48)
createfahrschulVehicle(446,-1768.4,-192.0,0.0,0,0,180)
createfahrschulVehicle(446,-1752.0,-192.0,0.0,0,0,180)
createVehicle(435,-1700.5,-125.7,4.1,0,0,135)
createVehicle(435,-1696.7,-129.4,4.1,0,0,135)