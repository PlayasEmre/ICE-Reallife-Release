--//                                                                 \\
--||  Project: MTA - German ICE Reallife Gamemode                    ||
--||  Developers: PlayasEmre                                         ||
--||  Version: 5.0                                                   ||
--\\                                                                 //

-- Globale Variable für das Promocode-Editfeld, damit SubmitRegisterBtn darauf zugreifen kann.
promocodeEdit = nil

function SubmitRegisterBtn(button,state)
	if button == "left" and state == "up" then
		local pname = getPlayerName ( localPlayer )
		local passwort = dgsGetText( pw )
		local pwlaenge = #passwort
		
        -- NEU: Promocode auslesen
        local promocode = dgsGetText( promocodeEdit )

		if dgsGetText( pwAgain ) ~= passwort then
			outputChatBox ( "Die beiden Passwoerter stimmen nicht ueberein!",125, 0, 0)
		elseif pwlaenge < 6 or passwort == "******" or passwort == pname or passwort == "123456" then
			outputChatBox ("Fehler: Ungueltiges Passwort", 255, 0 ,0 )
		else
			local birth_correct = 0
			bday = tonumber( dgsGetText( registerDay ))
			bmon = tonumber( dgsGetText( registerMonth ))
			byear = tonumber( dgsGetText( registerYear ))
			if math.floor(bday) == bday and math.floor(bmon) == bmon and byear == math.floor (byear) then
				if bday < 32 and bday > 0 and byear < 2009 and byear > 1900 and bmon < 13 and bmon > 0 then
					if bday < 29 then
						birth_correct = 1
					elseif (bday == 29 or bday == 30) and bmon ~= 2 then
						birth_correct = 1
					elseif bday == 31 and ( bmon == 1 or bmon == 3 or bmon == 5 or bmon == 7 or bmon == 8 or bmon == 10 or bmon == 12 ) then
						birth_correct = 1
					elseif bday == 29 and bmon == 2 and math.floor((byear/4)) == byear/4 then
						birth_correct = 1
					end
				else
					birth_correct = 0
				end
			else
				birth_correct = 0
			end
			if birth_correct == 1 then
				if dgsRadioButtonGetSelected(weib) == false then
					geschlecht = 0
				elseif dgsRadioButtonGetSelected(oberbanga) == false then
					geschlecht = 1
				end
				player = localPlayer
				stopjoinmusik()
				removeEventHandler ( "onClientRender", root, Login)
				triggerServerEvent ( "register", localPlayer, player, hash ( "sha512", passwort ), bday, bmon, byear, geschlecht, promocode)
				dgsCloseWindow(register)
				killTimer(pwTimer)
				showChat(true)
				showCursor(false)
			else
				outputChatBox ("Fehler: Ungueltiges Geburtsdatum!", 255, 0 , 0 )
			end
		end
	end
end

