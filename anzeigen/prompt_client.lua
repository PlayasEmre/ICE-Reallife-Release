--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local promptTimeToHide = 0

function prompt_func ( text, time )

	gWindow["promptWindow"] = guiCreateWindow(screenwidth/2-363/2,screenheight/2-292/2,363,292,"Wichtige Informationen",false)
	guiSetAlpha(gWindow["promptWindow"],1)
	local img = guiCreateStaticImage(86,54,190,170,":"..getResourceName(getThisResource()).."/images/prompt.png",false,gWindow["promptWindow"])
	guiSetAlpha(img,0.5)
	
	gLabel["promptText"] = guiCreateLabel(11,26,343,223,text,false,gWindow["promptWindow"])
	guiSetAlpha(gLabel["promptText"],1)
	guiLabelSetColor(gLabel["promptText"],255,255,255)
	guiLabelSetVerticalAlign(gLabel["promptText"],"top")
	guiLabelSetHorizontalAlign(gLabel["promptText"],"left",false)
	guiSetFont(gLabel["promptText"],"default-bold-small")
	timeLabel = guiCreateLabel(19,261,330,21,"Dieses Fenster schliesst sich automatisch in "..time.." Sekunden.",false,gWindow["promptWindow"])
	guiSetAlpha(timeLabel,1)
	guiLabelSetColor(timeLabel,200,0,0)
	guiLabelSetVerticalAlign(timeLabel,"top")
	guiLabelSetHorizontalAlign(timeLabel,"left",false)
	guiSetFont(timeLabel,"default-bold-small")
	
	promptTimeToHide = time
	
	time = time + 1
	setTimer (
		function ( timeLabel )
			guiSetText ( timeLabel, "Dieses Fenster schliesst sich automatisch in "..promptTimeToHide.." Sekunden." )
			promptTimeToHide = promptTimeToHide - 1
		end,
	1000, time, timeLabel )
	setTimer ( destroyElement, time*1000+1000, 1, gWindow["promptWindow"] )
end
addEvent ( "prompt", true )
addEventHandler ( "prompt", getRootElement(), prompt_func )