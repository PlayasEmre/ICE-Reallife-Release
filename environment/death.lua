--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

addEvent ( "onPlayerWastedTriggered", true )

thedeathtimer = {}

local gunsPickup = {}
local weaponPickupIDS = {
	[24]=348,
	[29]=353,
	[31]=356,
	[33]=357,
	[25]=349,
	[28]=352,
	[30]=355,
}

function gunsPickups(weapon,ammo)
	local x,y,z = getElementPosition(source)
	local weapon = getPedWeapon(source)
	local ammo = getPedTotalAmmo(source)
	
	if (weaponPickupIDS[weapon]) then
		if isElement(gunsPickup[source]) then destroyElement(gunsPickup[source]) end
		gunsPickup[source] = createPickup(x,y,z,3,weaponPickupIDS[weapon],50)
		setElementData(gunsPickup[source],"weapon",weapon)
		setElementData(gunsPickup[source],"ammo",ammo)
			
		addEventHandler("onPickupHit",gunsPickup[source],function(player)
		if not isPedDead(player) then 
			if MtxGetElementData(player,"gunlicense") == 1 then
				local weapon = getElementData(source,"weapon")
				local ammo = getElementData(source,"ammo")
				giveWeapon(player,weapon,ammo,true)
				destroyElement(source)
					infobox(player,"Du hast eine Waffe aufgehoben")
				else
					outputChatBox("Du brauchst ein Waffenschein um diese Waffe Aufzuheben!",player,255,255,255)
				end
			end
		end)
	end
end
addEventHandler ("onPlayerWasted",root,gunsPickups)


