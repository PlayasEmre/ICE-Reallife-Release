--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local function Aduty_NoDMG_Func()
	if getElementData(localPlayer,"adminduty") then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage",localPlayer,Aduty_NoDMG_Func)
addEventHandler("onClientPlayerStealthKill", localPlayer, Aduty_NoDMG_Func)


addEventHandler("onClientRender", root, function()
	for _, pelement in ipairs(getElementsByType("player")) do
	if getElementData(pelement, "adminduty") then
	local x, y, z = getElementPosition(pelement)
	local x2, y2, z2 = getElementPosition(localPlayer)
	if isLineOfSightClear(x, y, z, x2, y2, z2, true, false, false, true) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+0.60)
		if(sx) and (sy) then
			local distance = getDistanceBetweenPoints3D(x, y, z+0.60, x2, y2, z2)
			if distance < 5 then
				local fontbig = 3 - (distance/30)
					if getElementDimension(pelement) == getElementDimension(localPlayer) and getElementInterior(pelement) == getElementInterior(localPlayer) then
						dxDrawText("Admin im Supporter-Mode", sx -2, sy -230, sx, sy, tocolor(0, 0, 0, 200), fontbig, "arial", "center")
						dxDrawText("Admin im Supporter-Mode", sx, sy -230, sx, sy, tocolor(255, 0, 0, 200), fontbig, "arial", "center")
					end
				end
			end
		 end
	   end
	end
end)