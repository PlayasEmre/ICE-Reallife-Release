--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

PremiumBlaster={}

addEvent("newPlaySound",true)
addEventHandler("newPlaySound",root,function(player,link)
	if isElement(PremiumBlaster[player])then
		destroyElement(PremiumBlaster[player])
	end
	PremiumBlaster[player] = createObject(2226,0,0,0)
	attachElementToBone(PremiumBlaster[player],player,12,0,0,0.4,0,180,0)
	setElementInterior(PremiumBlaster[player],getElementInterior(player))
	setElementDimension(PremiumBlaster[player],getElementDimension(player))
	for _,v in pairs(getElementsByType("player"))do
		triggerClientEvent(v,"createNewMusik",v,player,link)
	end
end)

addEvent("deleteBlaster",true)
addEventHandler("deleteBlaster",root,function(player)
	destroyElement(PremiumBlaster[player])
	for _,v in pairs(getElementsByType("player"))do
		triggerClientEvent(v,"deleteMusic",v,player)
	end
end)

addEventHandler("onPlayerQuit",root,function()
	PremiumBlaster.destroy(source)
end)

addEventHandler("onPlayerWasted",root,function()
	PremiumBlaster.destroy(source)
end)

function PremiumBlaster.destroy(player)
	if(PremiumBlaster[player])then
		destroyElement(PremiumBlaster[player])
		for _,v in pairs(getElementsByType("player"))do
			triggerClientEvent(v,"deleteMusic",v,player)
		end
	end
end