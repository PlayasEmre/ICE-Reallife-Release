--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

function handyanrufen ()

	if gWindow["anrufen"] then
		dgsSetVisible ( gWindow["anrufen"], true )
		dgsSetVisible ( gWindow["handybg"], false )
		dgsSetVisible ( gWindow["sms"], false )
	else
		dgsSetVisible ( gWindow["sms"], false )
		dgsSetVisible ( gWindow["handybg"], false )
		
		gWindow["anrufen"] = dgsCreateWindow(screenwidth/2-156/2,120,156,66,"Handy Panel",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
		dgsSetAlpha(gWindow["anrufen"],1)
		dgsWindowSetMovable(gWindow["anrufen"],false)
		dgsWindowSetSizable(gWindow["anrufen"],false)
		gButton["callbtn"] = dgsCreateButton(0.5833,0.080,0.359,0.4545,"Anrufen",true,gWindow["anrufen"],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
		dgsSetAlpha(gButton["callbtn"],1)
		gEdit["callnr"] = dgsCreateEdit(0.0577,0.1000,0.4744,0.4545,"",true,gWindow["anrufen"])
		dgsSetAlpha(gEdit["callnr"],1)
		
		addEventHandler("onDgsMouseClickUp", gButton["callbtn"],
			function (button)
			if button == "left" then
				if dgsGetText ( gEdit["callnr"] ) ~= "" and tonumber ( dgsGetText ( gEdit["callnr"] ) ) then
					triggerServerEvent ( "callSomeone", localPlayer, localPlayer, dgsGetText ( gEdit["callnr"] ) )
					SelfCancelBtn ()
				end
			end	
		end,false)
		
	end
end

function handysmsschreiben ( number )

	if gWindow["sms"] then
		dgsSetVisible ( gWindow["anrufen"], false )
		dgsSetVisible ( gWindow["handybg"], false )
		dgsSetVisible ( gWindow["sms"], true )
	else
		dgsSetVisible ( gWindow["handybg"], false )
		
		gWindow["sms"] = dgsCreateWindow(screenwidth/2-191/2,120,191,128,"SMS schreiben",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
		dgsSetAlpha(gWindow["sms"],1)
		dgsWindowSetMovable(gWindow["sms"],false)
		dgsWindowSetSizable(gWindow["sms"],false)
		
		gEdit["smsnr"] = dgsCreateEdit(0.0419,0.1516,0.4136,0.2422,"",true,gWindow["sms"])
		dgsSetAlpha(gEdit["smsnr"],1)
		
		gLabel["nrtext"] = dgsCreateLabel(0.0419,0.0173,0.2932,0.1328,"Nummer:",true,gWindow["sms"])
		dgsSetAlpha(gLabel["nrtext"],1)
		dgsLabelSetColor(gLabel["nrtext"],200,200,0)
		dgsLabelSetVerticalAlign(gLabel["nrtext"],"top")
		dgsLabelSetHorizontalAlign(gLabel["nrtext"],"left",false)
		dgsSetFont(gLabel["nrtext"],"default-bold")
		gLabel["smstext"] = dgsCreateLabel(0.4817,0.0161,0.1885,0.1328,"Text:",true,gWindow["sms"])
		dgsSetAlpha(gLabel["smstext"],1)
		dgsLabelSetColor(gLabel["smstext"],200,200,0)
		dgsLabelSetVerticalAlign(gLabel["smstext"],"top")
		dgsLabelSetHorizontalAlign(gLabel["smstext"],"left",false)
		dgsSetFont(gLabel["smstext"],"default-bold")
		
		gMemo["smstext"] = dgsCreateMemo(0.4817,0.1359,0.4555,0.5625,"",true,gWindow["sms"])
		dgsSetAlpha(gMemo["smstext"],1)
		
		gButton["sendsms"] = dgsCreateButton(0.0471,0.425,0.4084,0.2734,"Senden",true,gWindow["sms"],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
		dgsSetAlpha(gButton["sendsms"],1)
		
		addEventHandler("onDgsMouseClick", gButton["sendsms"],function (button,state)
			if button == "left" and state == "down" then
				if dgsGetText ( gEdit["smsnr"] ) ~= "" and tonumber ( dgsGetText ( gEdit["smsnr"] ) ) then
					if dgsGetText ( gMemo["smstext"] ) ~= "" then
						local sendnr = tonumber ( dgsGetText ( gEdit["smsnr"] ) )
						local sendtext = dgsGetText ( gMemo["smstext"] )
						triggerServerEvent ( "SMS", localPlayer, localPlayer, sendnr, sendtext )
					end
				end
			end
		end,false)
	end
	dgsSetText ( gEdit["smsnr"], number )
end

function showHandy ()
	dgsSetInputEnabled ( false )
	if gWindow["handybg"] then
		dgsSetVisible ( gWindow["handybg"], true )
	else
		gWindow["handybg"] = dgsCreateWindow(screenwidth/2-125/2,120,125,184,"Handy Panel",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
		dgsSetAlpha(gWindow["handybg"],1)
		gLabel["eignummer"] = dgsCreateLabel(0.096,0.01319,0.752,0.1739,"Eigene Nummer:\n"..getElementData(localPlayer,"telenr"),true,gWindow["handybg"])
		dgsSetAlpha(gLabel["eignummer"],1)
		dgsLabelSetColor(gLabel["eignummer"],200,200,0)
		dgsLabelSetVerticalAlign(gLabel["eignummer"],"top")
		dgsLabelSetHorizontalAlign(gLabel["eignummer"],"left",false)
		dgsSetFont(gLabel["eignummer"],"default-bold")
		dgsWindowSetMovable(gWindow["handybg"],false)
		dgsWindowSetSizable(gWindow["handybg"],false)
		
		gButton["callfunc"] = dgsCreateButton(0.544,0.2207,0.384,0.1467,"Anrufen",true,gWindow["handybg"],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
		dgsSetAlpha(gButton["callfunc"],1)
		gButton["smsfunc"] = dgsCreateButton(0.096,0.2207,0.384,0.1467,"SMS",true,gWindow["handybg"],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
		dgsSetAlpha(gButton["smsfunc"],1)
		gButton["servicefunc"] = dgsCreateButton(0.584,0.4326,0.36,0.1467,"Service",true,gWindow["handybg"],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
		dgsSetAlpha(gButton["servicefunc"],1)
		gButton["handyonoff"] = dgsCreateButton(0.096,0.6337,0.448,0.1739,"Ein/Aus-\nschalten",true,gWindow["handybg"],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
		dgsSetAlpha(gButton["handyonoff"],1)
		gButton["telefonbuch"] = dgsCreateButton(0.096,0.4109,0.424,0.1848,"Telefon-\nbuch",true,gWindow["handybg"],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
		dgsSetAlpha(gButton["telefonbuch"],1)
		

		
		addEventHandler("onDgsMouseClickUp", gButton["telefonbuch"],
		function (button)
			if button == "left" then
				outputChatBox ( "Bitte /number [Name] benutzen!", 200, 200, 0 )
			end	
		end,false)
			
		addEventHandler("onDgsMouseClickUp", gButton["handyonoff"],
		function (button)
			if button == "left" then
				triggerServerEvent ( "handychange", localPlayer, localPlayer )
			end	
		end,false)
			
		addEventHandler("onDgsMouseClickUp", gButton["smsfunc"],
		function (button)
			if button == "left" then
				handysmsschreiben("")
			end
		end,false)
			
		addEventHandler("onDgsMouseClickUp", gButton["callfunc"],
		function (button)
			if button == "left" then
				handyanrufen()
			end
		end,false)
		
		addEventHandler("onDgsMouseClickUp", gButton["servicefunc"],
		function (button)
			if button == "left" then
				outputChatBox ( "Notfall: 110, Sanitäter: 112, Taxi: 400, Mechaniker: 300, Guthaben: *100#", 200, 200, 0 )
			end
		end,false)
		
	end
end
addCommandHandler ( "handy", showHandy )