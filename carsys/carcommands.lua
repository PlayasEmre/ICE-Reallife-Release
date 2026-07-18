--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

vehBlipColor = {}
	vehBlipColor["r"] = {}
	vehBlipColor["g"] = {}
	vehBlipColor["b"] = {}
		color = 1
		vehBlipColor["r"][color] = 255
		vehBlipColor["g"][color] = 0
		vehBlipColor["b"][color] = 0
		color = color + 1
		vehBlipColor["r"][color] = 0
		vehBlipColor["g"][color] = 255
		vehBlipColor["b"][color] = 0
		color = color + 1
		vehBlipColor["r"][color] = 0
		vehBlipColor["g"][color] = 0
		vehBlipColor["b"][color] = 255
		color = color + 1
		vehBlipColor["r"][color] = 0
		vehBlipColor["g"][color] = 0
		vehBlipColor["b"][color] = 0
		color = color + 1
		vehBlipColor["r"][color] = 255
		vehBlipColor["g"][color] = 255
		vehBlipColor["b"][color] = 255
		color = color + 1
		vehBlipColor["r"][color] = 255
		vehBlipColor["g"][color] = 255
		vehBlipColor["b"][color] = 0
		color = color + 1
		vehBlipColor["r"][color] = 255
		vehBlipColor["g"][color] = 0
		vehBlipColor["b"][color] = 255
		color = color + 1
		vehBlipColor["r"][color] = 0
		vehBlipColor["g"][color] = 255
		vehBlipColor["b"][color] = 255
		color = color + 1
		vehBlipColor["r"][color] = 125
		vehBlipColor["g"][color] = 125
		vehBlipColor["b"][color] = 125
		color = color + 1
		vehBlipColor["r"][color] = 255
		vehBlipColor["g"][color] = 150
		vehBlipColor["b"][color] = 0
		color = color + 1
		color = nil

		
function respawnPrivVeh ( carslot, pname )
	local carslot = tonumber ( carslot )
	local vehicle = allPrivateCars[pname][carslot] or false
	if isElement ( vehicle ) then
		if MtxGetElementData ( vehicle, "special" ) == 2 then 
			detachElements ( objectYacht[pname][carslot], vehicle )
			destroyElement ( objectYacht[pname][carslot] )
			special = 2
		end
		destroyMagnet ( vehicle )
		dbExec ( handler, "UPDATE vehicles SET ??=? WHERE ??=? AND ??=?", "Benzin", MtxGetElementData(vehicle,"fuelstate"), "UID", playerUID[pname], "Slot", carslot )
		destroyElement ( vehicle )
	end
	local dsatz = dbPoll ( dbQuery ( handler, "SELECT * from vehicles WHERE UID = ? AND Slot = ?", playerUID[pname], carslot ), -1 )
	if dsatz and dsatz[1] then	
		dsatz = dsatz[1]
		local Besitzer = playerUIDName[tonumber(dsatz["UID"])]
		local Typ = tonumber ( dsatz["Typ"] )
		local Tuning = dsatz["Tuning"]
		local Spawnpos_X = tonumber ( dsatz["Spawnpos_X"] )
		local Spawnpos_Y = tonumber ( dsatz["Spawnpos_Y"] )
		local Spawnpos_Z = tonumber ( dsatz["Spawnpos_Z"] )
		local Spawnrot_X = tonumber ( dsatz["Spawnrot_X"] )
		local Spawnrot_Y = tonumber ( dsatz["Spawnrot_Y"] )
		local Spawnrot_Z = tonumber ( dsatz["Spawnrot_Z"] )
		local Farbe = dsatz["Farbe"]
		local LFarbe = dsatz["Lights"]
		local Paintjob = tonumber ( dsatz["Paintjob"] )
		local Benzin = tonumber ( dsatz["Benzin"] )
		local Distanz = tonumber ( dsatz["Distance"] )
		local STuning = dsatz["STuning"]
		local Spezcolor = dsatz["spezcolor"]
		local Sportmotor = tonumber (dsatz["Sportmotor"])
		local Bremse = tonumber (dsatz["Bremse"] )
		local Antrieb = dsatz["Antrieb"]
		local PlateText = dsatz["plate"]
		local totalschaden = tonumber (dsatz["totalschaden"])
		local Beschlagnahmt = tonumber (dsatz["Beschlagnahmt"])
		local KeyTarget = tonumber (dsatz["KeyTarget"])
		vehicle = createVehicle ( Typ, Spawnpos_X, Spawnpos_Y, Spawnpos_Z, 0, 0, 0, Besitzer )
		allPrivateCars[pname][carslot] = vehicle
		MtxSetElementData ( vehicle, "owner", Besitzer )
		MtxSetElementData ( vehicle, "name", vehicle )
		MtxSetElementData ( vehicle, "carslotnr_owner", carslot )
		MtxSetElementData ( vehicle, "locked", true )
		MtxSetElementData ( vehicle, "color", Farbe )
		MtxSetElementData ( vehicle, "lcolor", LFarbe )
		MtxSetElementData ( vehicle, "spawnpos_x", Spawnpos_X )
		MtxSetElementData ( vehicle, "spawnpos_y", Spawnpos_Y )
		MtxSetElementData ( vehicle, "spawnpos_z", Spawnpos_Z )
		MtxSetElementData ( vehicle, "spawnrot_x", Spawnrot_X )
		MtxSetElementData ( vehicle, "spawnrot_y", Spawnrot_Y )
		MtxSetElementData ( vehicle, "spawnrot_z", Spawnrot_Z )
		MtxSetElementData ( vehicle, "distance", Distanz )
		MtxSetElementData ( vehicle, "stuning", STuning )
		MtxSetElementData ( vehicle, "spezcolor", Spezcolor )
		setVehiclePlateText( vehicle, PlateText )
		MtxSetElementData ( vehicle, "rcVehicle", tonumber ( dsatz["rc"] ) )
		MtxSetElementData ( vehicle, "sportmotor", Sportmotor )
		MtxSetElementData ( vehicle, "bremse", Bremse )
		MtxSetElementData ( vehicle, "antrieb", Antrieb )
		setVehicleLocked ( vehicle, true )
		MtxSetElementData ( vehicle, "fuelstate", Benzin )
		MtxSetElementData ( vehicle, "totalschaden", totalschaden )
		MtxSetElementData ( vehicle, "Beschlagnahmt", Beschlagnahmt )
        MtxSetElementData ( vehicle, "KeyTarget", KeyTarget ) 
		setPrivVehCorrectColor ( vehicle )
		setPrivVehCorrectLightColor ( vehicle )
		setVehiclePaintjob ( vehicle, Paintjob )
		if special == 2 then
			objectYacht[pname][carslot] = createObject ( 1337, 0, 0, 0 )
			attachElements ( objectYacht[pname][carslot], vehicle, 0, 2, 1.55 )
			setElementDimension (objectYacht[pname][carslot], 1 )
		end
		giveSportmotorUpgrade ( vehicle )
		setVehicleRotation ( vehicle, Spawnrot_X, Spawnrot_Y, Spawnrot_Z )
		pimpVeh ( vehicle, Tuning )
		setVehicleAsMagnetHelicopter ( vehicle )
		return true
	end
	return false
