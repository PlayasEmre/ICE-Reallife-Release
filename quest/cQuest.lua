--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

addEventHandler("onClientRender",root,function()
if getElementData ( localPlayer, "loggedin" ) == 1 then
	if getElementData(localPlayer,"ElementClicked") == false then
		if(not isPedDead(localPlayer))then
			if isPlayerMapVisible(localPlayer) == false then
			if not cdn:getReady() then return end
				if  vioClientGetElementData("Introtask") and tonumber(vioClientGetElementData("Introtask")) <= #globalTables["Tasks"] then
					dxDrawRectangle(1625*Gsx,455*Gsy,280*Gsx,120*Gsy,tocolor(0,0,0,140),false)
					dxDrawRectangle(1645*Gsx,490*Gsy,240*Gsx,2*Gsy,tocolor(255,255,255,255),false)
					dxDrawText("Quest-Aufgabe:",3325*Gsx,460*Gsy,200*Gsx,922*Gsy,tocolor(255,255,255,255),1.00*Gsx,dxFONT,"center",nil,nil,nil,false,nil)		
					dxDrawText(globalTables["Tasks"][vioClientGetElementData("Introtask")],3325*Gsx,505*Gsy,200*Gsx,922*Gsy,tocolor(255,255,255,255),1.00*Gsx,dxFONT2,"center",nil,nil,nil,false,nil)
					dxDrawText(tonumber(vioClientGetElementData("Introtask")).."/"..#globalTables["Tasks"].."",3560*Gsx,550*Gsy,200*Gsx,922*Gsy,tocolor(255,255,255,255),0.95*Gsx,dxFONT2,"center",nil,nil,nil,false,nil)
				end
			  end
		   end
		end
	end
end)