function playerdeath (killer,weapon,part)
	local player = client
	if part == 9 then
		setPedHeadless ( client, true )
	end
	MtxSetElementData ( player, "alcoholFlushPoints", 0 )
	MtxSetElementData ( player, "drugFlushPoints", 0 )
	MtxSetElementData ( player, "cigarettFlushPoints", 0 )
	if isKeyBound ( player, "enter_exit", "down", heliCoSeat ) then
		heliCoSeat ( player )
	end
	if MtxGetElementData ( player, "callswith" ) then
		if MtxGetElementData ( player, "callswith" ) ~= "none" then
			local caller = isElement ( MtxGetElementData ( player, "callswith" ) ) and MtxGetElementData ( player, "callswith" ) or getPlayerFromName ( MtxGetElementData ( player, "callswith" ) )
			if caller then
				MtxSetElementData ( caller, "callswith", "none" )
				MtxSetElementData ( caller, "call", false )
				MtxSetElementData ( caller, "calls", "none" )
				MtxSetElementData ( caller, "callswith", "none" )
				MtxSetElementData ( caller, "calledby", "none" )
				outputChatBox ( "*Knack* - Die Leitung ist tod!", caller, 125, 0, 0 )
			else
				MtxSetElementData ( player, "callswith", "none" )
				MtxSetElementData ( player, "call", false )
				MtxSetElementData ( player, "calls", "none" )
				MtxSetElementData ( player, "callswith", "none" )
				MtxSetElementData ( player, "calledby", "none" )
			end
		end
	end
	if MtxGetElementData ( player, "isInDrivingSchool" ) then
		cancelDrivingSchoolPlayer ( player )
	end
	if isPedInVehicle( player ) then
		removePedFromVehicle ( player )
	end
	
	if isElement ( killer ) and killer ~= player and weapon and not isOnStateDuty(killer) and getElementData( killer,"inTactic" ) == false then
		outputServerLog ( getPlayerName ( killer ).." hat "..getPlayerName(player).." mit Waffe "..weapon.." erledigt!" )
		if MtxGetElementData ( player, "fraktion" ) == 0 then
			local x1, y1, z1 = getElementPosition ( player )
			local x2, y2, z2 = getElementPosition ( killer )
			local dist = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
			if dist < 7.5 then
			    outputChatBox ( "Du hast ein Verbrechen begangen: Mord, gemeldet von: Anonym", killer, 0, 0, 150 )
				if MtxGetElementData ( killer, "wanteds" ) <= 5 then
					MtxSetElementData ( killer, "wanteds", MtxGetElementData ( killer, "wanteds" ) + 1 )
					setPlayerWantedLevel ( killer, MtxGetElementData ( killer, "wanteds" ) )
				end	
			elseif dist < 15 then
				if math.random ( 1, 2 ) == 1 then
				    outputChatBox ( "Du hast ein Verbrechen begangen: Mord, gemeldet von: Anonym", killer, 0, 0, 150 )
					if MtxGetElementData ( killer, "wanteds" ) <= 5 then
						MtxSetElementData ( killer, "wanteds", MtxGetElementData ( killer, "wanteds" ) + 1 )
						setPlayerWantedLevel ( killer, MtxGetElementData ( killer, "wanteds" ) )
					end
				else
					MtxSetElementData ( killer, "lastcrime", "mord" )
				end
			else
				MtxSetElementData ( killer, "lastcrime", "mord" )
			end
		end
	end
	MtxSetElementData ( player, "isinairportmission", false )
	MtxSetElementData ( player, "isInRace", false )
	unbindKey ( player, "mouse_wheel_up", "down", weaponsup )
	unbindKey ( player, "mouse_wheel_down", "down", weaponsdown )
	unbindKey ( player , "g", "down", rein )
	unbindKey ( player, "enter", "down", eject )
	unbindKey ( player, "rshift", "down", helidriveby )
	unbindKey ( player, "1", "down", tazer_func )
	local timeToBeDeath = 120000
	if MtxGetElementData ( player, "playingtime" ) >= 100 then
		timeToBeDeath = timeToBeDeath + 2
	elseif MtxGetElementData ( player, "playingtime" ) >= 50 then
		timeToBeDeath = timeToBeDeath + 1
	end
	if isElement ( killer ) then
		if isHit ( killer ) then
			local contract = MtxGetElementData ( player, "contract" )
			if contract > 0 then
				timeToBeDeath = timeToBeDeath + 2
				MtxSetElementData ( player, "contract", 0 )
				MtxSetElementData ( killer, "money", tonumber ( MtxGetElementData ( killer, "money" ) ) + contract )
				playSoundFrontEnd ( killer, 40 )
				outputChatBox ( "Du solltest dir Gedanken machen - auf dich waren "..contract.." "..Tables.waehrung.." Kopfgeld ausgesetzt!", player, 125, 0, 0 )
				outputChatBox ( "Ziel erledigt. Belohnung: "..contract.." "..Tables.waehrung..".", killer, 125, 0, 0 )
			end
		end
	end
	if getElementData(player,"inTactic") == true then
		respawnTacticMode(player)
		return
	end
	MtxSetElementData ( player, "heaventime", timeToBeDeath )
	setTimer ( endfade, 5000, 1, player, timeToBeDeath )
	if MtxGetElementData ( source, "isInArea51Mission" ) then
		setPlayerOutOfArea51 ( source )
		outputChatBox ( "Mission gescheitert!", source, 125, 0, 0 )
	end
	if killer and killer ~= player and getElementType ( killer ) == "player" then 
		local kills = tonumber ( MtxGetElementData ( killer, "kills" ) )
		blackListKillCheck ( player, killer, weapon )
		if isOnDuty ( killer ) or isArmy ( killer ) then
			if MtxGetElementData ( player, "wanteds" ) == 0 then
				outputChatBox ( "Du hast einen Zivilisten erledigt!", killer, 125, 0, 0 )
			else
				local strafe = MtxGetElementData ( player, "wanteds" ) * wantedprice
				local wanteds = MtxGetElementData ( player, "wanteds" )
				local time = MtxGetElementData ( player, "wanteds" ) * math.ceil(jailtimeperwanted * 1.2)
				MtxSetElementData ( player, "wanteds", 0 )
				setPlayerWantedLevel ( player, 0 )
				if tonumber(strafe) > MtxGetElementData ( player, "money" ) then		
					MtxSetElementData ( player, "money", 0 )
				else
					MtxSetElementData ( player, "money", tonumber(MtxGetElementData ( player, "money" )) - tonumber(strafe) )
				end
				MtxSetElementData ( player, "jailtime", time )
				MtxSetElementData ( player, "bail", 0 )
				local grammafix  = " ohne Kaution " 
				outputChatBox ( "Du wurdest von Polizist "..getPlayerName(killer).." erledigt und"..grammafix.."für "..strafe.." "..Tables.waehrung.." und "..time.." Minuten eingesperrt!", player, 0, 125, 0 )
				MtxSetElementData ( killer, "boni", MtxGetElementData ( killer, "boni" )+(wanteds*wantedkillmoney) )
				MtxSetElementData ( killer, "AnzahlEingeknastet", MtxGetElementData ( killer, "AnzahlEingeknastet" ) + 1 )
				MtxSetElementData ( player, "AnzahlImKnast", MtxGetElementData ( player, "AnzahlImKnast" ) + 1 )
				outputChatBox ( "Du hast "..getPlayerName ( player ).." erledigt und erhälst bei der nächsten Abrechnung "..(wanteds*wantedkillmoney)..""..Tables.waehrung.." Bonus!", killer, 0, 125, 0 )
			end
		end
	end
	if isKeyBound ( player, "mouse3", "up", explodeTerror, player ) then
		explodeTerror ( player )
	end
	local curdrogen = MtxGetElementData ( player, "drugs" )
	local amount = getDropAmount ( curdrogen )
	if amount > 0 then
		MtxSetElementData ( player, "drugs", curdrogen - amount )
		local x, y, z = getElementPosition ( player )
		local pickup = createPickup ( 0, 0, 0, 3, 1210, 1 )
		setElementPosition ( pickup, x, y, z )
		MtxSetElementData ( pickup, "amount", amount )
		setElementDimension ( pickup, getElementDimension ( player ) )
		setElementInterior ( pickup, getElementInterior ( player ) )	
		addEventHandler ( "onPickupHit", pickup, drugDropHit )
	end
	local curmats = MtxGetElementData ( player, "mats" )
	amount = getDropAmount ( curmats )
	if amount > 0 then
		MtxSetElementData ( player, "mats", curmats - amount )
		local x, y, z = getElementPosition ( player )
		local pickup = createPickup ( 0, 0, 0, 3, 1210, 1 )
		setElementPosition ( pickup, x + 0.5, y, z )
		MtxSetElementData ( pickup, "amount", amount )
		setElementDimension ( pickup, getElementDimension ( player ) )
		setElementInterior ( pickup, getElementInterior ( player ) )	
		addEventHandler ( "onPickupHit", pickup, matDropHit )
	end
	if getElementData(player,"inTactic") == false then
		local money = MtxGetElementData ( player, "money" )
		local loss = 5
		if money and money > 0 then
			local damoney = math.abs(math.floor(money/100*(100-loss)))
			MtxSetElementData ( player, "money", damoney )
			local x, y, z = getElementPosition ( player )
			local pickup = createPickup ( 0, 0, 0, 3, 1212, 1 )
			setElementPosition ( pickup, x, y + 0.5, z )
			MtxSetElementData ( pickup, "money", money - damoney )
			setElementDimension ( pickup, getElementDimension ( player ) )
			setElementInterior ( pickup, getElementInterior ( player ) )			
			addEventHandler ( "onPickupHit", pickup, moneyDropHit )
		end
	end	
	setElementDimension ( player, 0 )
	setElementInterior ( player, 0 )
	showChat ( player, true )
	setPlayerHudComponentVisible ( player, "radar", true )
	checkIfMedicRespawn ( player )
	if isElement ( killer ) then
		outputLog ( getPlayerName ( player ).." wurde von ".. getPlayerName ( killer ) .." getötet ( Waffe: "..weapon.." )", "kill" )
		MtxSetElementData ( killer, "Kills", MtxGetElementData ( killer, "Kills" ) + 1 )
	elseif weapon then
		outputLog ( getPlayerName ( player ).." ist gestorben. Grund: "..weapon, "death" )
	else
		outputLog ( getPlayerName ( player ).." ist gestorben.", "death" )
	end
	MtxSetElementData ( player, "Tode", MtxGetElementData ( player, "Tode" ) + 1 )