end

function towveh_func ( player, command, towcar)
	if towcar == nil then
		triggerClientEvent ( player, "infobox_start", player, "Gebrauch:\n/towveh\n[Fahrzeugnummer]", 5000, 125, 0, 0 )
	else
		if MtxGetElementData ( player, "carslot"..towcar ) and tonumber(MtxGetElementData ( player, "carslot"..towcar )) >= 1 then
			local pname = getPlayerName ( player )
			local veh = allPrivateCars[pname][tonumber(towcar)] or false
			if MtxGetElementData(veh, "Beschlagnahmt") ~= 1 then
			if MtxGetElementData(veh, "totalschaden") ~= 1 then
			if MtxGetElementData ( player, "money" ) >= 20 then
				if respawnPrivVeh ( towcar, pname ) then
					MtxSetElementData ( player, "money", MtxGetElementData ( player, "money" ) - 20 )
					triggerClientEvent ( player, "infobox_start", player, "\nDu hast dein\nFahrzeug respawnt!", 5000, 0, 255, 0 )
				else
					triggerClientEvent ( player, "infobox_start", player, "\nDas Fahrzeug ist\nnicht leer!", 5000, 125, 0, 0 )
				end
			else
				triggerClientEvent ( player, "infobox_start", player, "\nDu hast nicht\ngenug Geld!", 5000, 125, 0, 0 )
			end
		else
			outputChatBox ("Dein Fahrzeug hat einen Totalschaden - Kontaktiere einen Mechaniker für Hilfe!",player,125, 0, 0 )
		end
		else
			outputChatBox ("Dein Fahrzeug (Slot: "..towcar..") \nwurde abgeschleppt!\n Du kannst es am Mechanikerbase\n freikaufen.",player,125, 0, 0)
		end
		else
			triggerClientEvent ( player, "infobox_start", player, "\nDu hast kein\nFahrzeug mit\ndieser Nummer!", 5000, 125, 0, 0 )
		end
	end
end	
addEvent ( "respawnPrivVehClick", true )
addEventHandler ( "respawnPrivVehClick", getRootElement(), towveh_func )
addCommandHandler ( "towveh", towveh_func )

