--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

addEvent ( "deActivateCustomRadar", true )

function news1(player)
	if MtxGetElementData ( player, "loggedin" ) == 1 then
		outputChatBox ( " ≡≡≡≡≡≡≡≡≡≡≡ "..Tables.servername.."-Reallife Info ≡≡≡≡≡≡≡≡≡≡≡", getRootElement(),072,118,255)
		outputChatBox ( "→ "..Tables.servername.." Reallife verfügt über ein Report System /report", getRootElement() ,255,255,255 )
		outputChatBox ( "→ Unsere TeamSpeak IP: "..Tables.tsip.."", getRootElement(),255,255,255 )
		outputChatBox ( "→ Über /admins siehst du das Server Team", getRootElement() ,255,255,255 )
		outputChatBox ( "→ Hier könnt ihr alle Leader in der Fraktion sehen /checkLeader !", getRootElement(),255,255,255 )
		outputChatBox ( "→ Hier könnt ihr euren Level sehen /showLevel !", getRootElement(),255,255,255 )
		outputChatBox ( "→ Wir haben vor kurzem einen neuen Level Shop", getRootElement(),255,255,255 )
		outputChatBox ( "→ Wir wünschen dir viel Spaß!", getRootElement(),255,255,255 )
		if event.isHalloween then
			outputChatBox ( "→ Aktuell ist das Halloween-Event aktiv! Viel Spaß in der Kürbissuche!", getRootElement(),255,255,255 )
			outputChatBox ( "→ Befehle! /Kürbis ", getRootElement(),255,255,255 )
			outputChatBox ( "≡≡≡≡≡≡≡≡≡≡≡ Information beendet ≡≡≡≡≡≡≡≡≡", getRootElement(),072,118,255 )
		end
	end
end
setTimer(news1,60000,0)


function infobox ( player, text, time, r, g, b )
	if isElement ( player ) then
		triggerClientEvent ( player, "infobox_start", getRootElement(),text, time, r, g, b)
	end
end

local infoPickup = createPickup(-1979.5146484375,138.1455078125,27.6875,3,1239,500)

function infotext(thePlayer)
	outputChatBox("#47C1EEWillkommen #6DEC6Dauf #6DEC6DICE-Reallife #47C1EEUns gibt es schon seit 2019 #6DEC6DViel Spaß auf unserem Server",thePlayer,0,0,0,true)
end
addEventHandler("onPickupHit",infoPickup,infotext)
