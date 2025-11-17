--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

mechanikerjobicon = createPickup ( -2032.45, 161.38, 28.74, 3, 1239, 1000, 0 )

mechanikerjobiconblip = createBlip ( -2032.45, 161.38, 28.74, 58, 2, 255, 0, 0, 255, 0, 200 )
setElementVisibleTo ( mechanikerjobiconblip, getRootElement(), false )

function jobicon_mechaniker ( player )
	
	triggerClientEvent ( player, "infobox_start", getRootElement(), "\nTippe /job, um\nMechaniker zu\nwerden.", 7500, 200, 200, 0 )
end
addEventHandler ( "onPickupHit", mechanikerjobicon, jobicon_mechaniker )

function repair_func ( player, cmd, target, price )

	if MtxGetElementData ( player, "job" ) == "mechaniker" then
		if tonumber ( price ) and getPlayerFromName ( target ) then
			local jobtime = tonumber ( MtxGetElementData ( player, "jobtime" ) )
			if jobtime == 0 then
				local price = math.abs ( math.floor ( tonumber ( price ) ) )
				local target = getPlayerFromName ( target )
				outputChatBox ( "Mechaniker "..getPlayerName ( player ).." hat dir angeboten, dein Auto fuer "..price.." "..Tables.waehrung.." zu reparieren. Tippe /acceptrepair zum annehmen.", target, 0, 100, 200 )
				outputChatBox ( "Du hast "..getPlayerName(target).." angeboten, sein Auto fuer "..price.." "..Tables.waehrung.." zu reparieren.", player, 0, 100, 200 )
				MtxSetElementData ( target, "mechaniker", getPlayerName ( player ) )
				MtxSetElementData ( target, "mechanikerpreis", price )
			else
				triggerClientEvent ( player, "infobox_start", getRootElement(), "\nDu musst noch\n"..jobtime.." Minuten warten,\nbis du wieder\nreparieren kannst!", 7500, 125, 0, 0 )
			end
		else
			triggerClientEvent ( player, "infobox_start", getRootElement(), "\nUngueltige Angaben!\nTippe /repair [Name]\n[Preis], um ein\nFahrzeug zu re-\nparieren.", 7500, 200, 200, 0 )
		end
	else
		triggerClientEvent ( player, "infobox_start", getRootElement(), "\n\nDu bist kein\nMechaniker!", 7500, 125, 0, 0 )
	end
end

addCommandHandler ( "repair", repair_func )

function acceptrepair_func ( player )
	
	local tname = MtxGetElementData ( player, "mechaniker" )
	local target = getPlayerFromName ( tname )
	if isElement ( target ) and isElement ( player ) then
		local price = MtxGetElementData ( player, "mechanikerpreis" )
		local x1, y1, z1 = getElementPosition ( target )
		local x2, y2, z2 = getElementPosition ( player )
		local money = MtxGetElementData ( player, "money" )
		local jobtime = tonumber ( MtxGetElementData ( target, "jobtime" ) )
		if getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 ) < 5 then
			if getPedOccupiedVehicle ( player ) then
				local vx, vy, vz = getElementVelocity ( getPedOccupiedVehicle ( player ) )
				local speed = math.sqrt ( vx ^ 2 + vy ^ 2 + vz ^ 2 )
				if speed < 5 * 0.00464 then
					if money >= price then
						if jobtime == 0 then
							MtxSetElementData ( player, "money", money - price )
							triggerClientEvent ( player, "HudEinblendenMoney", getRootElement() )
							playSoundFrontEnd ( player, 46 )
							MtxSetElementData ( target, "money", MtxGetElementData ( target, "money" ) + price )
							triggerClientEvent ( target, "HudEinblendenMoney", getRootElement() )
							playSoundFrontEnd ( target, 40 )
							local veh = getPedOccupiedVehicle ( player )
							local carhealth = getElementHealth ( veh )
							fixVehicle ( veh )
							setElementHealth ( veh, carhealth + 200 )
							if MtxGetElementData ( veh, "stuning2" ) then
								if MtxGetElementData ( veh, "stuning2" ) >= 1 then
									vehMaxHealth = 1700
								else
									vehMaxHealth = 1000
								end
							else
								vehMaxHealth = 1000
							end
							if getElementHealth ( veh ) > vehMaxHealth then
								setElementHealth ( veh, vehMaxHealth )
							end
							MtxSetElementData ( target, "jobtime", jobtime + 3 )
							MtxSetElementData ( player, "mechaniker", "" )
							MtxSetElementData ( player, "mechanikerpreis", "" )
						else
							triggerClientEvent ( player, "infobox_start", getRootElement(), "\nDer Mechaniker kann\nnoch nicht wieder\nreparieren!", 7500, 125, 0, 0 )
						end
					else
						triggerClientEvent ( player, "infobox_start", getRootElement(), "\n\nDu hast zu\nwenig Geld!", 7500, 125, 0, 0 )
					end
				else
					infobox ( player, "Das Fahrzeug darf\nnicht fahren!", 5000, 125, 0, 0 )
				end
			else
				triggerClientEvent ( player, "infobox_start", getRootElement(), "\n\nDu bist in\nkeinem Fahrzeug!", 7500, 125, 0, 0 )
			end
		else
			triggerClientEvent ( player, "infobox_start", getRootElement(), "\n\nDu bist zu\nweit weg!", 7500, 125, 0, 0 )
		end
	end