function sellcarto_func ( player, cmd, target, price, pSlot )
	local target = target and getPlayerFromName ( target ) or false
	if target and pSlot and tonumber ( pSlot ) then
		local pSlot = tonumber ( pSlot )
		local tSlot = getFreeCarSlot ( target )
		local pname = getPlayerName ( player )
		local result = dbPoll ( dbQuery ( handler, "SELECT AuktionsID FROM vehicles WHERE ??=? AND ??=?", "UID", playerUID[pname], "Slot", pslot ), -1 )
		if not result or not result[1] or tonumber ( result[1]["AuktionsID"] ) == 0 then
			if tSlot and MtxGetElementData ( target, "carslot"..tSlot ) == 0 and MtxGetElementData ( player, "carslot"..pSlot ) > 0 then
				local veh = allPrivateCars[pname][pSlot] or false
				if tonumber ( price ) then
					price = math.abs ( math.floor ( tonumber ( price ) ) )
					if isElement ( veh ) then
						if MtxGetElementData ( target, "curcars" ) < MtxGetElementData ( target, "maxcars" ) then	
							local model = getElementModel ( veh )
							local stunings = sTuningsToString ( veh )
							outputChatBox ( getPlayerName ( player ).." bietet dir folgendes Fahrzeug für "..price.." "..Tables.waehrung.." an: "..getVehicleName ( veh ), target, 0, 125, 0 )
							outputChatBox ( "Tunings: "..stunings, target, 0, 125, 0 )
							outputChatBox ( "Tippe /buy car, um das Fahrzeug zu kaufen.", target, 0, 125, 0 )
							outputChatBox ( "Du hast "..getPlayerName ( target ).." dein Fahrzeug aus Slot Nr. "..pSlot.." angeboten.", player, 200, 200, 0 )							
							
							MtxSetElementData ( target, "carToBuyFrom", player )
							MtxSetElementData ( target, "carToBuySlot", tonumber ( pSlot ) )
							MtxSetElementData ( target, "carToBuyPrice", price )
							MtxSetElementData ( target, "carToBuyModel", getElementModel ( veh ) )
							outputLog ( getPlayerName ( player ).." hat ein Auto an Spieler angeboten ( "..getVehicleName ( veh ) .. " - " .. getPlayerName ( target ).." )", "vehicle" )
						else
							outputChatBox ( "Der Spieler hat keinen freien Fahrzeugslot mehr!", player, 125, 0, 0 )
						end
					else
						outputChatBox ( "Ungültiges Fahrzeug oder nicht respawnt! Gebrauch: /sellcarto [Name] [Preis] [Eigener Slot]", player, 125, 0, 0 )
					end
				else
					outputChatBox ( "Ungültiger Preis! Gebrauch: /sellcarto [Name] [Preis] [Eigener Slot]", player, 125, 0, 0 )
				end
			else
				outputChatBox ( "Ungültiger Fahrzeugslot! Gebrauch: /sellcarto [Name] [Preis] [Eigener Slot]", player, 125, 0, 0 )
			end
		else
			outputChatBox ( "Dieses Fahrzeuge wird momentan versteigert!", player, 125, 0, 0 )
		end
	else
		outputChatBox ( "Gebrauch: /sellcarto [Name] [Preis] [Eigener Slot]", player, 125, 0, 0 )
	end
end
addCommandHandler ( "sellcarto", sellcarto_func )


function respawnVeh_func ( towcar, pname, veh )
	if towcar then
		respawnPrivVeh ( towcar, pname )
	else
		if not getVehicleOccupant ( veh ) then
			respawnVehicle ( veh )
			setElementDimension ( veh, 0 )
			setElementInterior ( veh, 0 )
        end
    end
end
addEvent ( "respawnVeh", true )
addEventHandler ( "respawnVeh", getRootElement(), respawnVeh_func )


function deleteVeh_func ( towcar, pname, veh, reason )
	local admin = getPlayerName ( source )
	if MtxGetElementData ( source, "adminlvl" ) >= 3 then
		local towcar = tonumber ( towcar )
		local player = getPlayerFromName ( pname )
		if player then
			outputChatBox ( "Dein Fahrzeug in Slot Nr. "..towcar.." wurde von "..admin.." gelöscht ("..reason..")!", player, 125, 0, 0 )
			MtxSetElementData ( player, "carslot"..towcar, 0 )
			allPrivateCars[pname][towcar] = nil
		else
			offlinemsg ( "Dein Fahrzeug in Slot Nr. "..towcar.." wurde von "..admin.." gelöscht("..reason..")!", "Server", pname )
		end
		outputLog ( "Fahrzeug von "..pname.." ( "..towcar.." ) wurde von "..admin.." gelöscht. | Modell: "..getElementModel(veh).." |", "autodelete" )
		destroyElement ( veh )
		dbExec ( handler, "DELETE FROM ?? WHERE ??=? AND ??=?", "vehicles", "UID", playerUID[pname], "Slot", towcar )
	end
end
addEvent ( "deleteVeh", true )
addEventHandler ( "deleteVeh", getRootElement(), deleteVeh_func )


