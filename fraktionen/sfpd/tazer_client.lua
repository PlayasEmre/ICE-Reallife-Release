copskins={[265]=true,[267]=true,[281]=true,[283]=true,[284]=true}
fbiSkins={[285]=true,[286]=true,[165]=true,[164]=true,[163]=true}

function isOnStateDuty(player)
	local model = getElementModel(player) 
	if fbiSkins[model] or copskins[model] then return true else return false end
end

function isNotInUserHouse ( player )
	if getElementDimension ( player ) >= 5 then
		return false
	else
		return true
	end
end

local nowtazered = false
local isInCar = false

function stopDamage ( attacker, weapon, bodypart )
	if (weapon == 23) then
			cancelEvent()
		if  isPedInVehicle(localPlayer)  then
			if (getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Bike" ) then
				triggerServerEvent ( "ejectPlayer", localPlayer, localPlayer )
				isInCar= false
			else
				isInCar = true
			end
			else
				isInCar = false
			end
		if (isPedWearingJetpack(localPlayer) == true) then
			triggerServerEvent ( "removeJetPack", localPlayer, localPlayer ) 
		end
		if not (isTimer(tazeredTimer)) and (isInCar == false) then
			triggerServerEvent ( "ontaserAnim", localPlayer, localPlayer ) 
			tazeredTimer = setTimer(tazered, 20000, 1, source)
			nowtazered = true
			vioClientSetElementData("tazered", true)
			local tname = getPlayerName(attacker)
			outputChatBox ( tname.." hat dich ausser Gefecht gesetzt!", 200, 0, 0 )
		end
	end
	if isTimer(tazeredTimer) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", localPlayer, stopDamage )

local haveTaser = true
local preweapon = 0

function changeWeapon()
if isOnStateDuty(lp) then
	if getElementData(lp,"inTactic") == false then
		if isNotInUserHouse(lp) then
			if not isTimer(dontChangeTimer) then
				if (getElementData(localPlayer, "Wpn2Norm") == 22) then
					if (getElementData(localPlayer, "Wpn2Ammo") >= 1) then
						triggerServerEvent ( "changeToTaser", localPlayer, localPlayer) 
						dontChangeTimer = setTimer(dontChange, 5000, 1)
						haveTaser = false
						preWeapon = 22
						outputChatBox("Deine Pistole (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") wurde zu einem Taser (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") geändert.",0,150,200)
					end
				end
				if (getElementData(localPlayer, "Wpn2Norm") == 24) then
					if (getElementData(localPlayer, "Wpn2Ammo") >= 1) then
						triggerServerEvent ( "changeToTaser", localPlayer, localPlayer) 
						dontChangeTimer = setTimer(dontChange, 5000, 1)
						haveTaser = false
						preWeapon = 24
						outputChatBox("Deine Deagle (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") wurde zu einem Taser (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") geändert.", 0,150,200)
						
					end
				end	
				if (getElementData(localPlayer, "Wpn2Norm") == 23) then
					if (preWeapon == 22) then
						if (getElementData(localPlayer, "Wpn2Ammo") >= 1) then
							triggerServerEvent ( "changeToPistol", localPlayer, localPlayer) 
							dontChangeTimer = setTimer(dontChange, 5000, 1)
							haveTaser = false
							outputChatBox("Dein Taser (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") wurde zu einer Pistole (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") geändert." , 0,150,200)
						end
					end
					if (preWeapon == 24) then
						if (getElementData(localPlayer, "Wpn2Ammo") >= 1) then
							triggerServerEvent ( "changeToDeagle", localPlayer, localPlayer) 
							dontChangeTimer = setTimer(dontChange, 5000, 1)
							haveTaser = false
							outputChatBox("Dein Taser (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") wurde zu einer Deagle (Schuss: "..getElementData(localPlayer, "Wpn2Ammo")..") geändert.",0,150,200)
						end
					end
				end
				else
					outputChatBox("Du musst 5 Sekunden warten, bevor du die Waffe wieder wechseln kannst.", 255,0,0)
				end
			end
		end
	end
end
bindKey("F2", "down", changeWeapon)
	
function dontChange()
	-- leere Func um Timer zu initialisieren
end

function tazered(player)
	triggerServerEvent ( "onNotaserAnim", localPlayer, localPlayer )
	nowtazered = false
	vioClientSetElementData("tazered", false)
end


function clientPreRenderFunc()
    local block, animation = getPedAnimation(localPlayer)
	if (animation == "crckidle4") then
	else
		if (nowtazered) then
			triggerServerEvent ( "ontaserAnim", localPlayer, localPlayer ) 
		end
	end
	setElementData(localPlayer, "Wpn2Ammo", getPedTotalAmmo ( localPlayer, 2 ))
	setElementData(localPlayer, "Wpn2Norm", getPedWeapon(localPlayer, 2))
	if (preweapon == 0) then
		if (getElementData(localPlayer, "Wpn2Norm") == 23) then
			if getElementData(localPlayer, "fraktion") ~= 8 then
				triggerServerEvent("takeTazer", localPlayer, localPlayer )
				setElementData(localPlayer, "Wpn2Norm",getPedWeapon(localPlayer,0))
			end
		end
		if (getPedWeapon(localPlayer, 2) == 22) then
			preweapon = 22
		elseif (getPedWeapon(localPlayer, 2) == 24) then
			preweapon = 24
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), clientPreRenderFunc)

function resetTazerPreWpnOnWasted()
	triggerServerEvent("takeTazer", localPlayer, localPlayer)
	preweapon = 0
end
addEventHandler("onClientPlayerWasted", localPlayer, resetTazerPreWpnOnWasted)

function resetTazerPreWpnOnSpawn()
	preweapon = 0
end
addEventHandler("onClientPlayerSpawn", localPlayer, resetTazerPreWpnOnSpawn)

function onClientPlayerWeaponFireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if (weapon == 23) then
		local x,y,z = hitX, hitY, hitZ
		local sound = playSound3D ("sounds/taser.wav",hitX,hitY,hitZ, false)
		setSoundVolume (sound, 30)
		setSoundMaxDistance(sound, 16)
	end
end
addEvent ("onSound", true)
addEventHandler ("onSound", getRootElement(), onClientPlayerWeaponFireFunc)
addEventHandler("onClientPlayerWeaponFire", getRootElement(), onClientPlayerWeaponFireFunc)