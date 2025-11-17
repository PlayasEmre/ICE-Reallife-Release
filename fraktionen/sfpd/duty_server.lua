--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

function SAPD_Duty_Func(player,cmd)
	if isCop (player)then
		if not isOnDuty(player)then
			if MtxGetElementData(player,"rang")==5 then
			    setElementModel ( player, 265 )
				giveWeapon ( player, 24, 300, true )
				giveWeapon ( player, 25, 300, true )
				giveWeapon ( player, 29, 500, true )
				giveWeapon ( player, 31, 600, true )
				giveWeapon ( player, 34, 40, true )
			elseif MtxGetElementData(player,"rang")==4 then
			    setElementModel ( player, 267 )
				giveWeapon ( player, 24, 300, true )
				giveWeapon ( player, 25, 300, true )
				giveWeapon ( player, 29, 500, true )
				giveWeapon ( player, 31, 600, true )
				giveWeapon ( player, 34, 40, true )
			elseif MtxGetElementData(player,"rang")==3 then
			    setElementModel ( player, 281 )
				giveWeapon ( player, 24, 300, true )
				giveWeapon ( player, 25, 300, true )
				giveWeapon ( player, 29, 500, true )
				giveWeapon ( player, 31, 600, true )
			elseif MtxGetElementData(player,"rang")==2 then
			    setElementModel ( player, 280 )
				giveWeapon ( player, 24, 300, true )
				giveWeapon ( player, 25, 300, true )
				giveWeapon ( player, 29, 500, true )
				giveWeapon ( player, 31, 600, true )
			elseif MtxGetElementData(player,"rang")==1 then
			    setElementModel ( player, 283 )
				giveWeapon ( player, 3, 1, true )
				giveWeapon ( player, 22, 200, true )
				giveWeapon ( player, 25, 100, true )
				giveWeapon ( player, 29, 500, true )
			elseif MtxGetElementData(player,"rang")==0 then
			    setElementModel ( player, 284 )
				giveWeapon ( player, 3, 1, true )
				giveWeapon ( player, 22, 200, true )
				giveWeapon ( player, 25, 100, true )
			end
			
			setPedArmor(player,100)
			setElementHunger(player,100)
			setElementHealth(player,100)
			outputChatBox("Du hast den Dienst als Polizist angetreten!",player)
		else outputChatBox("Du bist bereits im Dienst!",player)end
	end
end
addEvent("go:sapd_duty",true)
addEventHandler("go:sapd_duty",getRootElement(),SAPD_Duty_Func)

--//SAPD Duty Icons
SAPDdutyIcon=createPickup(-1611.5,679.3,-5.3,3,1275,50,0)--SF
SAPDdutyIconINT=createPickup(259.6,110.6,1003,3,1275,50,0)--SF
setElementInterior(SAPDdutyIconINT,10)

--//Einknast Icons
SAPDeinknastenIcon=createPickup(-1589.9,716.3,-5.2,3,2680,50,0)--SF

--//SAPD Functions
function SAPD_DutyIcon_Func(player)
	if(isCop(player))then
		triggerClientEvent(player,"open:sapd_duty_gui",getRootElement())
	else outputChatBox("Du bist kein Staatsfraktionist!",player)end
end
addEventHandler("onPickupHit",SAPDdutyIcon,SAPD_DutyIcon_Func)
addEventHandler("onPickupHit",SAPDdutyIconINT,SAPD_DutyIcon_Func)

function SAPD_OffDuty_Func(player,cmd)
	if isAbleOffduty(player)then
		if not getPedOccupiedVehicle(player)then
			setElementModel(player,MtxGetElementData(player,"skinid"))
			takeAllWeapons(player)
			outputChatBox("Du hast den Dienst als Polizist beendet!",player)
		else outputChatBox("Du darfst in keinem Fahrzeug sitzen!",player)end
	else outputChatBox("Du bist kein Beamter im Dienst!",player)end
end
addEvent("gooff:sapd_duty",true)
addEventHandler("gooff:sapd_duty",getRootElement(),SAPD_OffDuty_Func)


--SFPD Einknast
addEventHandler("onClientRender",root,function()
	local x,y,z=getElementPosition(lp)
	local px,py,pz=-1589.9,716.3,-5.2
	if(getDistanceBetweenPoints3D(x,y,z,px,py,pz)<=12)and(isLineOfSightClear(x,y,z,px,py,pz,true,true,true,true,true))then
		local sx,sy=guiGetScreenSize()
		x,y=getScreenFromWorldPosition(px,py,pz)
		if(x)and(y)then
			local dis=getDistanceBetweenPoints3D(x,y,z,px,py,pz)
			x=x-20
			dxDrawText("Einsperren",x,y,x,y,tocolor(0,0,0,200),1.5)
			dxDrawText("Einsperren",x+1,y+1,x,y,tocolor(255,255,255,200),1.5)
		end
	end
end)