function park_func ( player, command )
	if getPedOccupiedVehicleSeat ( player ) == 0 then
		local veh = getPedOccupiedVehicle ( player )
		if isElement ( veh ) and MtxGetElementData ( veh, "owner" ) == getPlayerName ( player ) or MtxGetElementData(veh, "KeyTarget") == playerUID[getPlayerName(player)]  or MtxGetElementData ( player, "adminlvl" ) >= 5 then
			if isTrailerInParkingZone ( veh ) then
				local x, y, z = getElementPosition ( veh )
				local rx, ry, rz = getVehicleRotation ( veh )
				local c1, c2, c3, c4 = getVehicleColor ( veh )
				MtxSetElementData ( veh, "spawnposx", x )
				MtxSetElementData ( veh, "spawnposy", y )
				MtxSetElementData ( veh, "spawnposz", z )
				MtxSetElementData ( veh, "spawnrotx", rx )
				MtxSetElementData ( veh, "spawnroty", ry )
				MtxSetElementData ( veh, "spawnrotz", rz )
				MtxSetElementData ( veh, "color1", c1 )
				MtxSetElementData ( veh, "color2", c2 )
				MtxSetElementData ( veh, "color3", c3 )
				MtxSetElementData ( veh, "color4", c4 )
				outputChatBox ( "Fahrzeug geparkt!", player, 0, 255, 0 )
			
				local Spawnpos_X, Spawnpos_Y, Spawnpos_Z = getElementPosition ( veh )
				local Spawnrot_X, Spawnrot_Y, Spawnrot_Z = getVehicleRotation ( veh )
				local Farbe1, Farbe2, Farbe3, Farbe4 =  getVehicleColor ( veh )
				local color = "|"..Farbe1.."|"..Farbe2.."|"..Farbe3.."|"..Farbe4.."|"
				local Paintjob = getVehiclePaintjob ( veh ) or 3
				local Benzin = MtxGetElementData ( veh, "fuelstate" )
				local pname = MtxGetElementData ( veh, "owner" )
				local Distance = MtxGetElementData ( veh, "distance" )
				local slot = MtxGetElementData ( veh, "carslotnr_owner" )
				
				dbExec ( handler, "UPDATE vehicles SET Spawnpos_X=?, Spawnpos_Y=?, Spawnpos_Z=?, Spawnrot_X=?, Spawnrot_Y=?, Spawnrot_Z=?, Farbe=?, Paintjob=?, Benzin=?, Distance=? WHERE UID=? AND Slot=?", Spawnpos_X, Spawnpos_Y, Spawnpos_Z, Spawnrot_X, Spawnrot_Y, Spawnrot_Z, color, Paintjob, Benzin, Distance, playerUID[pname], slot ) 
			else
				outputChatBox ( "Dieses Fahrzeug kannst du nicht in der Stadt parken!", player, 125, 0, 0 )
			end
		else
			outputChatBox ( "Dieses Fahrzeug gehört dir nicht!", player, 255, 0, 0 )
		end
	else
		outputChatBox ( "Du musst in einem Fahrzeug sitzen!", player, 255, 0, 0 )
	end
end
addCommandHandler ( "park", park_func )


function lock(player, cmd, target, locknr)
	local veh = allPrivateCars[target][tonumber(locknr)] or false
	if MtxGetElementData(veh, "KeyTarget") == playerUID[getPlayerName(player)] then
		if MtxGetElementData ( veh, "locked" ) then
			MtxSetElementData ( veh, "locked", false )
			triggerClientEvent(player, "locksound", player)
			setVehicleLocked ( veh, false )
			setElementFrozen ( veh, false )
			outputChatBox ( "Fahrzeug Aufgeschlossen!", player, 0, 0, 255 )
		elseif not MtxGetElementData ( veh, "locked" ) then
			MtxSetElementData ( veh, "locked", true )
			triggerClientEvent(player, "locksound", player)
			setVehicleLocked ( veh, true )
			setElementFrozen ( veh, true )
			outputChatBox ( "Fahrzeug Abgeschlossen!", player, 0, 0, 255 )
		end
	end
end
addCommandHandler("tlock", lock)


function lock_func ( player, command, locknr )
	if locknr == nil then
		outputChatBox ( "Gebrauch: /lock [Fahrzeugnummer]", player, 255, 0, 0 )
	else
		if MtxGetElementData ( player, "carslot"..locknr ) and tonumber(MtxGetElementData ( player, "carslot"..locknr )) >= 1 then
			local pname = getPlayerName ( player )
			local veh = allPrivateCars[pname][tonumber(locknr)] or false
			if isElement ( veh ) then
				if MtxGetElementData ( veh, "locked" ) then
					MtxSetElementData ( veh, "locked", false )
					triggerClientEvent(player, "locksound", player)
					setVehicleLocked ( veh, false )
					setElementFrozen(veh, false)
					outputChatBox ( "Fahrzeug Aufgeschlossen!", player, 0, 0, 255 )
				elseif not MtxGetElementData ( veh, "locked" ) then
					MtxSetElementData ( veh, "locked", true )
					triggerClientEvent(player, "locksound", player)
					setVehicleLocked ( veh, true )
					if not getVehicleOccupant(veh) then
						setElementFrozen(veh, true)
					end
					outputChatBox ( "Fahrzeug Abgeschlossen!", player, 0, 0, 255 )
				end
			else
				outputChatBox ( "Bitte respawne dein Fahrzeug zuerst!", player, 255, 0, 0 )
			end
		else
			outputChatBox ( "Du hast kein Fahrzeug mit diesem Namen!", player, 255, 0, 0 )
		end
	end
end
addEvent ( "lockPrivVehClick", true )
addEventHandler ( "lockPrivVehClick", getRootElement(), lock_func )
addCommandHandler ( "lock", lock_func )