end
addCommandHandler ( "acceptrepair", acceptrepair_func )

function tunen_func ( player, cmd, target, price )

	if MtxGetElementData ( player, "job" ) == "mechaniker" then
		if tonumber ( price ) and getPlayerFromName ( target ) then
			local price = math.abs ( math.floor ( tonumber ( price ) ) )
			local target = getPlayerFromName ( target )
			outputChatBox ( "Mechaniker "..getPlayerName ( player ).." hat dir angeboten, dein Auto fuer "..price.." "..Tables.waehrung.." zu tunen. Tippe /accepttune zum annehmen.", target, 0, 100, 200 )
			outputChatBox ( "Du hast "..getPlayerName(target).." angeboten, sein Auto fuer "..price.." "..Tables.waehrung.." zu tunen.", player, 0, 100, 200 )
			MtxSetElementData ( target, "mechanikert", getPlayerName ( player ) )
			MtxSetElementData ( target, "mechanikertpreis", price )
		else
			triggerClientEvent ( player, "infobox_start", getRootElement(), "\nUngueltige Angaben!\nTippe /tunen [Name]\n[Preis], um ein\nFahrzeug zu tun-\nen", 7500, 200, 200, 0 )
		end
	else
		triggerClientEvent ( player, "infobox_start", getRootElement(), "\n\nDu bist kein\nMechaniker!", 7500, 125, 0, 0 )
	end
end
addCommandHandler ( "tunen", tunen_func )

function accepttune_func ( player )
	
	local tname = MtxGetElementData ( player, "mechanikert" )
	local target = getPlayerFromName ( tname )
	local price = tonumber ( MtxGetElementData ( player, "mechanikertpreis" ) )
	local x1, y1, z1 = getElementPosition ( target )
	local x2, y2, z2 = getElementPosition ( player )
	local money = MtxGetElementData ( player, "money" )
	local jobtime = tonumber ( MtxGetElementData ( target, "jobtime" ) )
	local veh = getPedOccupiedVehicle ( player )
	if getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 ) < 5 then
		if getPedOccupiedVehicle ( player ) then
			if money >= price then
				if jobtime == 0 then
					MtxSetElementData ( player, "money", money - price )
					triggerClientEvent ( player, "HudEinblendenMoney", getRootElement() )
					playSoundFrontEnd ( player, 46 )
					MtxSetElementData ( target, "money", MtxGetElementData ( target, "money" ) + price )
					triggerClientEvent ( target, "HudEinblendenMoney", getRootElement() )
					playSoundFrontEnd ( target, 40 )
					MtxSetElementData ( player, "jobtime", jobtime + 5 )
					addVehicleUpgrade ( veh, 1010 )
					MtxSetElementData ( player, "mechanikert", "" )
					MtxSetElementData ( player, "mechanikertpreis", "" )
				else
					triggerClientEvent ( player, "infobox_start", getRootElement(), "\nDer Mechaniker kann\nnoch nicht wieder\nreparieren!", 7500, 125, 0, 0 )
				end
			else
				triggerClientEvent ( player, "infobox_start", getRootElement(), "\n\nDu hast zu\nwenig Geld!", 7500, 125, 0, 0 )
			end
		else
			triggerClientEvent ( player, "infobox_start", getRootElement(), "\nDu bist in\nkeinem Auto!", 7500, 125, 0, 0 )
		end
	else
		triggerClientEvent ( player, "infobox_start", getRootElement(), "\n\nDu bist zu\nweit weg!", 7500, 125, 0, 0 )
	end
end
addCommandHandler ( "accepttune", accepttune_func )