function Login()
	local s,w = guiGetScreenSize()
	if event.islogin then
		dxDrawImage(0, 0, s, w, "register_login/login_register.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	elseif event.isHalloween then
		dxDrawImage(0, 0, s, w, "images/halloween.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
end

function showRegisterGui_func ()
	showCursor(true)
	
    -- GUI-Fenstergröße leicht vergrößert, um mehr vertikalen Platz zu schaffen.
    -- Höhe von 0.29 auf 0.35 erhöht.
    register = dgsCreateWindow(0.35, 0.32, 0.27, 0.35,"Registrieren",true,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
    
	dgsWindowSetSizable(register,false)
	dgsWindowSetMovable(register,false)
	tabmenu = dgsCreateTabPanel(0.02, 0.01, 0.96, 0.88,true, register)
	acc = dgsCreateTab("Account erstellen",tabmenu)
	reg = dgsCreateTab("Registrieren",tabmenu)
	
	-- Account Tab (acc) - Unverändert, außer Fenstergröße
	dgsCreateLabel(0.03, 0.02, 0.12, 0.13, "Name",true,acc)
	dgsCreateLabel(0.03, 0.17, 0.29, 0.13, getPlayerName(localPlayer),true,acc)
	dgsCreateLabel(0.03, 0.35, 0.15, 0.13, "Passwort",true,acc)
	pw = dgsCreateEdit( 0.03, 0.53, 0.29, 0.13, "", true, acc )
	dgsEditSetMasked(pw,true)
	dgsCreateLabel(0.38, 0.02, 0.37, 0.13, "Geburtstag (tt/mm/jjjj)",true,acc)
	registerDay = dgsCreateEdit( 0.38, 0.17, 0.09, 0.13, "", true, acc )
	registerMonth = dgsCreateEdit( 0.51, 0.17, 0.09, 0.13, "", true, acc )
	registerYear = dgsCreateEdit( 0.65, 0.17, 0.11, 0.13, "", true, acc )
	dgsCreateLabel(0.38, 0.35, 0.37, 0.13, "Geschlecht",true,acc)
	weib = dgsCreateRadioButton(0.38, 0.52, 0.23, 0.14, "Weiblich",true, acc)
	oberbanga = dgsCreateRadioButton(0.65, 0.52, 0.23, 0.14, "Männlich",true, acc)
	dgsRadioButtonSetSelected(weib, true)
	dgsEditSetMaxLength(registerDay,2)
	dgsEditSetMaxLength(registerMonth,2)
	dgsEditSetMaxLength(registerYear,4)
	pwSafety = dgsCreateProgressBar(0.03, 0.77, 0.29, 0.18, true, acc)
	
	-- Registrieren Tab (reg) - Optimierte Positionen für besseres Layout
    -- Hinweis-Label: Etwas nach unten verschoben und die Höhe angepasst für eine bessere Lesbarkeit.
	dgsCreateLabel(0.05, 0.05, 0.90, 0.15, "Überprüfe deine Daten und gebe dein Passwort\nnochmal ein.",true,reg)
	
    -- Promocode Label und Editfeld: Vertikalen Abstand erhöht und breiter gemacht.
    dgsCreateLabel(0.05, 0.25, 0.90, 0.1, "Promo Code (optional)",true,reg)
    promocodeEdit = dgsCreateEdit(0.05, 0.35, 0.90, 0.13, "", true, reg )
    
    -- Passwort Wiederholung Label und Editfeld: Vertikalen Abstand erhöht und breiter gemacht.
	dgsCreateLabel(0.05, 0.53, 0.90, 0.1, "Passwort Wiederholung",true,reg)
	pwAgain = dgsCreateEdit(0.05, 0.63, 0.90, 0.13, "", true, reg )
	
    -- Registrierungsbutton: Deutlich mehr Abstand nach oben, zentriert und etwas breiter.
	regButton = dgsCreateButton(0.05, 0.83, 0.90, 0.13, "Registrierung abschließen", true, reg, nil, nil, nil, nil, nil, nil, tocolor(1,223,1), tocolor(4,170,4), tocolor(4,170,4) )
    
	setTimer(checkPWSafety,250,1)
	dgsEditSetMasked(pwAgain,true)
	addEventHandler ( "onDgsMouseClickUp", regButton, SubmitRegisterBtn, false )
	addEventHandler ( "onClientRender", root, Login)
end
addEvent ( "ShowRegisterGui", true)
addEventHandler ( "ShowRegisterGui", getRootElement(), showRegisterGui_func )

function checkPWSafety ()
	local pw = tostring ( dgsGetText( pw ) )
	safety = # pw
	if safety >= 10 then
		safety = 50
	elseif safety >= 7 then
		safety = 30
	else
		safety = 10
	end
	if tonumber ( pw ) then	
		safety = safety
	else
		safety = safety + 25
	end
	if pw ~= "123456" then
		safety = safety + 25
	end
	if # pw < 6 then
		safety = 0
	end
	dgsProgressBarSetProgress(pwSafety, safety)
	
	pwTimer = setTimer ( checkPWSafety, 250, 1 )
end