function vehinfos_func ( player )
	local curcars = MtxGetElementData ( player, "curcars" )
	local maxcars = MtxGetElementData ( player, "maxcars" )
	if curcars and maxcars then
		outputChatBox ( "Momentan im Besitz: "..curcars.." Fahrzeuge von maximal "..maxcars, player, 0, 0, 255  )
		local pname = getPlayerName ( player )
		color = 0
		for i = 1, maxcars do
			carslotname = "carslot"..i
			if MtxGetElementData ( player, carslotname ) ~= 0 then
				local veh = allPrivateCars[pname][i] or false
				if isElement ( veh ) then
					local x, y, z = getElementPosition( veh )
					if MtxGetElementData ( veh, "gps" ) then
						color = color + 1
						local blip = createBlip ( x, y, z, 0, 2, vehBlipColor["r"][color], vehBlipColor["g"][color], vehBlipColor["b"][color], 255, 0, 99999.0, player )
						setTimer ( destroyElement, 10000, 1, blip )
						outputChatBox ( "Slot NR "..i..": "..getVehicleName ( veh )..", steht momentan in "..getZoneName( x,y,z )..", "..getZoneName( x,y,z, true ), player, vehBlipColor["r"][color], vehBlipColor["g"][color], vehBlipColor["b"][color] )
					else
						outputChatBox ( "Slot NR "..i..": "..getVehicleName ( veh )..", steht momentan in "..getZoneName( x,y,z )..", "..getZoneName( x,y,z, true ), player, 0, 0, 200 )
					end
				else
					local result = dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=? AND ??=?", "AuktionsID", "vehicles", "UID", playerUID[pname], "Slot", i ), -1 )
					if result and result[1] and result[1]["AuktionsID"] == "1" then
						outputChatBox ( "Dein Fahrzeug in Slot NR "..i.." muss zuerst mit /towveh "..i.." respawned werden!", player, 125, 0, 0 )
					elseif result and result[1] then
						outputChatBox ( "Dein Fahrzeug in Slot NR "..i.." steht momentan zum Verkauf!", player, 125, 0, 0 )
					end
				end
			end
		end
	end
end
addCommandHandler ( "vehinfos", vehinfos_func )


function vehhelp_func ( player )
	outputChatBox ( "--- Fahrzeughilfe ---", player, 0, 0, 255 )
	outputChatBox ( "/towveh [Nummer] zum Respawnen am Parkort", player, 255, 0, 255 )
	outputChatBox ( "/lock [Nummer] zum Oeffnen/Schliessen", player, 255, 0, 255 )
	outputChatBox ( "/tlock [Name] [Nummer] zum Oeffnen/Schliessen", player, 255, 0, 255 )
	outputChatBox ( "/park zum Parken", player, 255, 0, 255 )
	outputChatBox ( "/vehinfos zum Anzeigen aller Aktueller Fahrzeuge", player, 255, 0, 255 )
	outputChatBox ( "/sellcar [Nummer] zum verkaufen des Autos ( 75% der Kosten werden erstattet )", player, 255, 0, 255 )
	outputChatBox ( "/sellcarto [Name] [Preis] [Slot zum verkaufen des Autos an einen Spieler", player, 255, 0, 255 )
	outputChatBox ( "/buycar zum Annehmen eines Angebotes", player, 255, 0, 255 )
	outputChatBox ( "/givekey [Spieler] [Eigener Slot], um das Auto weiterzugeben", player, 255, 0, 255 )
	outputChatBox ( "/clearvehKey Von einem Spieler das Autoschlüssel entfernen", player, 255, 0, 255 )
	outputChatBox ( "/break um die Handbremse zu betätigen", player, 255, 0, 255 )
end
addCommandHandler ( "vehhelp", vehhelp_func )


function sellcar_func ( player, cmd, slot )
	if slot then
		local slot = tonumber(slot)
		if MtxGetElementData ( player, "carslot"..slot ) > 0 then
			local pname = getPlayerName(player)
			local veh = allPrivateCars[pname][slot] or false
			if isElement ( veh ) then
				local result = dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=? AND ??=?", "AuktionsID", "vehicles", "UID", playerUID[pname], "Slot", slot ), -1 )
				if result and result[1] and tonumber ( result[1]["AuktionsID"] ) == 0 then
					destroyMagnet ( veh )
					local model = getElementModel ( veh )
					local price = carprices[model]
					if not price then
						price = 0
					end
					MtxSetElementData ( player, "carslot"..slot, 0 )
					allPrivateCars[pname][slot] = nil
					local spawnx = MtxGetElementData ( player, "spawnpos_x" )
					if spawnx == "marquis" or spawnx == "tropic" then
						MtxSetElementData ( player, "spawnpos_x", -2458.288085 )
						MtxSetElementData ( player, "spawnpos_y", 774.354492 )
						MtxSetElementData ( player, "spawnpos_z", 35.171875 )
						MtxSetElementData ( player, "spawnrot_x", 52 )
						MtxSetElementData ( player, "spawnint", 0 )
						MtxSetElementData ( player, "spawndim", 0 )
					end
					dbExec ( handler, "DELETE FROM ?? WHERE ??=? AND ??=?", "vehicles", "UID", playerUID[pname], "Slot", slot )
					MtxSetElementData(player,"curcars",tonumber(MtxGetElementData ( player, "curcars" ))-1)
					MtxSetElementData ( player, "FahrzeugeVerkauft", MtxGetElementData ( player, "FahrzeugeVerkauft" ) + 1 )
					SaveCarData ( player )
					infobox ( player, "Fahrzeug verkauft\nfür "..price/100*75 ..""..Tables.waehrung.."", 4000, 0, 200, 0 )
					outputLog ( getPlayerName ( player ).." hat ein Auto an Server verkauft ( "..getVehicleName ( veh ).." )", "vehicle" )
					destroyElement ( veh )
					MtxSetElementData ( player, "money", MtxGetElementData ( player, "money" )+price/100*75 )
				else
					outputChatBox ( "Dieses Fahrzeug kannst du nicht verkaufen, da es zum Verkauf steht.", player, 125, 0, 0 )
				end
			else
				outputChatBox ( "Bitte respawne dein Fahrzeug vorher!", player, 125, 0, 0 )
			end		
		else
			infobox ( player, "\nUngültiger Slot!", 4000, 125, 0, 0 )
		end
	else
		infobox ( player, "Gebrauch:\n/sellcar [Slot]!", 4000, 200, 0, 0 )
	end
