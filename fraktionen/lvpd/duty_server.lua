--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

function SAPD_Duty_Func4(player,cmd)
	if getElementData(player,"fraktion")== 1 then
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
addEvent("go:sapd_duty4",true)
addEventHandler("go:sapd_duty4",getRootElement(),SAPD_Duty_Func4)


--//SAPD Duty Icons
SAPDdutyIcon=createPickup(297.49069213867,186.00378417969,1007.171875,3,1275,50,0)--LV
SAPDdutyIconINT=createPickup(297.49069213867,186.00378417969,1007.171875,3,1275,50,0)--LV
setElementInterior(SAPDdutyIconINT,3)


--//SAPD Functions
function SAPD_DutyIcon_Func4(player)
	if getElementData(player,"fraktion")== 1 then
		triggerClientEvent(player,"open:sapd_duty_gui4",getRootElement())
	else outputChatBox("Du bist kein Staatsfraktionist!",player)end
end
addEventHandler("onPickupHit",SAPDdutyIcon,SAPD_DutyIcon_Func4)
addEventHandler("onPickupHit",SAPDdutyIconINT,SAPD_DutyIcon_Func4)

function SAPD_OffDuty_Func4(player,cmd)
	if isAbleOffduty(player)then
		if not getPedOccupiedVehicle(player)then
			setElementModel(player,MtxGetElementData(player,"skinid"))
			takeAllWeapons(player)
			outputChatBox("Du hast den Dienst als Polizist beendet!",player)
		else outputChatBox("Du darfst in keinem Fahrzeug sitzen!",player)end
	else outputChatBox("Du bist kein Beamter im Dienst!",player)end
end
addEvent("gooff:sapd_duty4",true)
addEventHandler("gooff:sapd_duty4",getRootElement(),SAPD_OffDuty_Func4)