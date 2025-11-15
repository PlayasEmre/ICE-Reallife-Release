--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

-- Decompile Security		--
sec = {{{{{{},{},{},{}}}}}} --
------------------------------
-- Variables				--
------------------------------
local subTrackOnSoundDown = 0.1	-- The volume that goes down, when the player clicks "Volume -"
local subTrackOnSoundUp = 0.1	-- The volume that goes up, when the player clicks "Volume +"
local antiSpam = 0

------------------------------
-- The GUI					--
------------------------------
local rx, ry = guiGetScreenSize ( )
button = { }
local carradios = {}
window = dgsCreateWindow( ( rx - 295 ), ( ry / 2 - 253 / 2 ), 293, 253, ""..Tables.servername.."-Reallife Lautsprecher",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
dgsWindowSetSizable(window, false)
dgsWindowSetMovable(window ,false)
dgsSetVisible ( window, false )
CurrentSpeaker = dgsCreateLabel(8, 33, 254, 17, "Haben sie derzeit einen Lautsprecher: Nein", false, window)
volume = dgsCreateLabel(10, 50, 252, 17, "Aktuelles Volume: 100%", false, window)
pos = dgsCreateLabel(10, 66, 252, 15, "X: 0 | Y: 0 | Z: 0", false, window)
dgsCreateLabel(11, 81, 251, 15, "URL:", false, window)
url = dgsCreateEdit(11, 96, 272, 23, "", false, window)  
button["place"] = dgsCreateButton(9, 129, 274, 20, "Lautsprecher setzen", false, window,_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
button["remove"] = dgsCreateButton(9, 159, 274, 20, "Lautsprecher löschen", false, window,_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
button["v-"] = dgsCreateButton(9, 189, 128, 20, "Volumen -", false, window,_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
button["v+"] = dgsCreateButton(155, 189, 128, 20, "Volumen +", false, window,_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)
button["close"] = dgsCreateButton(9, 215, 280, 10, "Verlassen", false, window,_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(0,255,0,255),true)  

--------------------------
-- My sweet codes		--
--------------------------
local isSound = false
addEvent ( "onPlayerViewSpeakerManagment", true )
addEventHandler ( "onPlayerViewSpeakerManagment", root, function ( current )
	local toState = not dgsGetVisible ( window ) 
	dgsSetVisible ( window, toState )
	setElementClicked ( toState )
	if ( toState == true ) then
		dgsSetInputMode ( "no_binds_when_editing" )
		local x, y, z = getElementPosition ( localPlayer )
		dgsSetText ( pos, "X: "..math.floor ( x ).." | Y: "..math.floor ( y ).." | Z: "..math.floor ( z ) )
		if ( current ) then dgsSetText ( CurrentSpeaker, "Haben Sie derzeit einen Lautsprecher: Ja" ) isSound = true
		else dgsSetText ( CurrentSpeaker, "Haben Sie derzeitig einen Lautsprecher: Nein" ) end
	end
end )

addEventHandler ( "onDgsMouseClickUp", root, function (btn)
	if ( source == button["close"] ) and btn == "left" then
		dgsSetVisible ( window, false ) 
		showCursor ( false )
		setElementClicked ( false )
	elseif ( source == button["place"] ) then
		if antiSpam + 1000 <= getTickCount() then
			if ( isURL ( ) ) then
				local theurl = dgsGetText ( url )
				if string.find ( theurl, "youtube" ) then
					theurl = "https://music.youtube.com/watch?v=" .. theurl
				end
				antiSpam = getTickCount()
				triggerServerEvent ( "onPlayerPlaceSpeakerBox", localPlayer, theurl, isPedInVehicle ( localPlayer ) )
				dgsSetText ( CurrentSpeaker, "Haben sie derzeitig einen Lautsprecher: Ja" )
				isSound = true
				dgsSetText ( volume, "Aktuelles Volume: 100%" )
			else
				outputChatBox ( "Du braucht einen URL Link.", 255, 0, 0 )
			end
		else
			outputChatBox ( "Nicht spamen!.", 255, 0, 0 )
		end
	elseif ( source == button["remove"] ) then
		if antiSpam + 1000 <= getTickCount() then
			triggerServerEvent ( "onPlayerDestroySpeakerBox", localPlayer )
			dgsSetText ( CurrentSpeaker, "Haben sie derzeitig einen Lautsprecher: Nein" )
			isSound = false
			antiSpam = getTickCount()
			dgsSetText ( volume, "Aktuelles Volumen: 100%" )
		else
			outputChatBox ( "Nicht spamen!.", 255, 0, 0 )
		end
	elseif ( source == button["v-"] ) then
		if antiSpam + 200 <= getTickCount() then
			if ( isSound ) then
				local toVol = math.round ( getSoundVolume ( speakerSound [ localPlayer ] ) - subTrackOnSoundDown, 2 )
				if ( toVol > 0.0 ) then
					antiSpam = getTickCount()
					outputChatBox ( "Volumen gesetzt auf "..math.floor ( toVol * 100 ).."%!", 0, 255, 0 )
					triggerServerEvent ( "onPlayerChangeSpeakerBoxVolume", localPlayer, toVol )
					dgsSetText ( volume, "Aktuelles Volume: "..math.floor ( toVol * 100 ).."%" )
				else
					outputChatBox ( "Das Volumen kann nicht leiser gemacht werden.", 255, 0, 0 )
				end
			end
		else
			outputChatBox ( "Nicht spamen!.", 255, 0, 0 )
		end
	elseif ( source == button["v+"] ) then
		if antiSpam + 200 <= getTickCount() then
			if ( isSound ) then
				local toVol = math.round ( getSoundVolume ( speakerSound [ localPlayer ] ) + subTrackOnSoundUp, 2 )
				if ( toVol <= 1.0 ) then
					antiSpam = getTickCount()
					outputChatBox ( "Volumen gesetzt auf "..math.floor ( toVol * 100 ).."%!", 0, 255, 0 )
					triggerServerEvent ( "onPlayerChangeSpeakerBoxVolume", localPlayer, toVol )
					dgsSetText ( volume, "Aktuelles Volume: "..math.floor ( toVol * 100 ).."%" )
				else
					outputChatBox ( "Das Volumen kann nicht höher gemacht werden.", 255, 0, 0 )
				end
			end
		else
			outputChatBox ( "Nicht spamen!.", 255, 0, 0 )
		end
	end
end)

speakerSound = { }
addEvent ( "onPlayerStartSpeakerBoxSound", true )
addEventHandler ( "onPlayerStartSpeakerBoxSound", root, function ( url, isCar )
	local who = source
	if ( isElement ( speakerSound [ who ] ) ) then destroyElement ( speakerSound [ who ] ) end
	local x, y, z = getElementPosition ( who )
	speakerSound [ who ] = playSound3D ( url, x, y, z, true )
	setSoundVolume ( speakerSound [ who ], 1 )
	setSoundMinDistance ( speakerSound [ who ], 13 )
	setSoundMaxDistance ( speakerSound [ who ], 48 )
	local int = getElementInterior ( who )
	setElementInterior ( speakerSound [ who ], int ) 
	setElementDimension ( speakerSound [ who ], getElementDimension ( who ) )
	if ( isCar ) then
		local car = getPedOccupiedVehicle ( who )
		attachElements ( speakerSound [ who ], car, 0, 0, 1 )
		addEventHandler ( "onClientVehicleRespawn", car, deleteTheVIPRadio )
		addEventHandler ( "onClientVehicleExplode", car, deleteTheVIPRadio )
		carradios[car] = who
	else
		attachElementToBone ( speakerSound [ who ], who, 12, 0, 0, 0.42, 180, 0, 180 )
	end
end )

function deleteTheVIPRadio ( ) 
	if isElement ( speakerSound [ source ] ) then 
		destroyElement ( speakerSound [ source ] ) 
	elseif isElement (source) and getElementType ( source ) == "vehicle" then
		destroyElement ( speakerSound [ carradios[source] ] ) 
		speakerSound [ carradios[source] ] = nil
		carradios[source] = nil
		removeEventHandler ( "onClientVehicleRespawn", source, deleteTheVIPRadio )
		removeEventHandler ( "onClientVehicleExplode", source, deleteTheVIPRadio )
	end
end 
addEvent ( "onPlayerDestroySpeakerBox", true )
addEventHandler ( "onPlayerDestroySpeakerBox", root, deleteTheVIPRadio )

function attackerSpeakerOnPlayer ( thebox ) 
	attachElementToBone ( thebox, source, 12, 0, 0, 0.42, 180, 0, 180 )
end
addEvent ( "attachSpeakerBoxOnPlayer", true )
addEventHandler ( "attachSpeakerBoxOnPlayer", root, attackerSpeakerOnPlayer )

--------------------------
-- Volume				--
--------------------------
addEvent ( "onPlayerChangeSpeakerBoxVolumeC", true )
addEventHandler ( "onPlayerChangeSpeakerBoxVolumeC", root, function ( vol ) 
	if ( isElement ( speakerSound [ source ] ) ) then
		setSoundVolume ( speakerSound [ source ], tonumber ( vol ) )
	end
end )

function isURL ( )
	if ( dgsGetText ( url ) ~= "" ) then
		return true
	else
		return false
	end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