end
addCommandHandler ( "sellcar", sellcar_func )


function accept_sellcarto ( accepter, _, cmd )
	if cmd == "car" then
		local target = accepter
		local pSlot = MtxGetElementData ( accepter, "carToBuySlot" )
		player = MtxGetElementData ( accepter, "carToBuyFrom" )
		price = MtxGetElementData ( accepter, "carToBuyPrice" )
		model = MtxGetElementData ( accepter, "carToBuyModel" )
		if isElement ( player ) then
			local money = MtxGetElementData ( target, "bankmoney" )
			local tSlot = tonumber ( getFreeCarSlot ( target ) )
			if price <= money then
				if tonumber ( pSlot ) and tSlot then
					pSlot = tonumber ( pSlot )
					local pname = getPlayerName ( player )
					local result = dbPoll ( dbQuery ( handler, "SELECT ??, ?? FROM ?? WHERE ??=? AND ??=?", "AuktionsID", "ID", "vehicles", "UID", playerUID[pname], "Slot", pSlot ), -1 )
					if result and result[1] and tonumber ( result[1]["AuktionsID"] ) == 0 then
						if MtxGetElementData ( player, "carslot"..pSlot ) > 0 then
							local veh = allPrivateCars[pname][pSlot] or false
							if isElement ( veh ) then
								if model == getElementModel ( veh ) then
									if MtxGetElementData ( target, "curcars" ) < MtxGetElementData ( target, "maxcars" ) then
										
										local id = result[1]["ID"]
										
										outputChatBox ( "Du hast dein Fahrzeug in Slot Nr. "..pSlot.." an "..getPlayerName ( target ).." gegeben!", player, 0, 125, 0 )
										outputChatBox ( "Du hast ein Fahrzeug in Slot Nr. "..tSlot.." von "..getPlayerName ( player ).." erhalten!", target, 0, 125, 0 )
										
										dbExec ( handler, "UPDATE ?? SET ??=?, ??=?, ??=? WHERE ??=?", "vehicles", "UID", playerUID[getPlayerName(target)], "Slot", tSlot, "Lights", "|255|255|255|", "ID", id )

										MtxSetElementData ( target, "carslot"..tSlot, MtxGetElementData ( player, "carslot"..pSlot ) )
										MtxSetElementData ( player, "carslot"..pSlot, 0 )
										MtxSetElementData ( target, "curcars", MtxGetElementData ( target, "curcars" ) + 1 )
										MtxSetElementData ( player, "curcars", MtxGetElementData ( player, "curcars" ) - 1 )
										MtxSetElementData ( veh, "lcolor", "|255|255|255|" )
										
										setPrivVehCorrectLightColor ( veh )
										
										MtxSetElementData ( veh, "owner", getPlayerName ( target ) )
										MtxSetElementData ( veh, "name", "privVeh"..getPlayerName(target)..tSlot )
										MtxSetElementData ( veh, "carslotnr_owner", tSlot )
										
										allPrivateCars[getPlayerName(target)][tSlot] = veh
										allPrivateCars[pname][pSlot] = nil
										
										SaveCarData ( player )
										SaveCarData ( target )
										MtxSetElementData ( player, "FahrzeugeVerkauft", MtxGetElementData ( player, "FahrzeugeVerkauft" ) + 1 )
										MtxSetElementData ( target, "FahrzeugeGekauft", MtxGetElementData ( target, "FahrzeugeGekauft" ) + 1 )
											
										MtxSetElementData ( target, "bankmoney", money - price )
										MtxSetElementData ( player, "bankmoney", MtxGetElementData ( player, "bankmoney" ) + price )
											
										casinoMoneySave ( target )
										casinoMoneySave ( player )
										outputLog ( getPlayerName ( accepter ).." hat ein Auto von "..getPlayerName ( player ) .. " gekauft ( "..price.." - "..getVehicleName ( veh ).." )", "vehicle" )
									else
										infobox ( accepter, "Du hast keinen\nfreien Fahrzeugslot mehr!", 5000, 125, 0, 0 )
									end
								else
									infobox ( accepter, "Ein Fehler\nist aufgetreten.\nBitte lass dir\ndas Angebot erneut\nschicken!", 5000, 125, 0, 0 )
								end
							else
								infobox ( accepter, "Ein Fehler\nist aufgetreten.\nBitte lass dir\ndas Angebot erneut\nschicken!", 5000, 125, 0, 0 )
							end
						else
							infobox ( accepter, "Der Verkaufer hat\ndas Fahrzeug nicht\nmehr!", 5000, 125, 0, 0 )
						end
					end
				else
					infobox ( accepter, "Ein Fehler\nist aufgetreten.\nBitte lass dir\ndas Angebot erneut\nschicken!", 5000, 125, 0, 0 )
				end
			else
				infobox ( accepter, "Du hast nicht\ngenug Geld auf\nder Bank!", 5000, 125, 0, 0 )
			end
		else
			infobox ( accepter, "Der Anbieter des\nFahrzeugs ist offline!", 5000, 125, 0, 0 )
		end
	end
