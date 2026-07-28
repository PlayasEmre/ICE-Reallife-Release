--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Einheitliche Chat- und Infobox-Nachrichten     ||
--||   Version: 1.0                                   ||
--\\                                                  //
--
-- Wofuer ist das?
--
-- Im Script gibt es sehr viele outputChatBox-Aufrufe mit ganz
-- unterschiedlichen Farben und Schreibweisen. Diese Datei stellt dafuer
-- ein paar kurze Funktionen bereit, damit alle Meldungen gleich aussehen:
-- ein farbiges Kaestchen vorne, danach der Text in Weiss.
--
-- So sieht das im Chat aus:
--
--   [ INFO ]     Der Server startet in 5 Minuten neu.
--   [ OK ]       Fahrzeug erfolgreich gekauft.
--   [ FEHLER ]   Du hast nicht genug Geld.
--   [ ACHTUNG ]  Dein Fahrzeug hat kaum noch Benzin.
--   [ PREMIUM ]  Deine Mitgliedschaft laeuft in 3 Tagen ab.
--   [ ADMIN ]    PlayasEmre hat Testuser gekickt.
--
-- Benutzung (statt outputChatBox):
--
--   msgInfo    ( spieler, "Text" )
--   msgErfolg  ( spieler, "Text" )
--   msgFehler  ( spieler, "Text" )
--   msgWarnung ( spieler, "Text" )
--   msgPremium ( spieler, "Text" )
--   msgAdmin   ( spieler, "Text" )
--
-- Fuer alle Spieler einfach getRootElement() als Spieler uebergeben:
--   msgInfo ( getRootElement(), "Die Happy-Hour hat begonnen!" )
--
-- Und fuer die Infobox auf dem Bildschirm:
--   boxErfolg ( spieler, "Fahrzeug\ngekauft!" )
--
-- Die alten outputChatBox-Aufrufe funktionieren weiterhin - diese Datei
-- nimmt nichts weg, sie kommt nur dazu.


-- Farben und Beschriftung der Kaestchen
iceNachrichtenArten = {
	["info"]	= { farbe = "#4da3ff", text = "INFO",		r = 77,  g = 163, b = 255 },
	["erfolg"]	= { farbe = "#5ecb7a", text = "OK",			r = 94,  g = 203, b = 122 },
	["fehler"]	= { farbe = "#ff5a5a", text = "FEHLER",		r = 255, g = 90,  b = 90 },
	["warnung"]	= { farbe = "#ffb02e", text = "ACHTUNG",	r = 255, g = 176, b = 46 },
	["premium"]	= { farbe = "#ffd43b", text = "PREMIUM",	r = 255, g = 212, b = 59 },
	["admin"]	= { farbe = "#c792ea", text = "ADMIN",		r = 199, g = 146, b = 234 },
	["geld"]	= { farbe = "#69db7c", text = "GELD",		r = 105, g = 219, b = 124 },
	["fraktion"]= { farbe = "#74c0fc", text = "FRAKTION",	r = 116, g = 192, b = 252 }
}


--[[
	Die Hauptfunktion. Schreibt eine farbige Zeile in den Chat.

	ziel = ein Spieler oder getRootElement() fuer alle
	art  = "info", "erfolg", "fehler", "warnung", "premium", "admin", ...
]]
function iceNachricht ( ziel, text, art )

	if not ziel or not isElement ( ziel ) then return false end

	local vorlage = iceNachrichtenArten[art or "info"] or iceNachrichtenArten["info"]

	outputChatBox (
		vorlage.farbe.."[ "..vorlage.text.." ] #ffffff"..tostring ( text ),
		ziel, 255, 255, 255, true
	)
	return true
end

function msgInfo ( ziel, text )		return iceNachricht ( ziel, text, "info" ) end
function msgErfolg ( ziel, text )	return iceNachricht ( ziel, text, "erfolg" ) end
function msgFehler ( ziel, text )	return iceNachricht ( ziel, text, "fehler" ) end
function msgWarnung ( ziel, text )	return iceNachricht ( ziel, text, "warnung" ) end
function msgPremium ( ziel, text )	return iceNachricht ( ziel, text, "premium" ) end
function msgAdmin ( ziel, text )	return iceNachricht ( ziel, text, "admin" ) end
function msgGeld ( ziel, text )		return iceNachricht ( ziel, text, "geld" ) end
function msgFraktion ( ziel, text )	return iceNachricht ( ziel, text, "fraktion" ) end