end
addEventHandler ( "onPlayerWastedTriggered", root, playerdeath )


function endfade ( player, timeToBeDeath )

	if isElement ( player ) then
		removePedFromVehicle ( player )
		triggerClientEvent ( player, "infobox_start", getRootElement(), "\nDu wurdest erledigt\nund wirst nun im\nKrankenhaus wieder\nzusammen geflickt!", 7500, 125, 0, 0 )
		
		local x1, y1, z1 = getElementPosition ( player )
		local x2, y2, z2 = 1605.4418945313, 1868.0090332031, 27.071100234985
		local x3, y3, z3 = -2537.9006347656, 618.84533691406, 33.35578918457
		local distToSF = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
		local distToLV = getDistanceBetweenPoints3D ( x1, y1, z1, x3, y3, z3 )
		if distToSF > distToLV then
			setCameraMatrix ( player, -2537.9006347656, 618.84533691406, 33.35578918457, -2616.6801757813, 619.22979736328, 39.688884735107 )
		else
			setCameraMatrix ( player, 1605.4418945313, 1868.0090332031, 27.071100234985, 1606.3515625, 1819.0625, 22.315660476685 )
		end
		
		setPlayerHudComponentVisible ( player, "radar", false )
		
		triggerClientEvent ( player, "showProgressBar", player )
		showChat ( player, true )
		
		refreshDeathTimeForPlayer ( player, 0, timeToBeDeath )
	end
end

function refreshDeathTimeForPlayer ( player, timeDone, holeTime )

	if isElement ( player ) then
		if timeDone / holeTime >= 1 then
			revive ( player )
			triggerClientEvent ( player, "updateDeathBar", player, 100 )
			return nil
		end
		triggerClientEvent ( player, "updateDeathBar", player, timeDone / holeTime * 100 )
		thedeathtimer[player] = setTimer ( refreshDeathTimeForPlayer, 2500, 1, player, timeDone + 2500, holeTime )
	end
end

function revive ( player )

	if isElement ( player ) then
		toggleAllControls ( player, true )
		triggerClientEvent ( player, "infobox_start", getRootElement(), "\nDu bist wieder\nfit! Pass beim\nnächsten mal\nbesser auf!", 7500, 0, 125, 0 )
		MtxSetElementData ( player, "heaventime", 0 )
		
		if MtxGetElementData ( player, "money" ) and MtxGetElementData ( player, "money" ) >= hospitalcosts then
			MtxSetElementData ( player, "money", MtxGetElementData ( player, "money" ) - hospitalcosts )
		else
			MtxSetElementData ( player, "money", 0 )
		end
		playSoundFrontEnd ( player, 17 )
		RemoteSpawnPlayer ( player )
		showChat ( player, true )
	end
end

function headFixOnSpawn ()
	setPedHeadless ( source, false )
end
addEventHandler ( "onPlayerSpawn", getRootElement(), headFixOnSpawn )