end
addCommandHandler ( "buy", accept_sellcarto )


function handbremsen ( player )
	local vehicle = getPedOccupiedVehicle ( player )
	if vehicle then
		local sitz = getPedOccupiedVehicleSeat ( player )
		if sitz == 0 then
			local vx, vy, vz = getElementVelocity ( getPedOccupiedVehicle ( player ) )
			local speed = math.sqrt ( vx ^ 2 + vy ^ 2 + vz ^ 2 )
			
			if speed < 5 * 0.00464 then
			else
				return
			end
	
			if MtxGetElementData ( vehicle, "owner" ) == getPlayerName ( player ) or MtxGetElementData(vehicle, "KeyTarget") == playerUID[getPlayerName(player)]  then
				if isElementFrozen ( vehicle ) then
					setElementFrozen ( vehicle, false )
					outputChatBox ( "Handbremse gelöst!", player, 0, 125, 0 )
				else
					setElementFrozen ( vehicle, true )
					outputChatBox ( "Handbremse angezogen!", player, 0, 125, 0 )
				end
			end
		end
	end
end

addCommandHandler ( "break", handbremsen )

-- VOLLSTÄNDIG KORRIGIERTE SERVER-SEITIGE ERGÄNZUNG für Schlüsselverwaltung

-- Event Handler für "Schlüssel GEBEN"
addEvent("onClientGiveKey", true)
addEventHandler("onClientGiveKey", root, function(targetName)
    local player = client
    local veh = getPedOccupiedVehicle(player)
    
    -- Basis-Sicherheitschecks
    if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then 
        triggerClientEvent(player, "infobox_start", getRootElement(), "Du musst als Fahrer in einem Fahrzeug sitzen!", 5000, 255, 0, 0)
        return 
    end
    
    local target = getPlayerFromName(targetName)
    local slotNr = MtxGetElementData(veh, "carslotnr_owner")
    local vehicleOwner = MtxGetElementData(veh, "owner")
    local playerName = getPlayerName(player)
    
    -- Fehlerprüfungen
    if not slotNr or not playerUID or not allPrivateCars then 
        triggerClientEvent(player, "infobox_start", getRootElement(), "Fehler: Kritische Daten nicht gefunden!", 5000, 255, 0, 0)
        return
    end
    
    -- Überprüfen ob Spieler der Besitzer ist
    if vehicleOwner == playerName then
        if target and target ~= player then 
            local targetPlayerName = getPlayerName(target)
            local targetUID = playerUID[targetPlayerName]
            local ownerUID = playerUID[playerName]
            
            if not targetUID or not ownerUID then
                triggerClientEvent(player, "infobox_start", getRootElement(), "Fehler: UID(s) nicht gefunden!", 5000, 255, 0, 0)
                return
            end
            
            -- Datenbank-Query (setzt KeyTarget auf die UID des Zielspielers)
            local success = dbExec(handler, "UPDATE vehicles SET KeyTarget=? WHERE UID=? AND Slot=?", targetUID, ownerUID, slotNr)
            
            if success then
                -- ElementData aktualisieren (setzt den Namen für die clientseitige Anzeige)
                MtxSetElementData(veh, "KeyTarget", targetPlayerName)
                
                -- Erfolgs-Feedback
                triggerClientEvent(player, "infobox_start", getRootElement(), "Schlüssel an " .. targetPlayerName .. " gegeben.", 5000, 0, 255, 0)
                triggerClientEvent(target, "infobox_start", getRootElement(), "Du hast einen Fahrzeugschlüssel von " .. playerName .. " erhalten!", 5000, 0, 255, 0)
                
                -- Aktualisiert das Label des Menüs, falls es noch offen ist (Client-Funktion)
                triggerClientEvent(player, "updateKeyTargetLabel", player, targetPlayerName)
                outputDebugString("Schlüssel erfolgreich gegeben: " .. playerName .. " -> " .. targetPlayerName .. " (Slot: " .. slotNr .. ")")
            else
                triggerClientEvent(player, "infobox_start", getRootElement(), "Datenbankfehler beim Schlüssel geben!", 5000, 255, 0, 0)
            end
        else
            local msg = (not target) and "Spieler '" .. targetName .. "' nicht gefunden oder offline." or "Du kannst dir nicht selbst einen Schlüssel geben!"
            triggerClientEvent(player, "infobox_start", getRootElement(), msg, 5000, 255, 0, 0)
        end
    else
        triggerClientEvent(player, "infobox_start", getRootElement(), "Das Fahrzeug gehört dir nicht!", 5000, 255, 0, 0)
    end
end)

