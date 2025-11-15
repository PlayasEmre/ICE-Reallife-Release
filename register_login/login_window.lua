--//                                                                 \\
--||  Project: MTA - German ICE Reallife Gamemode                    ||
--||  Developers: PlayasEmre                                         ||
--||  Version: 5.0                                                   ||
--\\                                                                 //

addEvent('ShowLoginWindow', true )
addEvent ( "aktualisiereMemberTabelle", true )

function Login()
    local s,w = guiGetScreenSize()
	if event.islogin then
		dxDrawImage(0, 0, s, w, ":"..getResourceName(getThisResource()).."/register_login/login_register.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	elseif event.isHalloween then
		dxDrawImage(0, 0, s, w, ":"..getResourceName(getThisResource()).."/images/halloween.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
   end
end

addEvent("cdn:onClientReady",true)
addEventHandler("cdn:onClientReady",root,function()
	if event.islogin then
		joinmusik = playSound (":"..getResourceName(getThisResource()).."/register_login/Loginmusic.mp3")
		setSoundVolume(joinmusik, 0.5)
	elseif event.isHalloween then
		halloweenmusik = playSound( ":"..getResourceName(getThisResource()).."/sounds/bell.ogg")
		setSoundVolume(halloweenmusik, 0.3)
		setAmbientSoundEnabled( "gunfire", false )
	end
end)

function stopjoinmusik()
	if event.islogin and isElement(joinmusik) then
		stopSound( joinmusik )
	end
	if event.isHalloween and isElement(halloweenmusik) then
		stopSound( halloweenmusik )
	end
end


function isWithinNightTime ()
    local time = getRealTime()
    local hour = time.hour
    if hour >= 20 or hour <= 8 then
        return true
    else
        return false
    end
end

function _CreateLoginWindow()
    removeEventHandler ( "onClientRender", root, Login)
	showCursor(true)
    login = dgsCreateWindow(0.44, 0.43, 0.15, 0.19,"Anmelden",true,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
    dgsWindowSetSizable(login,false)
    dgsWindowSetMovable(login,false)
    dgsCreateLabel(0.04, 0.11, 0.30, 0.12,"Kennwort:",true,login)
    pw = dgsCreateEdit( 0.04, 0.25, 0.91, 0.14, "", true,login)
	dgsSetProperty(pw,"masked",true)
    dgsCreateLabel(0.05, 0.44, 0.65, 0.12, "Kennwort speichern",true,login)
    loginButton = dgsCreateButton(0.23, 0.69, 0.47, 0.15, "Einloggen", true, login, nil, nil, nil, nil, nil, nil, tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255) )
    pwSafeYes = dgsCreateRadioButton(0.05, 0.56, 0.50, 0.08, "Ja",true, login)
    pwSafeNo = dgsCreateRadioButton(0.67, 0.56, 0.25, 0.08, "Nein",true, login)
    addEventHandler ( "onDgsMouseClickUp", loginButton, SubmitEinloggenBtn, false )
	addEventHandler ( "onClientRender", root, Login)
	local pwfile = xmlLoadFile ( ":"..Tables.servername.."/pw.xml" )
	local psafe
	if not pwfile then
		pwfile = xmlCreateFile ( ":"..Tables.servername.."/pw.xml", "PW" )
		psafe = xmlCreateChild ( pwfile, "pw" )
		xmlSaveFile ( pwfile )
	else
		psafe = xmlFindChild ( pwfile, "pw", 0 )
	end
	if psafe then
		local success = xmlNodeGetValue ( psafe )
		dgsSetText(pw, success)
		dgsRadioButtonSetSelected(pwSafeYes, true)
		dgsSetProperty(pw,"masked",true)
	end
end

function SubmitEinloggenBtn(button)
	if button == "left" then
		local name = getPlayerName(localPlayer)
		local passwort = dgsGetText(pw)
		local file = xmlLoadFile ( ":"..Tables.servername.."/pw.xml" )
		if file then
			local psafe = xmlFindChild ( file, "pw", 0 )
			if psafe then
				if dgsRadioButtonGetSelected(pwSafeYes) then 
					xmlNodeSetValue(psafe, passwort)
				elseif dgsRadioButtonGetSelected(pwSafeNo) then 
					xmlNodeSetValue(psafe, "")
				end
				xmlSaveFile(file)
			end
		end
		triggerServerEvent ("einloggen",localPlayer,localPlayer,hash("sha512",passwort))
		GUI_DisableLoginWindow()
	end
end

function GUI_ShowLoginWindow()
	_CreateLoginWindow()
end
addEventHandler ( "ShowLoginWindow", getRootElement(), GUI_ShowLoginWindow)


function GUI_DisableLoginWindow()
    if login and isElement(login) then 
        dgsCloseWindow(login)
        login = nil
    end
	stopjoinmusik()
    showCursor(false)
    setTimer ( checkForSocialStateChanges, 10000, 0 )
    setTimer ( getPlayerSocialAvailableStates, 1000, 1 )
    if isTimer ( LVCamFlightTimer ) then
        killTimer ( LVCamFlightTimer )
    end
    setElementClicked ( false )
	removeEventHandler ( "onClientRender", root, Login)
	local hud = tonumber(getElementData(localPlayer,"hud"))
	triggerEvent( "showhudclient", localPlayer, hud)
end
addEvent ( "DisableLoginWindow", true )
addEventHandler ( "DisableLoginWindow", getRootElement(), GUI_DisableLoginWindow)

function check()
	local player = localPlayer
	triggerServerEvent ( "regcheck", localPlayer, player )
end
addEventHandler('cdn:onClientReady', root, check)