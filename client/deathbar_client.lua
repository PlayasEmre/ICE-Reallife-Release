--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local x,y = guiGetScreenSize()
local facts = {
	[1] = Tables.servername.." Reallife wird regelmäßig\nweiter entwickelt!",
	[2] = "Unsere Teamspeak IP: "..Tables.tsip,
	[3] = "Unser Forum: "..Tables.forumURL,
}

setTimer(function()
	factnumber = math.random(1,3)
	fact = facts[factnumber]
end,4000,0)

addEvent("showProgressBar",true)
addEventHandler("showProgressBar",localPlayer,function( hospitalValue )
	local hospitalValue = 120
	setTimer(function()
		hospitalValue = hospitalValue - 1
	end,1000,120)
	inrender = function()
		dxDrawRectangle(570*(x/1440), 319*(y/900), 301*(x/1440), 265*(y/900), tocolor(0, 0, 0, 200), false)
		dxDrawRectangle(570*(x/1440), 319*(y/900), 301*(x/1440), 22*(y/900), guimaincolor, false)
		dxDrawText("Krankenhaus", 570*(x/1440), 319*(y/900), 871*(x/1440), 341*(y/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Du bist noch "..hospitalValue.." Sekunden im Krankenhaus!", 580*(x/1440), 351*(y/900), 861*(x/1440), 485*(y/900), tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, true, false, false, false)
		dxDrawRectangle(580*(x/1440), 495*(y/900), 281*(x/1440), 79*(y/900), tocolor(0, 0, 0, 225), false)
		dxDrawText("Wusstest du schon?", 580*(x/1440), 495*(y/900), 861*(x/1440), 514*(y/900), tocolor(255, 255, 255, 225), 1.00, "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText(tostring(fact), 580*(x/1440), 524*(y/900), 861*(x/1440), 574*(y/900), tocolor(255, 255, 255, 225), 1.00, "default-bold", "center", "center", false, false, false, false, false)
	end
	addEventHandler("onClientRender",getRootElement(),inrender)
end)

function updateDeathBar_func ( new )
	local newBarSize = new
	if newBarSize >= 100 then
		hideUpdateBar ()
		showChat(true)
	end
end
addEvent ( "updateDeathBar", true )
addEventHandler ( "updateDeathBar", getRootElement(), updateDeathBar_func )

function hideUpdateBar ()
	removeEventHandler("onClientRender",getRootElement(),inrender)
end
addEvent ( "hideDeathBar", true )
addEventHandler ( "hideDeathBar", getRootElement(), hideUpdateBar )


addEventHandler ( "onClientPlayerWasted", localPlayer, function ( killer, weapon, ammo, bodypart )
	triggerServerEvent ( "onPlayerWastedTriggered", lp, killer, weapon, ammo, bodypart )
end )