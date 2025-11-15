--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local TabelleFahrzeuge = {[549]=true, [412]=true,[581]=true,[404]=true}
local Carrobstart = false
local CoolDown = false
local timer = false
local CarrobPickup = createPickup(-1966.3322753906,289.857421875,35.46875,3,1239,500)

function Hit_Func(player)
	if Carrobstart == false then
		outputChatBox("Tippe /car, um das Wang Cars auszurauben!",player,0,125,0)
	else
		outputChatBox("Gerade läuft noch eine Aktion, bitte warte kurz...",player,125,0,0)
	end
end
addEventHandler("onPickupHit",CarrobPickup,Hit_Func)


function Rob_Func(player)

	if not Aktiondeaktivieren then
		infobox ( player, "Gerade ist es nicht möglich einen Car Rob zu starten", 5000, 150, 0, 0 )
		return
	end
	
	if isCop(player) or isFBI(player) or isArmy(player) then
	   return outputChatBox("Du bist nicht befugt, dieses Autohaus auszurauben!",player,125,0,0)
	end
		
	if isStateFaction(player) or isMechaniker(player) or isMedic(player) then
		return outputChatBox("Du bist in keiner bösen Fraktion",player,255,255,0)
	end

	local veh = math.random ( 1, 4 )
	if veh == 1 then
		vehid = 549
	elseif veh == 2 then
		vehid = 412
	elseif veh == 3 then
		vehid = 581
	elseif veh == 4 then
		vehid = 404
	end

	if CoolDown == false  then

	if getDistanceBetweenPoints3D (-1966.3322753906,289.857421875,35.46875, getElementPosition ( player ) ) < 5 then
		
		if Carrobstart == false then
		   Carrobstart = true

		outputChatBox("Aufgabe: Bringe das Auto zur Flagge auf der Karte!",player,255,255,0)
		outputChatBox("Als Belohnung erhaelst du 5000 "..Tables.waehrung.."!",player,255,255,0)

		outputChatBox("[Carrob]: Das Wang Cars wird ausgeraubt!",getRootElement(),125,0,0)
		
		outputLog( "[Carrob]: Das Wang Cars wird von "..getPlayerName(player).." ausgeraubt!", "Robs")
				   
	   if Carrobstart == true then
			timer = setTimer(Carrob_Timer,8*60*1000,1)
			outputChatBox("Du hast 8 Minuten Zeit das Fahrzeug abzugeben Sonst wird das Fahrzeug zerstört!",player,255,0,0)
	   end
		   
		Carrob = createVehicle ( vehid, -1986.6817626953,304.60440063477,34.693672180176,0,0,270)
		CarrobBlip = createBlip ( -371.93057250977,2224.9992675781,42.004264831543, 19, 2, 255, 0, 0, 255, 0, 9999, getRootElement() )

		warpPedIntoVehicle(player,Carrob)
		
		marker = createMarker(0,0,0,"arrow",0.3,200,0,0,160)
		attachElements( marker, Carrob, 0, 0,1.3)
		
		addEventHandler ("onVehicleExplode", Carrob, Carrob_Explode )

		CarrobAbgabemarker = createMarker(-371.93057250977,2224.9992675781,42.004264831543,"checkpoint",3,200,0,0)
		addEventHandler("onMarkerHit",CarrobAbgabemarker, Carrob_Abgabe)
		Carrobstart = true
			
		else
			outputChatBox("Du musst noch warten!",player,125,0,0)
		end
			
		else
		   outputChatBox("Du bist nicht an der richtigen Stelle!",player,125,0,0)
		end
	else
		outputChatBox("Bitte warten Sie mindestens 20 Minute",player,255,0,0)
		setTimer(function() CoolDown=false end, 20*60*1000, 1)
	end
end
addCommandHandler("car",Rob_Func)

function Carrob_Abgabe( player )
	if player and isElement ( player ) and getElementType ( player ) == "player" then
	local veh = getPedOccupiedVehicle ( player )
	  if getPedOccupiedVehicleSeat ( player ) == 0 then
		if TabelleFahrzeuge[getElementModel(veh)] then
			
				if MtxGetElementData(veh, "owner") == false then
					elseif TabelleFahrzeuge[getElementModel(veh)] then
					return false
				end
				
				if isElement(marker) then
					destroyElement(marker)
				end
				
				if isElement(Carrob) then
					destroyElement(Carrob)
				end
				
				if isElement(CarrobBlip) then
					destroyElement(CarrobBlip)
				end	
					
				if isElement(CarrobAbgabemarker) then
					destroyElement(CarrobAbgabemarker)
				end	
			
				outputChatBox("Du hast das Auto erfolgreich abgeben! Du erhaelst 5000 "..Tables.waehrung.."!",player,0,125,0)
				outputChatBox("[Carrob]: Das gestohlene Auto wurde abgegeben!",getRootElement(),125,0,0)
				
				outputLog( "[Carrob]: Das Auto wurde von "..getPlayerName(player).." abgegeben!", "Robs")
				
				MtxSetElementData(player, "money", MtxGetElementData(player, "money") + 5000 )
				Carrobstart = false
				CoolDown = true
			
				if isTimer(timer) then
					killTimer(timer)
				end
				
			end
		end
	end
end

function Carrob_Explode()
		outputChatBox("Das gestohlene Auto wurde zerstört aufgefunden!",getRootElement(),125,0,0)
		outputLog( "[Carrob]: Das Auto wurde zerstört aufgefunden!", "Robs")
	if isTimer(timer) then
		destroyElement(marker)
		destroyElement(Carrob)
		destroyElement(CarrobBlip)
		destroyElement(CarrobAbgabemarker)
		killTimer(timer)
		Carrobstart = false
		CoolDown = false
	end
end


function Carrob_Timer () 
	Carrobstart = false
	CoolDown = false
	timer = false
	destroyElement(marker)
	destroyElement(Carrob)
	destroyElement(CarrobBlip)
	destroyElement(CarrobAbgabemarker)
	outputChatBox("Das gestohlene Fahrzeug ist wegen der Zeit zerstört worden!")
end

function destroytimer(player)
	if getElementData(player,"adminlvl") >= 4 then
		Carrobstart = false
		CoolDown = false
		if isTimer(timer) then
			destroyElement(marker)
			destroyElement(Carrob)
			destroyElement(CarrobBlip)
			destroyElement(CarrobAbgabemarker)
			killTimer(timer)
			outputChatBox("[Carrob]: Der Carrob Timer wurde von "..getPlayerName(player).." zurückgesetzt!",getRootElement(),200,0,0)
			outputLog( "[Carrob]: Der Timer wurde von "..getPlayerName(player).." zurückgesetzt!", "Adminsystem")
		end
	end
end
addCommandHandler("resetcarrob",destroytimer)