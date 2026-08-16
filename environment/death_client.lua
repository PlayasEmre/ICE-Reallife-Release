--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local SHOW_DISTANCE = 12

local function dxDrawText3D ( text, x, y, z )
	local sx, sy = getScreenFromWorldPosition ( x, y, z, 0.2 )
	if sx and sy then
		dxDrawText ( text, sx, sy, sx, sy, tocolor ( 255, 255, 255, 220 ), 1, "default-bold", "center", "center", false, false, false, true )
	end
end

addEventHandler ( "onClientRender", root, function ()
	local px, py, pz = getElementPosition ( localPlayer )
	for _, pickup in ipairs ( getElementsByType ( "pickup" ) ) do
		if getElementData ( pickup, "deathWeaponDrop" ) then
			local x, y, z = getElementPosition ( pickup )
			if getDistanceBetweenPoints3D ( px, py, pz, x, y, z ) <= SHOW_DISTANCE then
				local weaponID = tonumber ( getElementData ( pickup, "weapon" ) )
				local ammo = tonumber ( getElementData ( pickup, "ammo" ) ) or 0
				local name = ( weaponNames and weaponNames[weaponID] ) or "Waffe"
				dxDrawText3D ( name.." ("..ammo..")", x, y, z + 0.8 )
			end
		end
	end
end )
