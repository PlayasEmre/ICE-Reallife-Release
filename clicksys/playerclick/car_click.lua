--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

function SubmitFahrzeugAbbrechenBtn(button)
	if button == "left" then
		if gWindows["vehinteraktion"] then
			dgsSetVisible ( gWindows["vehinteraktion"], false )
			if gWindow["vehCarDelete"] then
				dgsSetVisible ( gWindow["vehCarDelete"], false )
			end
			showCursor ( false )
			setElementClicked ( false )
		end
	end
end

function _createCarmenue_func ( veh )
	if gWindows["vehinteraktion"] then
		dgsSetVisible ( gWindows["vehinteraktion"], true )
		if gWindow["vehCarDelete"] then
			dgsSetVisible ( gWindow["vehCarDelete"], true )
		end
	else
		if getElementData ( localPlayer, "adminlvl" ) >= 3 then
			gWindow["vehCarDelete"] = dgsCreateWindow(0,screenheight/2-132/2,151,137,"Admin Panel",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
			dgsWindowSetSizable(gWindow["vehCarDelete"],false)
			dgsWindowSetMovable(gWindow["vehCarDelete"],false)
			gButton["vehCarDel"] = dgsCreateButton(0.0596,0.1000,0.3974,0.2555,"Loeschen",true,gWindow["vehCarDelete"])
			dgsSetAlpha(gButton["vehCarDel"],1)
			gButton["vehCarResp"] = dgsCreateButton(0.4901,0.1000,0.457,0.2555,"Respawnen",true,gWindow["vehCarDelete"])
			dgsSetAlpha(gButton["vehCarResp"],1)
			gLabel["vehCarInfo1"] = dgsCreateLabel(0.0596,0.3891,0.3113,0.1387,"Grund:",true,gWindow["vehCarDelete"])
			dgsSetAlpha(gLabel["vehCarInfo1"],1)
			dgsLabelSetColor(gLabel["vehCarInfo1"],255,255,255)
			dgsLabelSetVerticalAlign(gLabel["vehCarInfo1"],"top")
			dgsLabelSetHorizontalAlign(gLabel["vehCarInfo1"],"left",false)
			dgsSetFont(gLabel["vehCarInfo1"],"default-bold")
			gMemo["vehCarReason"] = dgsCreateMemo(0.0996,0.5300,0.7808,0.2258,"",true,gWindow["vehCarDelete"])
			dgsSetAlpha(gMemo["vehCarReason"],1)
			
			addEventHandler("onDgsMouseClickUp", gButton["vehCarResp"], 
				function(button,state)
				if button == "left" then
					local veh = vioClientGetElementData ( "clickedVehicle" )
					local towcar = getElementData ( veh, "carslotnr_owner" )
					local pname = getElementData ( veh, "owner" )
					triggerServerEvent ( "respawnVeh", localPlayer, towcar, pname, veh )
					SubmitFahrzeugAbbrechenBtn("left")
				end	
			end,false)
			
			addEventHandler("onDgsMouseClickUp", gButton["vehCarDel"],
					function(button,state)
					if button == "left" then
						local veh = vioClientGetElementData ( "clickedVehicle" )
						local towcar = getElementData ( veh, "carslotnr_owner" )
						local pname = getElementData ( veh, "owner" )
						if not pname then
							triggerServerEvent ( "moveVehicleAway", lp, veh )
						else
							triggerServerEvent ( "deleteVeh", lp, towcar, pname, veh, dgsGetText ( gMemo["vehCarReason"] ) )
						end
						SubmitFahrzeugAbbrechenBtn("left")
					end
				end,false)
			end
			
			gWindows["vehinteraktion"] = dgsCreateWindow(screenwidth/2-224/2,screenheight/2-232/2,240,180,"Fahrzeug Panel",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
			dgsWindowSetSizable(gWindows["vehinteraktion"],false)
			dgsWindowSetMovable(gWindows["vehinteraktion"],false)
			gButtons["vehabschliessen"] = dgsCreateButton(0.0402,0.0618,0.442,0.3485,"Abschliessen",true,gWindows["vehinteraktion"])
			dgsSetAlpha(gButtons["vehabschliessen"],1)
			gButtons["vehrespawn"] = dgsCreateButton(0.52,0.0630,0.442,0.3485,"Respawnen",true,gWindows["vehinteraktion"])
			dgsSetAlpha(gButtons["vehrespawn"],1)
			gButtons["vehinfo"] = dgsCreateButton(0.0402,0.49,0.442,0.3485,"Infos",true,gWindows["vehinteraktion"])
			dgsSetAlpha(gButtons["vehinfo"],1)
			gButtons["vehcancel"] = dgsCreateButton(0.52,0.49,0.442,0.3485,"Abbrechen",true,gWindows["vehinteraktion"])
			dgsSetAlpha(gButtons["vehcancel"],1)

			addEventHandler("onDgsMouseClickUp",gButtons["vehcancel"],SubmitFahrzeugAbbrechenBtn,false)
			
			addEventHandler("onDgsMouseClickUp", gButtons["vehrespawn"],function(button,state)
				if button == "left" then
					local veh = vioClientGetElementData ( "clickedVehicle" )
					if veh then
						if getElementData ( veh, "owner" ) == getPlayerName ( localPlayer ) then
							triggerServerEvent ( "respawnPrivVehClick", localPlayer, localPlayer, "lock", tonumber ( getElementData ( veh, "carslotnr_owner" ) ) )
						else
							outputChatBox ( "Das Fahrzeug gehoert dir nicht!", 125, 0, 0 )
						end
					end
				end
			end,false)
			
			addEventHandler("onDgsMouseClickUp", gButtons["vehabschliessen"], 
				function (button,state)
				if button == "left" then
					local veh = vioClientGetElementData ( "clickedVehicle" )
					if veh then
						if getElementData ( veh, "owner" ) == getPlayerName ( localPlayer ) then
							triggerServerEvent ( "lockPrivVehClick", localPlayer, localPlayer, "lock", tonumber ( getElementData ( veh, "carslotnr_owner" ) ) )
						else
							outputChatBox ( "Das Fahrzeug gehoert dir nicht!", 125, 0, 0 )
						end
					end
				end
			end,false)
			
			addEventHandler("onDgsMouseClickUp", gButtons["vehinfo"], 
				function (button,state)
				if button == "left" then
					local veh = vioClientGetElementData ( "clickedVehicle" )
						if veh then
							local owner = getElementData ( veh, "owner" )
							if not owner or owner == "console" then
								owner = "Niemand"
							end
							local stunings = sTuningsToString ( veh )
							outputChatBox ( "Fahrzeug Modell: "..getVehicleName (veh)..", Besitzer: "..owner, 0, 120, 200 )
							outputChatBox ( "Tunings: "..stunings, 0, 120, 200 )
						end
					end
			end,false)
	end
end
addEvent ( "_createCarmenue", true )
addEventHandler ( "_createCarmenue", getRootElement(), _createCarmenue_func )

function sTuningsToString ( veh )
	if veh and getElementType (veh) == "vehicle" then
		local carstring = ""
		if getElementData ( veh, "stuning1" ) and getElementData ( veh, "stuning1" ) >= 1 then
			carstring = "Kofferraum"
		end
		if getElementData ( veh, "stuning2" ) and getElementData ( veh, "stuning2" ) >= 1 then
			if carstring == "" then
				carstring = "Panzerung"
			else
				carstring = carstring..", Panzerung"
			end
		end
		if getElementData ( veh, "stuning3" ) and getElementData ( veh, "stuning3" ) >= 1 then
			if carstring == "" then
				carstring = "Benzinersparnis"
			else
				carstring = carstring..", Benzinersparnis"
			end
		end
		if getElementData ( veh, "stuning4" ) and getElementData ( veh, "stuning4" ) >= 1 then
			if carstring == "" then
				carstring = "GPS"
			else
				carstring = carstring..", GPS"
			end
		end
		if getElementData ( veh, "stuning5" ) and getElementData ( veh, "stuning5" ) >= 1 then
			if carstring == "" then
				carstring = "Doppelreifen"
			else
				carstring = carstring..", Doppelreifen"
			end
		end
		if getElementData ( veh, "stuning6" ) and getElementData ( veh, "stuning6" ) >= 1 then
			if carstring == "" then
				carstring = "Nebelwerfer"
			else
				carstring = carstring..", Nebelwerfer"
			end
		end
		if getVehicleType ( veh ) ~= "Plane" and getVehicleType ( veh ) ~= "Helicopter" then
			local sportmotor = getElementData ( veh,"sportmotor" )
			if sportmotor and sportmotor > 0 then
				if carstring == "" then
					carstring = "Sportmotor "..sportmotor
				else
					carstring = carstring..", Sportmotor "..sportmotor
				end
			end
			local bremse = getElementData ( veh,"bremse" )
			if bremse and bremse > 0 then
				if carstring == "" then
					carstring = "Bremse "..bremse
				else
					carstring = carstring..", Bremse "..bremse
				end
			end
			local radtyp = getVehicleHandling ( veh )["driveType"]
			if radtyp == "rwd" then
				radtyp = "Heckantrieb"
			elseif radtyp == "awd" then
				radtyp = "Allradantrieb"
			else
				radtyp = "Frontantrieb"
			end
			if carstring == "" then
				carstring = radtyp
			else
				carstring = carstring..", "..radtyp
			end
		end
		if carstring == "" then
			return "Keine"
		else
			return carstring
		end
	end
end