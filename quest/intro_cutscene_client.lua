--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

-- Intro-Kamerafahrt: laeuft einmalig direkt nach der Registrierung (Trigger
-- siehe register_login/register_login_server.lua, "startIntroCutscene").
-- Die Kamera schwenkt nacheinander zu wichtigen Orten der Stadt (Bahnhof,
-- Rathaus, Autohaeuser, Fahrschule, alle Fraktionen) und wieder zurueck zum
-- Bahnhof. Dazu unten im Bild ein Untertitel-Kasten mit Text, wahlweise
-- vorgelesen per Sprachausgabe (siehe introPlayTTS weiter unten - nutzt
-- Googles inoffizielle Uebersetzer-TTS-Schnittstelle: braucht Internet auf
-- dem Client, kann theoretisch jederzeit ohne Vorwarnung aufhoeren zu
-- funktionieren, ist aber rein kosmetisch - die Kamerafahrt selbst laeuft
-- unabhaengig davon immer normal weiter). Ueberspringbar per Taste [N].

local introSzenen = {
	{ x=-1981.206, y=145.074, z=27.7,    int=0,  dim=0, text="Willkommen in San Fierro! Am Bahnhof beginnt deine Reise." },
	{ x=-2044.0,   y=449.744, z=35.2,    int=0,  dim=0, text="Das Rathaus - hier erledigst du wichtige Behoerdengaenge." },
	{ x=-1544.442, y=-440.828,z=6.0,     int=0,  dim=0, text="Der Flughafen San Fierro - hier gibt es Flugzeuge und Helikopter." },
	{ x=-1966.118, y=293.971, z=35.5,    int=0,  dim=0, text="Wang Cars - ein Autohaus fuer guenstige Fahrzeuge." },
	{ x=-1649.917, y=1209.813,z=7.25,    int=0,  dim=0, text="Otto's Autos - noch ein Autohaus mit grosser Auswahl." },
	{ x=-2185.056, y=2413.141,z=5.2,     int=0,  dim=0, text="Bayside Boats - hier gibt es Boote zu kaufen." },
	{ x=1714.812,  y=1616.190,z=10.1,    int=0,  dim=0, text="Der Flughafen Las Venturas - weitere Flugzeuge warten hier." },
	{ x=1689.002,  y=1850.704,z=11.2,    int=0,  dim=0, text="Dollahyde Used Autos - der Gebrauchtwagenhaendler." },
	{ x=2200.86,   y=1394.32, z=10.9,    int=0,  dim=0, text="Auto Bahn - ein weiteres Autohaus." },
	{ x=-911.116,  y=2686.191,z=42.8,    int=0,  dim=0, text="Hier gibt es besondere Bonus-Boote." },
	{ x=-902.849,  y=2681.642,z=42.7,    int=0,  dim=0, text="Und hier besondere Bonus-Fahrzeuge an Land." },
	{ x=1948.675,  y=2068.84, z=11.5,    int=0,  dim=0, text="Noch eine Auto Bahn - Fahrzeuge satt." },
	{ x=-2088.97,  y=-2262.41,z=30.3,    int=0,  dim=0, text="Der Kleinstadt-Haendler bietet ebenfalls Fahrzeuge an." },
	{ x=-1756.876, y=-116.164, z=6.5,    int=0,  dim=0, text="Die Fahrschule - hier machst du deinen Fuehrerschein." },
	{ x=-1630.0,   y=680.0,   z=15.0,   int=0,  dim=0, text="Das SFPD - die Polizei von San Fierro." },
	{ x=-691.36,   y=939.67,  z=13.6,   int=0,  dim=0, text="Die Mafia - eine der illegalen Fraktionen." },
	{ x=-2241.789, y=643.901, z=53.0,   int=0,  dim=0, text="Die Triaden - eine weitere kriminelle Organisation." },
	{ x=-1998.91,  y=-1563.29,z=85.4,   int=0,  dim=0, text="Die Terroristen - hier ist Vorsicht geboten." },
	{ x=-2520.77,  y=-623.44, z=132.8,  int=0,  dim=0, text="San News - hier arbeiten die Reporter der Stadt." },
	{ x=-2453.88,  y=503.82,  z=29.7,   int=0,  dim=0, text="Das FBI - die Bundespolizei." },
	{ x=-1321.77,  y=2475.6,  z=90.5,   int=0,  dim=0, text="Die Aztecas - eine weitere Strassengang." },
	{ x=-1346.17,  y=492.37,  z=10.9,   int=0,  dim=0, text="Die Armee - das Militaer von San Andreas." },
	{ x=-2186.93,  y=-2322.24,z=30.6,   int=0,  dim=0, text="Angels of Death - ein Biker-Club." },
	{ x=-2655.283, y=638.323, z=17.0,   int=0,  dim=0, text="Die Sanitaeter - hier werden Verletzte behandelt." },
	{ x=-2065.12,  y=-135.93, z=35.3,    int=0,  dim=0, text="Die Mechaniker - fuer Reparaturen und Tuning." },
	{ x=-2208.02,  y=56.26,   z=35.3,    int=0,  dim=0, text="Die Ballas - eine bekannte Strassengang." },
	{ x=-2446.27,  y=-86.6,   z=34.2,    int=0,  dim=0, text="Die Grove Street Families - eine weitere Gang." },
	{ x=-2143.948, y=1018.377,z=79.852, int=0,  dim=0,
	  camFixed = { x=-2143.948, y=1018.377, z=81.05, lookX=-2160.027, lookY=1020.851, lookZ=80.86 },
	  text="Anonymus - eine mysterioese Gruppierung." },
	{ x=-1981.206, y=145.074, z=27.7,    int=0,  dim=0, text="Das war unsere Tour! Viel Spass - dein Abenteuer beginnt jetzt!" },
}

