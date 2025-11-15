--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

setTimer(function()
	if localPlayer and getElementData ( localPlayer, "loggedin" ) == 1 then
		triggerServerEvent("anitcheatServer", localPlayer,"Server")
	else
		return false
	end
end,5*1000,0)

function hasPlayerLicense ( id )
	if cars[id] then
		if tonumber ( vioClientGetElementData ("carlicense") ) == 1 then
			return true
		else
			return false
		end
	elseif lkws[id] then
		if tonumber ( vioClientGetElementData ("lkwlicense") ) == 1 then
			return true
		else
			return false
		end
	elseif bikes[id] then
		if tonumber ( vioClientGetElementData ("bikelicense") ) == 1 then
			return true
		else
			return false
		end
	elseif helicopters[id] then
		if tonumber ( vioClientGetElementData ("helilicense") ) == 1 then
			return true
		else
			return false
		end
	elseif planea[id] then
		if tonumber ( vioClientGetElementData ("planelicensea") ) == 1 then
			return true
		else
			return false
		end
	elseif planeb[id] then
		if tonumber ( vioClientGetElementData ("planelicenseb") ) == 1 then
			return true
		else
			return false
		end
	elseif motorboats[id] then
		if tonumber ( vioClientGetElementData ("motorbootlicense") ) == 1 then
			return true
		else
			return false
		end
	elseif raftboats[id] then
		if tonumber ( vioClientGetElementData ("segellicense") ) == 1 then
			return true
		else
			return false
		end
	elseif nolicense[id] then
		return true
	else
		return true
	end
end

local NotAllowedWeapons1 = {[38] = true,[37] = true,[18] = true,[39] = true}

local function NotAllowedWeapons()
    if NotAllowedWeapons1[tonumber(getPedWeapon(localPlayer))] and tonumber(getElementData(localPlayer,"adminlvl")) == 0 then
		triggerServerEvent("waffenkick",localPlayer,"Server")
	end
end
addEventHandler ("onClientPlayerWeaponFire",localPlayer,NotAllowedWeapons)