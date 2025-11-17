--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

function SAPD_Duty_Func(player,cmd)
	if isFBI (player)then
		if not isOnDuty(player)then
			if MtxGetElementData(player,"rang")==5 then
				setElementModel(player,163)
				giveWeapon ( player, 24, 100, true )
				giveWeapon ( player, 25, 200, true )
				giveWeapon ( player, 29, 300, true )
				giveWeapon ( player, 31, 400, true )
				giveWeapon ( player, 34, 600, true )
			elseif MtxGetElementData(player,"rang")==4 then
				giveWeapon ( player, 24, 100, true )
				giveWeapon ( player, 25, 200, true )
				giveWeapon ( player, 29, 600, true )
				giveWeapon ( player, 31, 500, true )
				giveWeapon ( player, 34, 300, true )
				setElementModel(player,164)
			elseif MtxGetElementData(player,"rang")==3 then
				giveWeapon ( player, 24, 100, true )
				giveWeapon ( player, 25, 400, true )
				giveWeapon ( player, 29, 500, true )
				giveWeapon ( player, 31, 700, true )
				setElementModel(player,282)
			elseif MtxGetElementData(player,"rang")==2 then
				giveWeapon ( player, 24, 100, true )
				giveWeapon ( player, 25, 400, true )
				giveWeapon ( player, 29, 300, true )
				giveWeapon ( player, 31, 600, true )
				setElementModel(player,165)
			elseif MtxGetElementData(player,"rang")==1 then
				giveWeapon ( player, 24, 100, true )
				giveWeapon ( player, 25, 400, true )
				giveWeapon ( player, 29, 300, true )
				giveWeapon ( player, 31, 500, true )
				setElementModel(player,166)
			elseif MtxGetElementData(player,"rang")==0 then
				giveWeapon ( player, 24, 100, true )
				giveWeapon ( player, 25, 600, true )
				giveWeapon ( player, 29, 700, true )
				giveWeapon ( player, 31, 300, true )
				setElementModel(player,284)
			end
			setPedArmor(player,100)
			setElementHunger(player,100)
			setElementHealth(player,100)
			outputChatBox("Du hast den Dienst als Polizist angetreten!",player)
		else outputChatBox("Du bist bereits im Dienst!",player)end
	end
end
addEvent("go:sapd_duty2",true)
addEventHandler("go:sapd_duty2",getRootElement(),SAPD_Duty_Func)


--//SAPD Duty Icons
SAPDdutyIcon=createPickup(-2446.8195800781,518.64300537109,30.276069641113,3,1275,50,0)--SF
SAPDdutyIconINT=createPickup(986.46917724609,-11.640666007996,248.5625,3,1275,50,0)--SF
setElementInterior(SAPDdutyIconINT,10)


--//SAPD Functions
function SAPD_DutyIcon_Func(player)
	if(isFBI(player))then
		triggerClientEvent(player,"open:sapd_duty_gui2",getRootElement())
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
addEvent("gooff:sapd_duty2",true)
addEventHandler("gooff:sapd_duty2",getRootElement(),SAPD_OffDuty_Func)