--[[
	Trennlinie mit Ueberschrift - fuer Listen im Chat
	(z.B. bei /phelp oder /premium), damit man den Anfang erkennt.

	iceUeberschrift ( spieler, "PREMIUM UEBERSICHT" )
]]
function iceUeberschrift ( ziel, titel, art )

	if not ziel or not isElement ( ziel ) then return false end

	local vorlage = iceNachrichtenArten[art or "info"] or iceNachrichtenArten["info"]

	outputChatBox ( vorlage.farbe.."---------- #ffffff"..tostring ( titel ).." "..vorlage.farbe.."----------",
		ziel, 255, 255, 255, true )
	return true
end


--[[
	Infobox auf dem Bildschirm (das Kaestchen oben rechts).
	Zeilenumbrueche mit \n einbauen, dann bleibt der Text lesbar.

	dauer = Anzeigedauer in Millisekunden (Standard 5000 = 5 Sekunden)
]]
function iceBox ( spieler, text, art, dauer )

	if not spieler or not isElement ( spieler ) then return false end

	local vorlage = iceNachrichtenArten[art or "info"] or iceNachrichtenArten["info"]

	triggerClientEvent ( spieler, "infobox_start", getRootElement(),
		tostring ( text ), tonumber ( dauer ) or 5000,
		vorlage.r, vorlage.g, vorlage.b )
	return true
end

function boxInfo ( spieler, text, dauer )		return iceBox ( spieler, text, "info", dauer ) end
function boxErfolg ( spieler, text, dauer )		return iceBox ( spieler, text, "erfolg", dauer ) end
function boxFehler ( spieler, text, dauer )		return iceBox ( spieler, text, "fehler", dauer ) end
function boxWarnung ( spieler, text, dauer )	return iceBox ( spieler, text, "warnung", dauer ) end
function boxPremium ( spieler, text, dauer )	return iceBox ( spieler, text, "premium", dauer ) end


--[[
	Geldbetraege mit Punkten schreiben: 1250000 -> 1.250.000
	Damit im Chat nicht "1250000$" steht, was niemand schnell lesen kann.
]]
function iceGeld ( betrag )

	local zahl = tostring ( math.floor ( math.abs ( tonumber ( betrag ) or 0 ) ) )
	local ergebnis = ""
	local zaehler = 0

	for i = #zahl, 1, -1 do
		ergebnis = string.sub ( zahl, i, i )..ergebnis
		zaehler = zaehler + 1
		if zaehler % 3 == 0 and i > 1 then
			ergebnis = "."..ergebnis
		end
	end

	local minus = ((tonumber ( betrag ) or 0) < 0) and "-" or ""
	return minus..ergebnis.." $"
end


--[[
	Tage/Stunden lesbar machen: 90000 Sekunden -> "1 Tag, 1 Stunde"
	Praktisch fuer Premium-Restzeiten und Sperren.
]]
function iceDauer ( sekunden )

	sekunden = math.floor ( tonumber ( sekunden ) or 0 )
	if sekunden <= 0 then return "abgelaufen" end

	local tage = math.floor ( sekunden / 86400 )
	local stunden = math.floor ( ( sekunden % 86400 ) / 3600 )
	local minuten = math.floor ( ( sekunden % 3600 ) / 60 )

	local teile = {}
	if tage > 0 then teile[#teile+1] = tage..((tage == 1) and " Tag" or " Tage") end
	if stunden > 0 then teile[#teile+1] = stunden..((stunden == 1) and " Stunde" or " Stunden") end
	if #teile == 0 and minuten > 0 then teile[#teile+1] = minuten..((minuten == 1) and " Minute" or " Minuten") end
	if #teile == 0 then teile[#teile+1] = "weniger als eine Minute" end

	return table.concat ( teile, ", " )
end


outputDebugString ( "[Nachrichten] Farbige Chat- und Infobox-Meldungen geladen (msgInfo, msgErfolg, msgFehler, ...)." )