-- --------------------------------------------------------------------
-- Server-Event-Handler für 'Schlüssel ENTFERNEN'
-- --------------------------------------------------------------------
addEvent("onClientClearKey", true)
addEventHandler("onClientClearKey", root, function()
    local player = client
    local veh = getPedOccupiedVehicle(player)
    
    -- Basis-Sicherheitschecks
    if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then
        triggerClientEvent(player, "infobox_start", getRootElement(), "Du musst als Fahrer in einem Fahrzeug sitzen!", 5000, 255, 0, 0)
        return
    end
    
    -- Fahrzeug-Daten abrufen
    local vehicleOwner = MtxGetElementData(veh, "owner")
    local slotNr = MtxGetElementData(veh, "carslotnr_owner")
    local playerName = getPlayerName(player)
    
    -- Fehlerprüfungen
    if not slotNr or not playerUID or not allPrivateCars then 
        triggerClientEvent(player, "infobox_start", getRootElement(), "Fehler: Kritische Daten nicht gefunden!", 5000, 255, 0, 0)
        return
    end
    
    -- Überprüfen ob Spieler der Besitzer ist
    if vehicleOwner == playerName then
        local ownerUID = playerUID[playerName]
        
        if not ownerUID then
            triggerClientEvent(player, "infobox_start", getRootElement(), "Fehler: Deine UID nicht gefunden!", 5000, 255, 0, 0)
            return
        end
        
        -- Datenbank-Query (setzt KeyTarget auf NULL)
        local success = dbExec(handler, "UPDATE vehicles SET KeyTarget=NULL WHERE UID=? AND Slot=?", ownerUID, slotNr)
        
        if success then
            -- ElementData aktualisieren (setzt auf nil, damit Client 'Niemand' anzeigt)
            MtxSetElementData(veh, "KeyTarget", nil)
            
            -- Erfolgs-Feedback
            triggerClientEvent(player, "infobox_start", getRootElement(), "Du hast erfolgreich alle Schlüssel entfernt!", 5000, 0, 255, 0)
            
            -- Aktualisiert das Label (Client-Funktion)
            triggerClientEvent(player, "updateKeyTargetLabel", player, "Niemand")
            outputDebugString("Schlüssel erfolgreich entfernt für Spieler: " .. playerName .. " (Slot: " .. slotNr .. ")")
        else
            triggerClientEvent(player, "infobox_start", getRootElement(), "Datenbankfehler beim Schlüssel entfernen!", 5000, 255, 0, 0)
        end
    else
        triggerClientEvent(player, "infobox_start", getRootElement(), "Das Fahrzeug gehört dir nicht!", 5000, 255, 0, 0)
    end
end)


function giveVehicleKey(player,cmd,kplayer)
	local target=getPlayerFromName(kplayer)
	local veh=getPedOccupiedVehicle(player)
	if(getPedOccupiedVehicleSeat(player)==0)then
		if(veh)then
			if(MtxGetElementData(veh,"owner") == getPlayerName(player)) then
				if(target and target~=player)then
					dbExec(handler,"UPDATE ?? SET ??=? WHERE ??=? AND ??=?","vehicles","KeyTarget",playerUID[getPlayerName(target)],"UID",playerUID[getPlayerName(player)],"Slot",MtxGetElementData(veh,"carslotnr_owner"))
					MtxSetElementData(veh,"KeyTarget",playerUID[getPlayerName(target)])
					triggerClientEvent ( target, "infobox_start", getRootElement(),"Fahrzeugschlüssel von Slot "..MtxGetElementData(veh,"carslotnr_owner").." an "..getPlayerName(target).." gegeben.", 5000, 125, 0, 0 )
				end
			else
				triggerClientEvent ( player, "infobox_start", getRootElement(), "Das Fahrzeug gehört dir nicht!", 5000, 125, 0, 0 )
			end
		end
	else
	    triggerClientEvent ( player, "infobox_start", getRootElement(), "Du sitzt in keinem Fahrzeug!", 5000, 125, 0, 0 )
	end
end
addCommandHandler("givekey",giveVehicleKey)

function deleteTargetKey(player)
	local veh = getPedOccupiedVehicle(player)
	if veh then
		if MtxGetElementData (veh, "owner") == getPlayerName (player) then
			outputChatBox("Du hast Erfolgreich alle Schlüssel entfernt!",player)
			dbExec ( handler, "UPDATE ?? SET ??=? WHERE ??=?", "vehicles", "KeyTarget", "none", "Slot", MtxGetElementData(veh,"carslotnr_owner") )
		end
	else
		outputChatBox("Du musst in einem Fahrzeug sitzen!", player, 255, 0, 0)
	end
end
addCommandHandler("clearvehKey", deleteTargetKey)