local SZENEN_DAUER = 8000  -- ms, wie lange jede Szene stehen bleibt - laenger = mehr von der Kamerarotation ist zu sehen
local ORBIT_RADIUS = 40    -- weiter weg = man sieht mehr von der Umgebung, wirkt wie eine Aussenaufnahme statt Nahaufnahme
local ORBIT_HOEHE = 22     -- deutlich hoeher = Blick von oben herab auf den Ort, statt auf Augenhoehe direkt davor
local ORBIT_WINKEL_PRO_MS = 0.012 -- Grad/ms, sorgt fuer eine langsame Kamerarotation waehrend jeder Szene

-- Global (kein "local"), damit andere Skripte (z.B. helpmenue_client.lua,
-- clicksys_client.lua) waehrend der Kamerafahrt eigene Menues blockieren
-- koennen, indem sie am Anfang "if introCutsceneAktiv then return end" pruefen.
introCutsceneAktiv = false

local introIndex = 0
local introTimer = nil
local introStartTick = 0
local introIntBackup, introDimBackup = 0, 0
local introMusik = nil
local introSkipTasteWarUnten = false -- fuer die Flankenerkennung von getKeyState("n"), siehe introRenderFrame

-- ===== Sprachausgabe (Google-TTS, siehe Kommentar oben) =====

local function urlEncode ( str )
	str = str:gsub ( "([^%w %-%_%.%~])", function ( c ) return string.format ( "%%%02X", string.byte ( c ) ) end )
	return str:gsub ( " ", "+" )
end

local function introPlayTTS ( text )
	if not text or #text < 1 then return end
	if #text > 100 then text = text:sub ( 1, 100 ) end
	local url = "http://translate.google.com/translate_tts?tl=de&client=tw-ob&q="..urlEncode ( text )
	playSound ( url )
end

-- ===== Kamera =====

local function introRenderFrame ()
	if not introCutsceneAktiv then return end

	-- Skip-Taste [N] per Abfrage statt bindKey, da waehrend der Kamerafahrt
	-- guiSetInputMode("no_binds") aktiv ist (blockiert ALLE Tasten-Bindungen
	-- global, damit z.B. Chat/Inventar/Menues nicht dazwischenfunken koennen)
	-- - eine normale bindKey-Bindung wuerde davon selbst mitblockiert.
	if getKeyState ( "n" ) then
		if not introSkipTasteWarUnten then
			introSkipTasteWarUnten = true
			introBeenden ()
			return
		end
	else
		introSkipTasteWarUnten = false
	end

	if isCursorShowing () then
		showCursor ( false )
	end

	local szene = introSzenen[introIndex]
	if not szene then return end

	-- Feste Kamera (kein Rotieren) fuer Szenen, wo eine ganz bestimmte, per
	-- /pos ausgemessene Blickrichtung gewuenscht ist statt einer Rundumsicht.
	if szene.camFixed then
		local c = szene.camFixed
		setCameraMatrix ( c.x, c.y, c.z, c.lookX, c.lookY, c.lookZ )
		return
	end

	local vergangen = getTickCount () - introStartTick
	local winkel = math.rad ( vergangen * ORBIT_WINKEL_PRO_MS )
	local radius = szene.radius or ORBIT_RADIUS -- pro Szene ueberschreibbar, falls die Standardwerte an dieser Stelle ins Gelaende/Gebaeude clippen
	local hoehe = szene.hoehe or ORBIT_HOEHE

	local camX = szene.x + math.cos ( winkel ) * radius
	local camY = szene.y + math.sin ( winkel ) * radius
	local camZ = szene.z + hoehe

	setCameraMatrix ( camX, camY, camZ, szene.x, szene.y, szene.z + 1 )
end

-- ===== Untertitel-Anzeige =====

local screenW, screenH = guiGetScreenSize ()
local BALKEN_HOEHE = screenH * 0.11

