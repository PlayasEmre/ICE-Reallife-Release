--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

function showBikerBarWindow_func ()

	if gWindow["bikerClubWindow"] then
		guiSetVisible ( gWindow["bikerClubWindow"], true )
	else
		local screenwidth, screenheight = guiGetScreenSize ()
		
		gWindow["bikerClubWindow"] = guiCreateWindow(screenwidth/2-345/2,screenheight/2-329/2,345,329,"Bikerclub",false)
		guiSetAlpha(gWindow["bikerClubWindow"],1)
		
		gButton["billiardQue"] = guiCreateButton(0.0377,0.0912,0.2145,0.1185,"Billiardque\nkaufen",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gButton["billiardQue"],1)
		gButton["Freeway"] = guiCreateButton(0.2754,0.0912,0.2145,0.1185,"Freeway\nkaufen",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gButton["Freeway"],1)
		gButton["Bikeroutfit"] = guiCreateButton(0.7449,0.1155,0.2145,0.1185,"Bikeroutfit\nkaufen",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gButton["Bikeroutfit"],1)
		gButton["bikerBeitreten"] = guiCreateButton(0.1884,0.7872,0.2696,0.1398,"Beitreten",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gButton["bikerBeitreten"],1)
		gButton["bikerClose"] = guiCreateButton(0.629,0.7872,0.2696,0.1398,"Schliessen",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gButton["bikerClose"],1)
		
		addEventHandler("onClientGUIClick", getRootElement(),
			function ()
				if source == gButton["billiardQue"] then
					triggerServerEvent ( "bikerBarBuyQue", getRootElement(), localPlayer )
				elseif source == gButton["Freeway"] then
					triggerServerEvent ( "bikerBarBuyBike", getRootElement(), localPlayer )
					guiSetVisible(gWindow["bikerClubWindow"],false)
					showCursor(false)
					triggerServerEvent ( "cancel_gui_server", localPlayer )
				elseif source == gButton["bikerBeitreten"] then
					triggerServerEvent ( "bikerBarJoin", getRootElement(), localPlayer )
				elseif source == gButton["Bikeroutfit"] then
					triggerServerEvent ( "bikerBarBuySkin", getRootElement(), localPlayer)
				elseif source == gButton["bikerClose"] then
					guiSetVisible(gWindow["bikerClubWindow"],false)
					showCursor(false)
					triggerServerEvent ( "cancel_gui_server", localPlayer )
				end
			end
		)
		
		
		gLabel["skinPrice"] = guiCreateLabel(0.8,0.2523,0.1275,0.0547,outfitPrice.." $",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gLabel["skinPrice"],1)
		guiLabelSetColor(gLabel["skinPrice"],000,125,000)
		guiLabelSetVerticalAlign(gLabel["skinPrice"],"top")
		guiLabelSetHorizontalAlign(gLabel["skinPrice"],"left",false)
		gLabel["freewayPrice"] = guiCreateLabel(0.3159,0.228,0.1536,0.0547,freewayPrice.." $",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gLabel["freewayPrice"],1)
		guiLabelSetColor(gLabel["freewayPrice"],0,125,0)
		guiLabelSetVerticalAlign(gLabel["freewayPrice"],"top")
		guiLabelSetHorizontalAlign(gLabel["freewayPrice"],"left",false)
		gLabel["billiardQuePrice"] = guiCreateLabel(0.113,0.2249,0.1536,0.0547,quePrice.." $",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gLabel["billiardQuePrice"],1)
		guiLabelSetColor(gLabel["billiardQuePrice"],0,125,0)
		guiLabelSetVerticalAlign(gLabel["billiardQuePrice"],"top")
		guiLabelSetHorizontalAlign(gLabel["billiardQuePrice"],"left",false)
		
		gLabel["mistysInfo"] = guiCreateLabel(0.0261,0.5623,0.9594,0.1945,"Hier kannst du dem Bikerclub beiterten, was es dir erlaubt,\ndie oben genannten Boni zu erwerben. \nAusserdem kannst du dann in dieser Bar spawnen,\nfalls du dich neu einloggst oder stirbst.",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gLabel["mistysInfo"],1)
		guiLabelSetColor(gLabel["mistysInfo"],255,255,255)
		guiLabelSetVerticalAlign(gLabel["mistysInfo"],"top")
		guiLabelSetHorizontalAlign(gLabel["mistysInfo"],"left",false)
		guiSetFont(gLabel["mistysInfo"],"default-bold-small")
		gLabel["bikerClubInfo"] = guiCreateLabel(0.0725,0.4255,0.9275,0.1094,"Harte Rockmusik, billiges Bier und starke Maschienen - \nMystis Bar, Treffpunkt fuer alle Biker in San Fierro!",true,gWindow["bikerClubWindow"])
		guiSetAlpha(gLabel["bikerClubInfo"],1)
		guiLabelSetColor(gLabel["bikerClubInfo"],200,200,000)
		guiLabelSetVerticalAlign(gLabel["bikerClubInfo"],"top")
		guiLabelSetHorizontalAlign(gLabel["bikerClubInfo"],"left",false)
		guiSetFont(gLabel["bikerClubInfo"],"default-bold-small")
	end
end
addEvent ( "showBikerBarWindow", true )
addEventHandler ( "showBikerBarWindow", getRootElement(), showBikerBarWindow_func )