local function introRenderUntertitel ()
	if not introCutsceneAktiv then return end
	local szene = introSzenen[introIndex]
	if not szene then return end

	-- Filmbalken oben/unten (Letterbox-Look)
	dxDrawRectangle ( 0, 0, screenW, BALKEN_HOEHE, tocolor ( 0, 0, 0, 235 ) )
	dxDrawRectangle ( 0, screenH - BALKEN_HOEHE, screenW, BALKEN_HOEHE, tocolor ( 0, 0, 0, 235 ) )

	-- Untertitel-Text im unteren Balken
	dxDrawText ( szene.text, screenW * 0.1, screenH - BALKEN_HOEHE, screenW * 0.9, screenH - BALKEN_HOEHE * 0.35,
		tocolor ( 255, 255, 255, 255 ), 1.15 * ( screenW / 1920 ), "default-bold", "center", "center", false, true )

	-- Fortschritt + Skip-Hinweis im oberen Balken
	dxDrawText ( "Einfuehrung "..introIndex.."/"..#introSzenen, screenW * 0.03, 0, screenW * 0.97, BALKEN_HOEHE * 0.6,
		tocolor ( 200, 200, 200, 255 ), 0.9 * ( screenW / 1920 ), "default-bold", "left", "center", false, true )
	dxDrawText ( "Taste [N] zum Ueberspringen", screenW * 0.03, 0, screenW * 0.97, BALKEN_HOEHE * 0.6,
		tocolor ( 200, 200, 200, 255 ), 0.9 * ( screenW / 1920 ), "default-bold", "right", "center", false, true )
end

-- ===== Ablauf =====

-- Wechselt tatsaechlich zur Szene i (Interior/Dimension/Kamera/Vorlesen) und
-- blendet danach wieder auf. Wird von introZeigeSzene() erst NACH der
-- Abblendung aufgerufen, siehe dort.
local function introWechsleSzene ( i )
	introIndex = i
	local szene = introSzenen[i]
	if not szene then
		return
	end

	introStartTick = getTickCount ()
	setElementInterior ( localPlayer, szene.int )
	setElementDimension ( localPlayer, szene.dim )
	introPlayTTS ( szene.text )
	fadeCamera ( true, 0.4 )

	if introTimer and isTimer ( introTimer ) then killTimer ( introTimer ) end
	if i >= #introSzenen then
		introTimer = setTimer ( introBeenden, SZENEN_DAUER, 1 )
	else
		introTimer = setTimer ( introZeigeSzene, SZENEN_DAUER, 1, i + 1 )
	end
end

-- Blendet kurz ab, bevor zur naechsten Szene gewechselt wird - der Sprung zu
-- Position/Interior der naechsten Station passiert waehrend des schwarzen
-- Bildes, dadurch wirkt der Uebergang nicht mehr wie ein kurzes Haengen/Ruckeln.
function introZeigeSzene ( i )
	fadeCamera ( false, 0.3 )
	if introTimer and isTimer ( introTimer ) then killTimer ( introTimer ) end
	introTimer = setTimer ( introWechsleSzene, 320, 1, i )
end

function introBeenden ()
	if not introCutsceneAktiv then return end
	introCutsceneAktiv = false
	tutorial = false

	if introTimer and isTimer ( introTimer ) then
		killTimer ( introTimer )
		introTimer = nil
	end

	removeEventHandler ( "onClientRender", root, introRenderFrame )
	removeEventHandler ( "onClientHUDRender", root, introRenderUntertitel )
	guiSetInputMode ( "allow_binds" )

	if isElement ( introMusik ) then
		destroyElement ( introMusik )
		introMusik = nil
	end

	setElementInterior ( localPlayer, introIntBackup )
	setElementDimension ( localPlayer, introDimBackup )
	setCameraTarget ( localPlayer )
	setPlayerHudComponentVisible ( "radar", true )
	showChat ( true )
	showCursor ( false )
	toggleAllControls ( true )

	triggerServerEvent ( "introCutsceneFinished", localPlayer )
end

function introStarten ()
	if introCutsceneAktiv then return end
	introCutsceneAktiv = true
	tutorial = true -- bestehender, bisher ungenutzter Haken in items/inventory_gui_client.lua

	introIntBackup = getElementInterior ( localPlayer )
	introDimBackup = getElementDimension ( localPlayer )

	setPlayerHudComponentVisible ( "radar", false )
	showChat ( false )
	showCursor ( false )
	toggleAllControls ( false )
	guiSetInputMode ( "no_binds" ) -- blockiert ALLE Tasten-Bindungen (Chat, F1, Tab, Inventar, ...), siehe introRenderFrame fuer die Skip-Taste-Ausnahme
	introSkipTasteWarUnten = getKeyState ( "n" ) -- verhindert ein sofortiges Uebersprringen, falls [N] zufaellig schon beim Start gedrueckt ist

	introMusik = playSound ( "register_login/Loginmusic.mp3", true )
	if not introMusik then
		introMusik = playSound ( "register_login/Loginmusic.mp3", true )
	end
	if introMusik then
		setSoundVolume ( introMusik, 0.3 )
	end

	addEventHandler ( "onClientRender", root, introRenderFrame )
	addEventHandler ( "onClientHUDRender", root, introRenderUntertitel )

	introZeigeSzene ( 1 )
end
addEvent ( "startIntroCutscene", true )
addEventHandler ( "startIntroCutscene", root, introStarten )
