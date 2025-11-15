--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

_G["Clantag"] = "no"
setGlitchEnabled ( "fastsprint", true )

clanMembers = {}
ticketPermitted = {}

addEventHandler ( "onPlayerConnect", getRootElement(), function ( nick, ip, uname, serial )
	if nick == "Player" then
		cancelEvent ( true, "Bitte wähle einen Nickname ( Unter \"Settings\" )" )
	elseif string.find ( nick, "mtasa" ) then
		cancelEvent ( true, "Fuck you!" )
	elseif string.find ( nick, "'" ) then
		cancelEvent ( true, "Bitte kein ' benutzen!" )
	else
		local result = nil
		if playerUID[nick] then 
			result = dbPoll ( dbQuery ( handler, "SELECT STime, Grund, AdminUID FROM ?? WHERE UID=? AND ??=?", "ban", playerUID[nick], "Serial", serial ), -1 )
		else
			result = dbPoll ( dbQuery ( handler, "SELECT STime, Grund, AdminUID FROM ?? WHERE ??=?", "ban", "Serial", serial ), -1 )
		end
		local deleteit = false
		if result and result[1] then
			for i=1, #result do
				if result[i]["STime"] ~= 0 and ( result[i]["STime"] - getTBanSecTime ( 0 ) ) <= 0 then
					deleteit = true
				else
					local reason = result[i]["Grund"]
					local admin = playerUIDName[tonumber ( result[i]["AdminUID"] )]
					local diff = math.floor ( ( ( result[i]["STime"] - getTBanSecTime ( 0 ) ) / 60 ) * 100 ) / 100
					if diff >= 0 then
						cancelEvent ( true, "Du bist noch "..diff.." Stunden von "..tostring(admin).." gesperrt, Grund: "..tostring(reason) )
					else
						cancelEvent ( true, "Du wurdest permanent von "..tostring(admin).." gesperrt, Grund: "..tostring(reason) )
					end
					return
				end
			end
			if deleteit then
				if playerUID[nick] then
					dbExec ( handler, "DELETE FROM ?? WHERE UID=? OR Serial=?", "ban", playerUID[nick], serial )
				else
					dbExec ( handler, "DELETE FROM ?? WHERE Serial=?", "ban", serial )
				end
			end
		elseif getPlayerWarnCount ( nick ) >= 3 then
			cancelEvent ( true, "Du hast 3 Warns! Ablaufdatum des nächsten Warns: "..getLowestWarnExtensionTime ( nick ) )
		end
	end
end )



function regcheck_func ( player )

	setPedStat ( player, 22, 50 )
	setElementFrozen ( player, true )
	MtxSetElementData  ( player, "loggedin", 0 )
	
	local pname = getPlayerName ( player )
	toggleAllControls ( player, false )
	if player == client then
		if isSerialValid ( getPlayerSerial(player) ) or isRegistered ( pname ) then
			if ( hasInvalidChar ( player ) or string.find ( pname, "'" ) ) and not isRegistered ( pname ) then
				kickPlayer ( player, "Dein Name enthält ungültige Zeichen!" )
			else
				if pname ~= "player" then
					if isRegistered ( pname ) then
						local serial = getPlayerSerial ( player )
						local thename = ""
						local haterlaubnis = false
						local result = dbPoll ( dbQuery ( handler, "SELECT Name, Erlaubnis FROM players WHERE ?? LIKE ?", "Serial", serial ), -1 )
						if result and result[1] then
							thename = result[1]["Name"]
							if tonumber ( result[1]["Erlaubnis"] ) == 1 then
								thename = pname 
								haterlaubnis = true
							end
						else
							thename = pname
						end
						--if string.lower(thename) ~= string.lower(getPlayerName(player)) then
						if thename ~= getPlayerName(player) then
							if not haterlaubnis then
								kickPlayer ( player, "Du hast schon ein Account mit einem anderen Namen ("..thename..")" )
								return false
							end
						end
						
						triggerClientEvent ( player, "ShowLoginWindow", getRootElement(), thename, true )
					else
						local clantag = gettok ( pname, 1, string.byte(']') )
						if testmode == true then
							triggerClientEvent ( player, "ShowRegisterGui", getRootElement() )
						else
							local serial = getPlayerSerial ( player )
							if string.upper ( clantag ) == "[VNX" then
								kickPlayer (player, "Du bist kein Mitglied des Clans!")
							elseif string.upper ( clantag ) == "[NOVA" or string.upper ( clantag ) == "[VIO" or string.upper ( clantag ) == "[EXO" or string.upper ( clantag ) == "[XTM" or string.upper ( clantag ) == "[GRS" or string.upper ( clantag ) == "[COA" or string.upper ( clantag ) == "[VITA" or string.upper ( clantag ) == "[UTM" or string.upper ( clantag ) == "[UL" then
								kickPlayer (player, "Dieses Clantag ist nicht erlaubt!")
							elseif #pname < 3 or #pname > 20 then
								kickPlayer ( player, "Bitte mindestens 3 und maximal 20 Zeichen als Nickname!" )
							elseif hasInvalidChar ( player ) or string.find ( pname, "'" ) then
								kickPlayer ( player, "Bitte nimm einen Nickname ohne ueberfluessige Zeichen!" )
							elseif string.lower (pname) == "niemand" or string.lower (pname) == "versteigerung" or string.lower (pname) == "none" then
								kickPlayer ( player, "Ungültiger Name!" )
							else
								triggerClientEvent ( player, "ShowRegisterGui", getRootElement() )
							end
						end
					end
				else
					kickPlayer ( player, "Bitte ändere deinen Nickname!" )
				end
			end
		else
			kickPlayer ( player, "Dein MTA verwendet einen ungültigen Serial. Bitte neu installieren!" )
		end
	end
end
addEvent ( "regcheck", true )
addEventHandler ("regcheck", getRootElement(), regcheck_func )

function register_func ( player, passwort, bday, bmon, byear, geschlecht,promocode)
			local player = client
			local pname = getPlayerName ( player )
			if MtxGetElementData ( player, "loggedin" ) == 0 and not isRegistered ( pname ) and player == client then
				setPlayerLoggedIn ( pname )
				
				toggleAllControls ( player, true )
				MtxSetElementData ( player, "loggedin", 1 )

				local ip = getPlayerIP ( player )
				
				local regtime = getRealTime()
				local year = regtime.year + 1900
				local month = regtime.month + 1
				local day = regtime.monthday
				local hour = regtime.hour
				local minute = regtime.minute
				
				
				local registerdatum = tostring(day.."."..month.."."..year..", "..hour..":"..minute)
				local lastlogin = registerdatum
				
				passwort = hash ( "sha512", passwort )
				local lastLoginInt = getSecTime ( 0 )
				
				local id = tonumber ( dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE id=id", "id", "idcounter" ), -1 )[1]["id"] )
				dbExec ( handler, "UPDATE ?? SET ?? = ?", "idcounter", "id", id+1 )
				
				local result = dbExec ( handler, "INSERT INTO players ( UID, Name, Serial, IP, Last_login, Geburtsdatum_Tag, Geburtsdatum_Monat, Geburtsdatum_Jahr, Passwort, Geschlecht, RegisterDatum, LastLogin) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", id, pname, getPlayerSerial(player), getPlayerIP ( player ), lastlogin, tonumber ( bday), tonumber ( bmon), tonumber ( byear), passwort, geschlecht, registerdatum, lastLoginInt )
				if not result then
					outputDebugString ( "[players] Fehler beim Ausführen der Abfrage")
				else
					triggerClientEvent ( player, "infobox_start", player, "Du hast dich\nerfolgreich registriert!\n\nDeine Daten werden\nnun gespeichert!", 7500, 0, 255, 0 )
					playerUID[pname] = id
					playerUIDName[id] = pname
				end
				
				local result = dbExec ( handler, "INSERT INTO achievments (UID) VALUES (?)", id )
				if not result then
					outputDebugString ( "[achievments] Fehler beim Ausführen der Abfrage")
				end
				
				local result = dbExec ( handler, "INSERT INTO inventar (UID) VALUES (?)", id )
				if not result then
					outputDebugString ( "[inventar] Fehler beim Ausführen der Abfrage")
				end
				
				local result = dbExec ( handler, "INSERT INTO packages (UID, Paket1, Paket2, Paket3, Paket4, Paket5, Paket6, Paket7, Paket8, Paket9, Paket10, Paket11, Paket12, Paket13, Paket14, Paket15, Paket16, Paket17, Paket18, Paket19, Paket20, Paket21, Paket22, Paket23, Paket24, Paket25) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", id,'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0' )
				if not result then
					outputDebugString ( "[packages] Fehler beim Ausführen der Abfrage")
				end
				
				local result = dbExec ( handler, "INSERT INTO bonustable (UID, Lungenvolumen, Muskeln, Kondition, Boxen, KungFu, Streetfighting, CurStyle, PistolenSkill, DeagleSkill, ShotgunSkill, AssaultSkill) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", id, 'none', 'none', 'none', 'none', 'none', 'none', '4', 'none', 'none', 'none', 'none' )
				if not result then
					outputDebugString ( "[bonustable] Fehler beim Ausführen der Abfrage")
				end
				
				local result = dbExec ( handler, "INSERT INTO statistics ( UID ) VALUES (?)", id )
				if not result then
					outputDebugString ( "[statistics] Fehler beim Ausführen der Abfrage")
				end
				
				local result = dbExec ( handler, "INSERT INTO skills ( UID ) VALUES (?)", id )
				if not result then
					outputDebugString ( "[skills] Fehler beim Ausführen der Abfrage")
				end
				
				local result = dbExec(handler,"INSERT INTO clothes (Name,shirt1,shirt2,hair1,hair2,hose1,hose2,schuhe1,schuhe2,Hut1,Hut2,Bandana1,Bandana2) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",pname,'none','none','none','none','none','none','none','none','none','none','none','none')
				if not result then
					outputDebugString ( "[clothes] Fehler beim Ausführen der Abfrage")
				end
				
				local result = dbExec(handler,"INSERT INTO promotion (Username,Promo0) VALUES ('"..pname.."','0')")
				if not result then
					outputDebugString ( "[promotion] Fehler beim Ausführen der Abfrage")
				end
				
				if geschlecht == nil then
					geschlecht = 1
				end
				
				MtxSetElementData ( player, "money", 1000 )
				MtxSetElementData ( player, "points", 0 )
				MtxSetElementData ( player, "packages", "0" )
				local Spawnpos_X = -1968.6300048828
				MtxSetElementData ( player, "spawnpos_x", Spawnpos_X )
				local Spawnpos_Y = 118.84481048584
				MtxSetElementData ( player, "spawnpos_y", Spawnpos_Y )
				local Spawnpos_Z = 27.6875
				MtxSetElementData ( player, "spawnpos_z", Spawnpos_Z )
				local Spawnrot_X = 0
				MtxSetElementData ( player, "spawnrot_x", Spawnrot_X )
				local SpawnInterior = 0
				MtxSetElementData ( player, "spawnint", SpawnInterior )
				local SpawnDimension = 0
				MtxSetElementData ( player, "spawndim", SpawnDimension )
				MtxSetElementData ( player, "fraktion", 0 )
				MtxSetElementData ( player, "rang", 0 )
				MtxSetElementData ( player, "adminlvl", 0 )
				MtxSetElementData ( player, "playingtime", 0 )
				MtxSetElementData ( player, "curcars", 0 )
				MtxSetElementData ( player, "maxcars", 5 )
				for i=1, 20 do
					MtxSetElementData ( player, "carslot"..i, 0 )
				end
				MtxSetElementData ( player, "deaths", 0 )
				MtxSetElementData ( player, "kills", 0 )
				setElementData ( player, "TacticKills", 0 )
				setElementData ( player, "TacticTode", 0 )
				MtxSetElementData ( player, "gangwarwins", 0 )
				MtxSetElementData ( player, "gangwarlosses", 0 )
				MtxSetElementData ( player, "jailtime", 0 )
				MtxSetElementData ( player, "prison", 0 )
				MtxSetElementData ( player, "bail", 0 )
				MtxSetElementData ( player, "heaventime", 0 )
				MtxSetElementData ( player, "housekey", 0 )
				MtxSetElementData ( player, "bizkey", 0 )
				MtxSetElementData ( player, "bankmoney", 7000 )
				MtxSetElementData ( player, "drugs", 0 )
				local Skinid = getRandomRegisterSkin ( player, geschlecht )
				MtxSetElementData ( player, "skinid", Skinid )
				MtxSetElementData ( player, "carlicense", 0 )
				MtxSetElementData ( player, "bikelicense", 0 )
				MtxSetElementData ( player, "lkwlicense", 0 )
				MtxSetElementData ( player, "helilicense", 0 )
				MtxSetElementData ( player, "planelicensea", 0 )
				MtxSetElementData ( player, "planelicenseb", 0 )
				MtxSetElementData ( player, "motorbootlicense", 0 )
				MtxSetElementData ( player, "segellicense", 0)
				MtxSetElementData ( player, "fishinglicense", 0)
				MtxSetElementData ( player, "wanteds", 0 )
				MtxSetElementData ( player, "stvo_punkte", 0 )
				MtxSetElementData ( player, "gunlicense", 0 )
				MtxSetElementData ( player, "perso", 0 )
				MtxSetElementData ( player, "boni", 1000 )
				MtxSetElementData ( player, "pdayincome", 0 )
				MtxSetElementData ( player, "hitglocke", 0 )
				MtxSetElementData ( player, "medikits", 0 )
				MtxSetElementData ( player, "repairkits", 0 )
				MtxSetElementData ( player, "busroute", 0 )
				MtxSetElementData ( player, "premium", false )
				MtxSetElementData ( player, "Paket", 0 )
				MtxSetElementData ( player, "PremiumData", 0 )
				MtxSetElementData ( player, "PremiumCars", 0 )
				MtxSetElementData ( player, "lastSocialChange", 0 )
				MtxSetElementData ( player, "lastNumberChange", 0 )
				MtxSetElementData ( player, "lastPremCarGive", 0 )
				local run = 1
				while true do
					if run >= 20 then
						break
					else
						run = run + 1
					end
					local tnr = math.random ( 1000, 9999999 )
					local result = dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=?", "Telefonnr", "userdata", "Telefonnr", tnr ), -1 )
					if not result or not result[1] then
						if tonumber ( tnr ) ~= 911 and tonumber ( tnr ) ~= 333 and tonumber ( tnr ) ~= 400 and tonumber (tnr ) ~= 666666 then
							Telefonnr = tnr
							break
						end
					end
				end
				if Telefonnr == nil then
					Telefonnr = math.random ( 1000, 9999999 )
				end
				MtxSetElementData ( player, "telenr", Telefonnr )
				MtxSetElementData ( player, "warns", 0 )
				MtxSetElementData ( player, "gunboxa", "0|0" )
				MtxSetElementData ( player, "gunboxb", "0|0" )
				MtxSetElementData ( player, "gunboxc", "0|0" )
				MtxSetElementData ( player, "job", "none" )
				MtxSetElementData ( player, "jobtime", 0 )
				MtxSetElementData ( player, "club", "none" )
				MtxSetElementData ( player, "bonuspoints", 100 )
				MtxSetElementData ( player, "truckerlvl", 0 )
				MtxSetElementData ( player, "airportlvl", 0 )
				MtxSetElementData ( player, "bauarbeiterLVL", 0 )
				MtxSetElementData ( player, "farmerLVL", 0 )
				MtxSetElementData ( player, "contract", 0 )
				MtxSetElementData ( player, "socialState", "Neu auf "..Tables.servername.."" )
				MtxSetElementData ( player, "streetCleanPoints", 0 )
				MtxSetElementData ( player, "handyType", 1 )
				MtxSetElementData ( player, "handyCosts", 0 )
				MtxSetElementData ( player, "married", 0)
				MtxSetElementData ( player, "marwith", "none")
				
				_G[pname.."paydaytime"] = setTimer ( playingtime, 60000, 0, player )
				
				MtxSetElementData ( player, "loggedin", 1 )
				MtxSetElementData ( player, "muted", 0 )
				MtxSetElementData ( player, "curplayingtime", 0 )
				MtxSetElementData ( player, "housex", 0 )
				MtxSetElementData ( player, "housey", 0 )
				MtxSetElementData ( player, "housez", 0 )
				MtxSetElementData ( player, "house", "none" )
				MtxSetElementData ( player, "handystate", "on" )
				MtxSetElementData ( player, "object", 0 )
				MtxSetElementData ( player, "ammoTyp", 0 )
				MtxSetElementData ( player, "curAmmoTyp", 0 )
				MtxSetElementData ( player, "nodmzone", 1 )
				MtxSetElementData ( player, "coins", 0 )
				MtxSetElementData ( player, "exp", 0 )
				MtxSetElementData ( player, "level", 0 )
				MtxSetElementData ( player, "Introtask", 1 )
				setElementData ( player,"inTactic",false)
				setElementData ( player, "hud", 1 )
				MtxSetElementData ( player, "Promo0" ,0 )
				MtxSetElementData ( player, "levelshop1", 0 )
				MtxSetElementData ( player, "levelshop2", 0 )
				MtxSetElementData ( player, "levelshop3", 0 )
				MtxSetElementData ( player, "levelshop4", 0 )
				MtxSetElementData ( player,"fahrschulonduty",false )
				MtxSetElementData ( player,"infahrpruefung",false )
				MtxSetElementData ( player,"inpruefung",false )
				MtxSetElementData ( player, "hatTheorieBestanden", false )
				
				if getElementData(player,"hud") then
					triggerClientEvent ( player, "showhudclient", player, "hud" )
				end

				bindKey ( source, "r", "down", reload )											
				setPlayerWantedLevel ( player, 0 )
				MtxSetElementData ( player, "call", false )
				
				packageLoad ( player )
				achievload ( player )
				inventoryload ( player )
				elementDataSettings ( player )
				bonusLoad ( player )
				skillDataLoad ( player )
				createPlayerAFK ( player )
				loadPlayerStatisticsMySQL ( player )
				if not allPrivateCars[pname] then
					allPrivateCars[pname] = {}
				end

				local result = dbExec ( handler, "INSERT INTO userdata ( UID,Name,Skinid,Telefonnr,hud,Introtask,levelshop1,levelshop2,levelshop3,levelshop4,TacticKills,TacticTode) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)", id, pname, Skinid, Telefonnr,"1","1","0","0","0","0","0","0")
				if not result then
					outputDebugString ( "[userdata] Fehler beim Ausführen der Abfrage")
				else
					outputDebugString ("Daten für Spieler "..pname.." wurden angelegt!")
				end
				outputChatBox ( "Drücke F1, um das Hilfemenü zu öffnen!", player, 200, 200, 0 )
				
				local codeToCheck = promocode or "" 
                if codeToCheck == "ICE2025" then
                    MtxSetElementData ( player, "money", MtxGetElementData ( player, "money" ) + 1500 )
                    MtxSetElementData ( player, "bonuspoints", MtxGetElementData ( player, "bonuspoints" ) + 1700 )
                    setPremiumData (player, 7, 5)
                    MtxSetElementData ( player,"Promo0", 1 ) 
                    dbExec(handler, "UPDATE promotion SET Promo0=? WHERE Username=?", 1, pname)
                    outputChatBox("[Starterpaket Code] : Sie haben den Promocode eingegeben und erhalten 1500€ und 1700 Bonuspunkte dazu gibt es noch eine Woche Premium :)", player, 0, 255, 0)
                elseif #codeToCheck > 0 then
                    outputChatBox("FEHLER: Der eingegebene Promocode ist unbekannt.", player, 255, 128, 0)
                end
						
				loadAddictionsForPlayer ( player )
				spawnchange_func (player,"","noobspawn","")
				triggerJoinedPlayerTheTrams ( player )
				syncInvulnerablePedsWithPlayer ( player )
				playerLoginGangMembers ( player )
				spawnPlayer ( player, Spawnpos_X, Spawnpos_Y, Spawnpos_Z, Spawnrot_X, Skinid, SpawnInterior, 0 )
				setCameraTarget ( player, player )
				setElementFrozen ( player, false )
				toggleAllControls ( player, true )
	end
end
addEvent ( "register", true )
addEventHandler ( "register", getRootElement(), register_func)

local maleSkins = {0,1, 2, 7, 14, 15, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 122, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170, 171, 176, 177, 179, 180, 182, 183, 184, 185, 187, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 249, 250, 252, 253, 255, 258, 259, 261, 262, 264, 269, 270, 271, 291, 302, 303, 306, 307, 310}
local femaleSkins = {9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 225, 226, 231, 232, 233, 238, 243, 244, 245, 246, 251, 256, 257, 263 }


function getRandomRegisterSkin ( player, sex )
	local testped = createPed ( 0, 9999, 9999, 9999 )
	if sex == 1 then
		local rnd = math.random ( 1, #femaleSkins )
		if setElementModel ( testped, femaleSkins[rnd] ) then
			destroyElement ( testped )
			return femaleSkins[rnd]
		else
			destroyElement ( testped )
			return getRandomRegisterSkin ( player, sex )
		end	
	else
		local rnd = math.random ( 1, #maleSkins )
		if setElementModel ( testped, maleSkins[rnd] ) then
			destroyElement ( testped )
			return maleSkins[rnd]
		else
			destroyElement ( testped )
			return getRandomRegisterSkin ( player, sex )
		end
	end
end


function login_func ( player, passwort )
	if player == client then
		if MtxGetElementData ( player, "loggedin" ) == 0 then
			local pname = getPlayerName ( player )
		    local passwort = passwort
			
			local pwresult = dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=?", "Passwort", "players", "UID", playerUID[pname] ), -1 )
			if pwresult and pwresult[1] then
				pwresult = pwresult[1]["Passwort"]	
				if pwresult == hash ( "sha512", passwort ) then	
									
					setPlayerLoggedIn ( pname )
				
					toggleAllControls ( player, true )

					MtxSetElementData ( player, "loggedin", 1 )
					MtxSetElementData ( player, "nodmzone", 0 )
				
					local logtime = getRealTime()
					local year = logtime.year + 1900
					local month = logtime.month + 1
					local day = logtime.monthday
					local hour = logtime.hour
					local minute = logtime.minute
					
					local lastLoginInt = getSecTime ( 0 )
					local lastlogin = tostring(day.."."..month.."."..year..", "..hour..":"..minute)
					
					local result = dbPoll ( dbQuery ( handler, "SELECT * from userdata WHERE UID = ?", playerUID[pname] ), -1 )
					if result then
						if result[1] then
							local dsatz = result[1]
							local money = tonumber ( dsatz["Geld"] )
							MtxSetElementData ( player, "money", money )
							local fraktion = tonumber ( dsatz["Fraktion"] )
							MtxSetElementData ( player, "fraktion", fraktion )
							if fraktion > 0 then
								fraktionMembers[fraktion][player] = fraktion
								bindKey ( player, "y", "down", "chatbox", "t" )
								local f_player = player 
								local f_fraktion = fraktion
								setTimer(function()
									if isElement(f_player) and MtxGetElementData(f_player, "loggedin") == 1 then
										if f_fraktion ~= 10 and f_fraktion ~= 11 then
											triggerClientEvent ( f_player, "syncPlayerList", f_player, fraktionMemberList[f_fraktion], fraktionMemberListInvite[f_fraktion] )
										else
											triggerClientEvent ( f_player, "syncPlayerList", f_player, fraktionMemberList[10], fraktionMemberListInvite[10] )
										end
									end
								end, 2000, 1)
							end
							MtxSetElementData ( player, "busroute", 0 )
							local rang = tonumber ( dsatz["FraktionsRang"] )
							MtxSetElementData ( player, "rang", rang )					
							local admnlvl = tonumber ( dsatz["Adminlevel"] )
							MtxSetElementData ( player, "adminlvl", admnlvl )
							if admnlvl >= 2 then
								adminsIngame[player] = admnlvl
							end
							if MtxGetElementData(player, "premium") == true then
								donatorMute[player] = {}
							end
							
							bindKey(player, "c", "down", Jump)
							bindKey(player, "lshift", "down", speedup)
							
							MtxSetElementData ( player, "lastSocialChange", tonumber ( dsatz["lastSocialChange"] ) )
							MtxSetElementData ( player, "lastNumberChange", tonumber ( dsatz["lastNumberChange"] ) )
							MtxSetElementData ( player, "lastPremCarGive", tonumber ( dsatz["lastPremCarGive"] ) )
							MtxSetElementData ( player, "PremiumCars", tonumber ( dsatz["PremiumCars"] ) )
							MtxSetElementData ( player, "spawnpos_x", tonumber ( dsatz["Spawnpos_X"] ) )
							MtxSetElementData ( player, "spawnpos_y", tonumber ( dsatz["Spawnpos_Y"] ) )
							MtxSetElementData ( player, "spawnpos_z", tonumber ( dsatz["Spawnpos_Z"] ) )
							MtxSetElementData ( player, "spawnrot_x", tonumber ( dsatz["Spawnrot_X"] ) )
							MtxSetElementData ( player, "spawnint", tonumber ( dsatz["SpawnInterior"] ) )
							MtxSetElementData ( player, "spawndim", tonumber ( dsatz["SpawnDimension"] ) )
							MtxSetElementData ( player, "playingtime", tonumber ( dsatz["Spielzeit"] ) )
							MtxSetElementData ( player, "curcars", tonumber ( dsatz["CurrentCars"] ) )
							local maximumcars = tonumber ( dsatz["MaximumCars"] )
							MtxSetElementData ( player, "maxcars",maximumcars  )
							local curcars = 0
							local offerOnCar = false
							local vehresult = dbPoll ( dbQuery ( handler, "SELECT ??, ?? FROM ?? WHERE ??=?", "Special", "Slot", "vehicles", "UID", playerUID[pname] ), -1 )
							for i=1, maximumcars do
								MtxSetElementData ( player, "carslot"..i, 0 )
							end
							if vehresult and vehresult[1] then
								for i = 1, #vehresult do
									local id = tonumber ( vehresult[i]["Slot"] )
									local carvalue = tonumber ( vehresult[i]["Special"] )
									if carvalue == 2 then
										MtxSetElementData ( player, "yachtImBesitz", true )
									end
									if not carvalue then
									
										carvalue = 0
									else
										if carvalue == 2 then
											carvalue = 2
										else
											carvalue = 1
										end
										curcars = curcars + 1
									end
									MtxSetElementData ( player, "carslot"..id, carvalue )
								end
							end
							MtxSetElementData ( player, "curcars", curcars )
							
							MtxSetElementData ( player, "deaths", tonumber ( dsatz["Tode"] ) )
							MtxSetElementData ( player, "kills", tonumber ( dsatz["Kills"] ) )
							setElementData ( player, "TacticKills", tonumber ( dsatz["TacticKills"] ) )
							setElementData ( player, "TacticTode", tonumber ( dsatz["TacticTode"] ) )
							MtxSetElementData ( player, "gangwarlosses", tonumber ( dsatz["GangwarVerloren"] ) )
							MtxSetElementData ( player, "gangwarwins", tonumber ( dsatz["GangwarGewonnen"] ) )
							MtxSetElementData ( player, "jailtime", tonumber ( dsatz["Knastzeit"] ) )
							MtxSetElementData ( player, "prison", tonumber ( dsatz["Prison"] ) )
							MtxSetElementData ( player, "bail", tonumber ( dsatz["Kaution"] )  )
							MtxSetElementData ( player, "heaventime", tonumber ( dsatz["Himmelszeit"] ) )
						    MtxSetElementData ( player, "Promo0",getPlayerData("promotion","Username",pname,"Promo0"))
							setElementData ( player, "hud", tonumber ( dsatz["hud"] ) )
							MtxSetElementData ( player, "exp", tonumber ( dsatz["exp"] ) )
							MtxSetElementData ( player, "level", tonumber ( dsatz["level"] ) )
							MtxSetElementData ( player, "Introtask", tonumber ( dsatz["Introtask"] ) )
							MtxSetElementData ( player, "levelshop1", tonumber ( dsatz["levelshop1"] ) )
							MtxSetElementData ( player, "levelshop2", tonumber ( dsatz["levelshop2"] ) )
							MtxSetElementData ( player, "levelshop3", tonumber ( dsatz["levelshop3"] ) )
							MtxSetElementData ( player, "levelshop4", tonumber ( dsatz["levelshop4"] ) )
							MtxSetElementData(player,"fahrschulonduty",false)
							MtxSetElementData(player,"infahrpruefung",false)
							MtxSetElementData(player,"inpruefung",false)

							local resulthouse = dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=?", "ID", "houses", "UID", playerUID[pname] ), -1 )
							local Hausschluessel = resulthouse[1] and resulthouse[1]["ID"] or false
							local key = tonumber ( dsatz["Hausschluessel"] )
							if Hausschluessel then
								MtxSetElementData ( player, "housekey", tonumber ( Hausschluessel ) )
							elseif key <= 0 then
								MtxSetElementData ( player, "housekey", key )
							else
								MtxSetElementData ( player, "housekey", 0 )
							end
							
							if getPedSkin(player) == 0 then
							
								SHIRT1=getPlayerData("clothes","Name",pname,"shirt1")
								SHIRT2=getPlayerData("clothes","Name",pname,"shirt2")
								
								if(SHIRT1 ~= "none" and SHIRT2 ~= "none")then
									addPedClothes(player,SHIRT1,SHIRT2,0)
								end

								HAIR1=getPlayerData("clothes","Name",pname,"hair1")
								HAIR2=getPlayerData("clothes","Name",pname,"hair2")
								
								if(HAIR1 ~= "none" and HAIR2 ~= "none" )then
									addPedClothes(player,HAIR1,HAIR2,1)
								end
								
								HOSE1=getPlayerData("clothes","Name",pname,"hose1")
								HOSE2=getPlayerData("clothes","Name",pname,"hose2")
								
								if(HOSE1 ~= "none" and HOSE2 ~= "none")then
									addPedClothes(player,HOSE1,HOSE2,2)
								end
								
								SCHUHE1=getPlayerData("clothes","Name",pname,"schuhe1")
								SCHUHE2=getPlayerData("clothes","Name",pname,"schuhe2")
								
								if(SCHUHE1 ~= "none" and SCHUHE2 ~= "none")then
									addPedClothes(player,SCHUHE1,SCHUHE2,3)
								end
								Hut1=getPlayerData("clothes","Name",pname,"Hut1")
								Hut2=getPlayerData("clothes","Name",pname,"Hut2")
								
								if(Hut1 ~= "none" and Hut2 ~= "none")then
									addPedClothes(player,Hut1,Hut2,16)
								end
								
								Bandana1=getPlayerData("clothes","Name",pname,"Bandana1")
								Bandana2=getPlayerData("clothes","Name",pname,"Bandana2")
								
								if(Bandana1 ~= "none" and Bandana2 ~= "none")then
										addPedClothes(player,Bandana1,Bandana2,15)
									end
								end	
								
							local query1=getPlayerData("marry", "pl1", pname, "pl1")
							local query2=getPlayerData("marry", "pl2", pname, "pl2")
							if query1 == pname then
								MtxSetElementData(player,"married",1)
								local partner=getPlayerData("marry", "pl2", pname, "pl2")
								local nachname=getPlayerData("marry", "pl1", pname, "nachname")
								MtxSetElementData(player,"marwith",partner)
								MtxSetElementData(player,"nachname",nachname)
							elseif query2 == pname then
								MtxSetElementData(player,"married",1)
								local partner=getPlayerData("marry", "pl1", pname, "pl1")
								local nachname=getPlayerData("marry", "pl2", pname, "nachname")
								MtxSetElementData(player, "marwith",partner)
								MtxSetElementData(player, "nachname",partner)
							else
								MtxSetElementData(player,"married",0)
								MtxSetElementData(player,"marwith","none")
								MtxSetElementData(player, "nachname","none")
							end
							
							-- Adminduty die beim einloggen auf false gesetzt werden
							if MtxGetElementData(player,"adminduty") == true then
								MtxSetElementData(player,"adminduty",false)
							end
							
				
							MtxSetElementData ( player, "hitglocke", tonumber ( dsatz["Hitglocke"] ) )
							MtxSetElementData ( player, "bizkey", tonumber ( dsatz["Bizschluessel"] ) )
							MtxSetElementData ( player, "bankmoney", tonumber ( dsatz["Bankgeld"] ) )
							MtxSetElementData ( player, "drugs", tonumber ( dsatz["Drogen"] ) )
							MtxSetElementData ( player, "skinid", tonumber ( dsatz["Skinid"] ) )
							MtxSetElementData ( player, "carlicense", tonumber ( dsatz["Autofuehrerschein"] ) )
							MtxSetElementData ( player, "bikelicense", tonumber ( dsatz["Motorradtfuehrerschein"] ) )
							MtxSetElementData ( player, "lkwlicense", tonumber ( dsatz["LKWfuehrerschein"] ) )
							MtxSetElementData ( player, "helilicense", tonumber ( dsatz["Helikopterfuehrerschein"] ) )
							MtxSetElementData ( player, "planelicensea", tonumber ( dsatz["FlugscheinKlasseA"] ) )
							MtxSetElementData ( player, "planelicenseb", tonumber ( dsatz["FlugscheinKlasseB"] ) )
							MtxSetElementData ( player, "motorbootlicense", tonumber ( dsatz["Motorbootschein"] ) )
							MtxSetElementData ( player, "segellicense", tonumber ( dsatz["Segelschein"] ) )
							MtxSetElementData ( player, "fishinglicense", tonumber ( dsatz["Angelschein"] ) )
							MtxSetElementData ( player, "wanteds", tonumber ( dsatz["Wanteds"] ) )
							MtxSetElementData ( player, "stvo_punkte", tonumber ( dsatz["StvoPunkte"] ) )
							MtxSetElementData ( player, "gunlicense", tonumber ( dsatz["Waffenschein"] ) )
							MtxSetElementData ( player, "perso", tonumber ( dsatz["Perso"] ) )
							MtxSetElementData ( player, "boni", tonumber ( dsatz["Boni"] ) )
							MtxSetElementData ( player, "pdayincome", tonumber ( dsatz["PdayIncome"] ) )
							MtxSetElementData ( player, "telenr", tonumber ( dsatz["Telefonnr"] ) )
							MtxSetElementData ( player, "warns", getPlayerWarnCount ( pname ) )
							MtxSetElementData ( player, "gunboxa", dsatz["Gunbox1"] )
							MtxSetElementData ( player, "gunboxb", dsatz["Gunbox2"] )
							MtxSetElementData ( player, "gunboxc", dsatz["Gunbox3"] )
							MtxSetElementData ( player, "job", dsatz["Job"] )
							MtxSetElementData ( player, "jobtime", dsatz["Jobtime"] )
							MtxSetElementData ( player, "club", dsatz["Club"] )
							MtxSetElementData ( player, "bonuspoints", tonumber ( dsatz["Bonuspunkte"] ) )
							MtxSetElementData ( player, "easterEggs", tonumber ( dsatz["eggs"] ) )
							local skill = tonumber ( dsatz["Truckerskill"] )
							if not skill then
								skill = 0
							end
							local ArmyPermissions = dsatz["ArmyPermissions"]
							for i = 1, 10 do
								MtxSetElementData ( player, "armyperm"..i, tonumber ( gettok ( ArmyPermissions, i, string.byte( '|' ) ) ) )
							end
							MtxSetElementData ( player, "truckerlvl", skill )
							MtxSetElementData ( player, "coins", tonumber ( dsatz["Coins"] ) )
							MtxSetElementData ( player, "airportlvl", tonumber ( dsatz["AirportLevel"] ) )
							MtxSetElementData ( player, "farmerLVL", tonumber ( dsatz["farmerLVL"] ) )
							MtxSetElementData ( player, "bauarbeiterLVL", tonumber ( dsatz["bauarbeiterLVL"] ) )
							MtxSetElementData ( player, "contract", tonumber ( dsatz["Contract"] ) )
							MtxSetElementData ( player, "Paket", tonumber ( dsatz["PremiumPaket"] ) )
							MtxSetElementData ( player, "PremiumData", tonumber ( dsatz["PremiumData"] ) )
							MtxSetElementData ( player, "socialState", dsatz["SocialState"] )
							if tonumber ( dsatz["SocialState"] ) then
								if tonumber ( dsatz["SocialState"] ) == 0 then
									MtxSetElementData ( player, "socialState", "Neu auf "..Tables.servername.."" )
								end
							end
							MtxSetElementData ( player, "streetCleanPoints", tonumber ( dsatz["StreetCleanPoints"] ) )
							
							local handyString = dsatz["Handy"] 
							local v1, v2
							v1 = tonumber ( gettok ( handyString, 1, string.byte ( '|' ) ) )
							v2 = tonumber ( gettok ( handyString, 2, string.byte ( '|' ) ) )
							MtxSetElementData ( player, "handyType", v1 )
							MtxSetElementData ( player, "handyCosts", v2 )
						

							loadAddictionsForPlayer ( player )
							
							
							MtxSetElementData ( player, "housex", 0 )
							MtxSetElementData ( player, "housey", 0 )
							MtxSetElementData ( player, "housez", 0 )
							MtxSetElementData ( player, "house", "none" )
							MtxSetElementData ( player, "curplayingtime", 0 )
							MtxSetElementData ( player, "handystate", "on" )
							MtxSetElementData ( player, "call", false )
							setElementData(player,"inTactic",false)
							
							packageLoad ( player )
							achievload ( player )
							inventoryload ( player )
							elementDataSettings ( player )
							bonusLoad ( player )
							skillDataLoad ( player )
							createPlayerAFK ( player )
							loadPlayerStatisticsMySQL ( player )
							setMaximumCarsForPlayer ( player )
							if not allPrivateCars[pname] then
								allPrivateCars[pname] = {}
							end
							
							_G[pname.."paydaytime"] = setTimer ( playingtime, 60000, 0, player )
					
							RemoteSpawnPlayer ( player )
							MtxSetElementData ( player, "muted", 0 )
							triggerClientEvent ( player, "DisableLoginWindow", getRootElement() )
							triggerClientEvent ( player, "infobox_start", getRootElement(), "Du hast dich\nerfolgreich eingeloggt!\nDrücke F1, um das\nHilfemenü zu\nöffnen!", 5000, 0, 255, 0 )
							outputDebugString ("Spieler "..pname.." wurde eingeloggt, IP: "..getPlayerIP(player))
							MtxSetElementData ( player, "loggedin", 1 )
							triggerJoinedPlayerTheTrams ( player )

							if MtxGetElementData ( player, "stvo_punkte" ) >= 15 then			-- SearchSTVO
								MtxSetElementData ( player, "carlicense", 0 )
								MtxSetElementData ( player, "stvo_punkte", 0 )
								dbExec ( handler, "UPDATE ?? SET ??=? WHERE ??=?", "userdata", "Autofuehrerschein", 0, "UID", playerUID[pname] )
								outputChatBox ( "Wegen deines schlechten Fahrverhaltens wurde dir dein Führerschein abgenommen!", player, 125, 0, 0 )
							end
							
							MtxSetElementData ( player, "object", tonumber ( dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=?", "Objekt", "inventar", "UID", playerUID[pname] ), -1 )[1]["Objekt"] ) )
							
							checkmsgs ( player )
							
							blacklistLogin ( pname )
							
							if MtxGetElementData(player,"Introtask") ~= 7 then
								outputChatBox("Folgen Sie dem Aufgabensystem, um Geschenke zu erhalten. Kaufen Sie keinen Artikel, bevor Sie das Aufgabensystem abgeschlossen haben!",player,255,255,255)
							end
							
							if isElement ( houses["pickup"][getPlayerName(player)] ) then
								local x, y, z = getElementPosition (houses["pickup"][getPlayerName(player)])
								createBlip ( x, y, z, 31, 2, 255, 0, 0, 255, 0, 99999, player )
							end
							
							local serial = getPlayerSerial ( player )
							
							dbExec ( handler, "UPDATE ?? SET ??=?, ??=?, ??=? WHERE ??=?", "players", "Last_login", lastlogin, "LastLogin", lastLoginInt, "Serial", serial, "UID", playerUID[pname] )
					
							local resultlogout = dbPoll ( dbQuery ( handler, "SELECT ??, ?? FROM ?? WHERE ??=?", "Position", "Waffen", "logout", "UID", playerUID[pname] ), -1 )
							if resultlogout and resultlogout[1] then
								local position = resultlogout[1]["Position"]
								if position then
									weapons = resultlogout[1]["Waffen"]
									dbExec ( handler, "DELETE FROM ?? WHERE ??=?", "logout", "UID", playerUID[pname] )
									for i = 1, 12 do
										local wstring = gettok ( weapons, i, string.byte( '|' ) )
										if wstring then
											if wstring then
												if #wstring >= 3 then
													local weapon = tonumber ( gettok ( wstring, 1, string.byte( ',' ) ) )
													local ammo = tonumber ( gettok ( wstring, 2, string.byte( ',' ) ) )
													giveWeapon ( player, weapon, ammo, true )
												end
											end
										end
									end
									if position ~= "false" then
										local x = tonumber ( gettok ( position, 1, string.byte( '|' ) ) )
										local y = tonumber ( gettok ( position, 2, string.byte( '|' ) ) )
										local z = tonumber ( gettok ( position, 3, string.byte( '|' ) ) )
										local int = tonumber ( gettok ( position, 4, string.byte( '|' ) ) )
										local dim = tonumber ( gettok ( position, 5, string.byte( '|' ) ) )
										setTimer ( setElementInterior, 1000, 1, player, int )
										setTimer ( setElementDimension, 1000, 1, player, dim )
										setTimer ( setElementPosition, 1000, 1, player, x, y, z )
									end
								end
							end
							getMailsForClient_func ( pname )
							playerLoginGangMembers ( player )
							syncInvulnerablePedsWithPlayer ( player )
							giveFreePremiumCar ( player )
							checkPremium ( player )	
						else
							triggerClientEvent ( player, "infobox_start", getRootElement(), "Der Spieler\nexistiert nicht!", 5000, 255, 0, 0 )	
						end
					else
						outputDebugString ( "Einloggen klappt nicht!" )
					end		
				else
					triggerClientEvent ( player, "infobox_start", getRootElement(), "Ungueltiges Passwort -\nüberpruefe\ndeine Eingabe\noder melde dich\nim Forum.", 5000, 255, 0, 0 )	
				end
			else
				triggerClientEvent ( player, "infobox_start", getRootElement(), "Der Spieler\nexistiert nicht!", 5000, 255, 0, 0 )	
			end
			if player and isElement ( player ) then
				bindKey ( player, "r", "down", reload )
			end
		else
			triggerClientEvent ( player, "infobox_start", getRootElement(), "Der Spieler\nist einloggt!", 5000, 255, 0, 0 )	
		end
    end
end
addEvent ( "einloggen", true )
addEventHandler ( "einloggen", getRootElement(), login_func )

function achievload ( player )

	local pname = getPlayerName ( player )
	local result = dbPoll ( dbQuery ( handler, "SELECT * from achievments WHERE UID = ?", playerUID[pname] ), -1 )
	local dsatz = nil
	if result then
		if result[1] then
			dsatz = result[1]
		else
			outputDebugString ( "Spieler in Achievment-Datenbank nicht gefunden!" )
			return false
		end
	end
	MtxSetElementData ( player, "schlaflosinsa", dsatz["SchlaflosInSA"] )
	MtxSetElementData ( player, "gunloads", dsatz["Waffenschieber"] )
	MtxSetElementData ( player, "angler_achiev", dsatz["Angler"] )
	MtxSetElementData ( player, "licenses_achiev", dsatz["Lizensen"] )
	MtxSetElementData ( player, "carwahn_achiev", dsatz["Fahrzeugwahn"] )
	MtxSetElementData ( player, "collectr_achiev", dsatz["DerSammler"] )
	MtxSetElementData ( player, "rl_achiev", dsatz["ReallifeWTF"] )
	MtxSetElementData ( player, "own_foots", dsatz["EigeneFuesse"] )
	MtxSetElementData ( player, "kingofthehill_achiev", dsatz["KingOfTheHill"] )
	MtxSetElementData ( player, "thetruthisoutthere_achiev", dsatz["TheTruthIsOutThere"] )
	MtxSetElementData ( player, "silentassasin_achiev", dsatz["SilentAssasin"] )
	MtxSetElementData ( player, "highwaytohell_achiev", dsatz["HighwayToHell"] )
	
	MtxSetElementData ( player, "revolverheld_achiev", tonumber ( dsatz["Revolverheld"] ) )
	MtxSetElementData ( player, "chickendinner_achiev", tonumber ( dsatz["ChickenDinner"] ) )
	MtxSetElementData ( player, "nichtsgehtmehr_achiev", tonumber ( dsatz["NichtGehtMehr"] ) )
	MtxSetElementData ( player, "highscore_achiev", tonumber ( dsatz["highscore"] ) == 1 )
	MtxSetElementData ( player, "TactickillCoin", tonumber ( dsatz["TactickillCoin"] ) == 1 )
	
	local dstring = dsatz["LookoutsA"]
	triggerClientEvent ( player, "hideLookoutMarkers", player, dstring )
	local count = 0
	for i = 1, 10 do
		if tonumber ( gettok ( dstring, i, string.byte ( '|' ) ) ) == 1 then
			count = count + 1
		end
	end
	MtxSetElementData ( player, "viewpoints", count )
	loadHorseShoesFound ( player, pname )
	loadPlayingTimeForSleeplessAchiev ( player, pname )
end


function inventoryload ( player )

	local pname = getPlayerName ( player )
	MtxSetElementData ( player, "playerid", playerUID[pname] )
	
	local dsatz
	local result = dbPoll ( dbQuery ( handler, "SELECT * from inventar WHERE UID = ?", playerUID[pname] ), -1 )
	if not result or not result[1] then
		dbExec ( handler, "INSERT INTO inventar (UID) VALUES (?)", playerUID[pname] )
		result = dbPoll ( dbQuery ( handler, "SELECT * from inventar WHERE UID = ?", playerUID[pname] ), -1 )
	end
	dsatz = result[1]
	if dsatz["Wuerfel"] then
		MtxSetElementData ( player, "dice", tonumber ( dsatz["Wuerfel"] ) )
	else
		MtxSetElementData ( player, "dice", 0 )
	end
	MtxSetElementData ( player, "flowerseeds", tonumber ( dsatz["Blumensamen"] ) )
	MtxSetElementData ( player, "food1", tonumber ( dsatz["Essensslot1"] ) )
	MtxSetElementData ( player, "food2", tonumber ( dsatz["Essensslot2"] ) )
	MtxSetElementData ( player, "food3", tonumber ( dsatz["Essensslot3"] ) )
	MtxSetElementData ( player, "zigaretten", tonumber ( dsatz["Zigaretten"] ) )
	MtxSetElementData ( player, "mats", tonumber ( dsatz["Materials"] ) )
	MtxSetElementData ( player, "benzinkannister", tonumber ( dsatz["Benzinkanister"] ) )
	MtxSetElementData ( player, "fruitNotebook", tonumber ( dsatz["FruitNotebook"] ) )
	MtxSetElementData ( player, "casinoChips", tonumber ( dsatz["Chips"] ) )
	MtxSetElementData ( player, "medikits", tonumber ( dsatz["Medikit"] ) )
	MtxSetElementData ( player, "repairkits", tonumber ( dsatz["Repairkit"] )	)
	MtxSetElementData ( player, "easterEggs", tonumber ( dsatz["eggs"] ) )
	-- X-MAS --
    MtxSetElementData ( player, "presents", tonumber ( dsatz["Geschenke"] ) )
	-- X-MAS --
end


	
function datasave (  quitReason, reason )

	if clanMembers[source] then
		clanMembers[source] = nil
	end
	if ticketPermitted[source] then
		ticketPermitted[source] = nil
	end
	local pname = getPlayerName ( source )
	removePlayerFromLoggedIn ( pname )
	if MtxGetElementData ( source, "loggedin" ) == 1 then
		playerDisconnectGangMembers ( source )
		pname = getPlayerName ( source )
		local frak = MtxGetElementData(source,"fraktion")
		if fraktionMembers[frak] then
			fraktionMembers[frak][source] = nil
		end
		adminsIngame[source] = nil
		if MtxGetElementData ( source, "shootingRanchGun" ) then
		elseif quitReason and reason ~= "Ausgeloggt." then
			if MtxGetElementData ( source, "wanteds" ) >= 1 and MtxGetElementData ( source, "jailtime" ) == 0 and MtxGetElementData ( source, "prison" ) == 0 then
				local x, y, z = getElementPosition ( source )
				local copShape = createColSphere ( x, y, z, 20 )
				local elementsInCopSphere = getElementsWithinColShape ( copShape, "player" )
				destroyElement ( copShape )
				for i=1, #elementsInCopSphere do
					local cPlayer = elementsInCopSphere[i]
					if ( isOnDuty ( cPlayer ) or isArmy ( cPlayer ) ) and cPlayer ~= source then
						local wanteds = MtxGetElementData ( source, "wanteds" )
						MtxSetElementData ( source, "wanteds", 0 )
						MtxSetElementData ( source, "jailtime", wanteds * math.ceil(jailtimeperwanted*1.4) + MtxGetElementData ( source, "jailtime" ) )
						wantedCost = 100*wanteds*(wanteds*.5)
						MtxSetElementData ( source, "money", MtxGetElementData ( source, "money" ) - wantedCost )
						if MtxGetElementData ( source, "money" ) < 0 then
							MtxSetElementData ( source, "money", 0 )
						end
						outputChatBox ( "Der Gesuchte "..getPlayerName ( source ).." ist offline gegangen - er wird beim nächsten Einloggen im Knast sein.", cPlayer, 0, 125, 0 )
						MtxSetElementData ( cPlayer, "AnzahlEingeknastet", MtxGetElementData ( cPlayer, "AnzahlEingeknastet" ) + 1 )
						MtxSetElementData ( source, "AnzahlImKnast", MtxGetElementData ( source, "AnzahlImKnast" ) + 1 )
						offlinemsg ( "Du bist für "..(wanteds * math.ceil(jailtimeperwanted*1.2)).." Minuten im Gefängnis (Offlineflucht?)", "Server", getPlayerName(source) )
						break
					end
				end
			end
			if shootingRanchGun[source] then
				takeWeapon ( source, shootingRanchGun[source] )
			end
			shootingRanchGun[source] = {}
			local curWeaponsForSave = "|"
			for i = 1, 12 do
				if i ~= 10 and i ~= 12 then
					local weapon = getPedWeapon ( source, i )
					local ammo = getPedTotalAmmo ( source, i )
					if weapon and ammo then
						if weapon > 0 and ammo > 0 then
							if #curWeaponsForSave <= 40 then
								curWeaponsForSave = curWeaponsForSave..weapon..","..ammo.."|"
							end
						end
					end
				end
			end
			if #curWeaponsForSave > 1 then
				dbExec ( handler, "DELETE FROM logout WHERE UID = ?", playerUID[pname] )
				dbExec ( handler, "INSERT INTO logout (Position, Waffen, UID) VALUES (?,?,?)", 'false', curWeaponsForSave, playerUID[pname]) 
			end
		end
		hangup ( source )
		datasave_remote ( source )
		if MtxGetElementData ( source, "isInArea51Mission" ) then
			removeArea51Bots ( pname )
		end
		local veh = getPedOccupiedVehicle ( source )
		if veh then
			if isElement ( veh ) then
				if getElementModel(veh) == 502 then
					destroyElement ( veh )
				end
			end
		end
		killTimer ( _G[pname.."paydaytime"] )
		clearDataSettings ( source )
	end
end
addEventHandler ("onPlayerQuit", getRootElement(), datasave )

function elementDataSettings ( player )

	local pname = getPlayerName ( player )
	MtxSetElementData ( player, "objectToPlace", false )
	MtxSetElementData ( player, "growing", false )
	MtxSetElementData ( player, "isInRace", false )
	MtxSetElementData ( player, "callswithpolice", false )
	MtxSetElementData ( player, "callswithmedic", false )
	MtxSetElementData ( player, "callswithmechaniker", false )
	MtxSetElementData ( player, "isLive", false )
	MtxSetElementData ( player, "isInArea51Mission", false )
	MtxSetElementData ( player, "armingBomb", false )
	MtxSetElementData ( player, "tied", true )
	MtxSetElementData ( player, "hasBomb", false )
	MtxSetElementData ( player, "wanzen", false )
	------------------
	
	local Weapon_Settings = dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=?", "Spezial", "inventar", "UID", playerUID[pname] ), -1 )
	local shads = {}
	
	if not Weapon_Settings or not Weapon_Settings[1] then
		for i = 1, 6 do
			shads[i] = 0
		end
	else
		for i = 1, 6 do
			shads[i] = tonumber ( gettok ( Weapon_Settings[1]["Spezial"], i, string.byte( '|' ) ) )
		end
	end
	
		
	----------------	
	local ArmyPermissions = dbPoll ( dbQuery ( handler, "SELECT ?? FROM ?? WHERE ??=?", "ArmyPermissions", "userdata", "UID", playerUID[pname] ), -1 )
	if ArmyPermissions and ArmyPermissions[1] then
		ArmyPermissions = ArmyPermissions[1]["ArmyPermissions"]
		for i = 1, 10 do
			local int = tonumber ( gettok ( ArmyPermissions, i, string.byte( '|' ) ) )
			if int then
				MtxSetElementData ( player, "armyperm"..i, int )
			else
				MtxSetElementData ( player, "armyperm"..i, 0 )
			end
		end
	else
		for i = 1, 10 do
			MtxSetElementData ( player, "armyperm"..i, 0 )
		end
	end
end

function saveArmyPermissions ( player )

	local pname = getPlayerName ( player )
	local empty = ""
	for i = 1, 10 do
		empty = empty.."|"..MtxGetElementData ( player, "armyperm"..i )
	end
	empty = empty.."|"
	dbExec ( handler, "UPDATE ?? SET ??=? WHERE ??=?", "userdata", "ArmyPermissions", empty, "UID", playerUID[pname] )
end


function SaveCarData ( player )

	local pname = getPlayerName ( player )
	dbExec ( handler, "UPDATE ?? SET ??=?, ??=?, ??=? WHERE ??=?", "userdata", "Geld", MtxGetElementData ( player, "money" ), "CurrentCars", MtxGetElementData ( player, "curcars" ), "MaximumCars", MtxGetElementData ( player, "maxcars" ), "UID", playerUID[pname] )
end

function datasave_remote ( player )
	
	local source = player
	if tonumber ( MtxGetElementData ( source, "loggedin" )) == 1 then
		local pname = getPlayerName ( source )	
		local fields = "SET"
		fields = fields.." Geld = '"..math.abs ( math.floor ( MtxGetElementData ( source, "money" ) ) ).."'"
		fields = fields..", Fraktion = '"..math.abs ( math.floor ( MtxGetElementData ( source, "fraktion") ) ).."'"
		fields = fields..", FraktionsRang = '"..math.floor ( MtxGetElementData ( source, "rang" ) ).."'"
		fields = fields..", Spielzeit = '"..math.floor ( MtxGetElementData ( source, "playingtime" ) ).."'"
		fields = fields..", Adminlevel = '"..math.floor ( MtxGetElementData ( source, "adminlvl" ) ).."'"
		fields = fields..", Hitglocke = '"..math.floor ( MtxGetElementData ( source, "hitglocke" ) ).."'"
		fields = fields..", CurrentCars = '"..math.floor ( MtxGetElementData ( source, "curcars" ) ).."'"
		fields = fields..", MaximumCars = '"..math.floor ( MtxGetElementData ( source, "maxcars" ) ).."'"
		fields = fields..", Knastzeit = '"..math.floor ( MtxGetElementData ( source, "jailtime" ) ).."'"
		fields = fields..", Prison = '"..math.floor ( MtxGetElementData ( source, "prison" ) ).."'"
		fields = fields..", Kaution = '"..math.floor ( MtxGetElementData ( source, "bail" ) ).."'"
		fields = fields..", Himmelszeit = '"..math.floor ( MtxGetElementData ( source, "heaventime" ) ).."'"
		fields = fields..", Hausschluessel = '"..math.floor ( MtxGetElementData ( source, "housekey" ) ).."'"
		fields = fields..", Bankgeld = '"..math.floor ( MtxGetElementData ( source, "bankmoney" ) ).."'"
		fields = fields..", Drogen = '"..math.floor ( MtxGetElementData ( source, "drugs" ) ).."'"
		fields = fields..", Skinid = '"..math.floor ( MtxGetElementData ( source, "skinid" ) ).."'"
		fields = fields..", Wanteds = '"..math.floor ( MtxGetElementData ( source, "wanteds" ) ).."'"
		fields = fields..", StvoPunkte = '"..math.floor ( MtxGetElementData ( source, "stvo_punkte" ) ).."'"
		fields = fields..", Boni = '"..math.floor ( MtxGetElementData ( source, "boni" ) ).."'"
		fields = fields..", PdayIncome = '"..math.floor ( MtxGetElementData ( source, "pdayincome" ) ).."'"
		fields = fields..", Warns = '"..math.floor ( MtxGetElementData ( source, "warns" ) ).."'"
		fields = fields..", Gunbox1 = '"..MtxGetElementData ( source, "gunboxa" ).."'"
		fields = fields..", Gunbox2 = '"..MtxGetElementData ( source, "gunboxb" ).."'"
		fields = fields..", Gunbox3 = '"..MtxGetElementData ( source, "gunboxc" ).."'"
		fields = fields..", Job = '"..MtxGetElementData ( source, "job" ).."'"
		fields = fields..", Jobtime = '"..math.floor ( MtxGetElementData ( source, "jobtime" ) ).."'"
		fields = fields..", Club = '"..MtxGetElementData ( source, "club" ).."'"
		fields = fields..", Bonuspunkte = '"..math.floor ( MtxGetElementData ( source, "bonuspoints" ) ).."'"
		local skill = tonumber ( MtxGetElementData ( source, "truckerlvl" ) ) or 0
		fields = fields.." ,Coins = '"..MtxGetElementData ( source, "coins" ).."'"
		fields = fields..", Truckerskill = '"..skill.."'"
		fields = fields..", farmerLVL = '"..MtxGetElementData ( source, "farmerLVL" ).."'"
		fields = fields..", bauarbeiterLVL = '"..MtxGetElementData ( source, "bauarbeiterLVL" ).."'"
		fields = fields..", AirportLevel = '"..math.floor ( MtxGetElementData ( source, "airportlvl" ) ).."'"
		fields = fields..", Contract = '"..math.floor ( MtxGetElementData ( source, "contract" ) ).."'"
		fields = fields..", SocialState = '".. MtxGetElementData ( source, "socialState") .."'"
		fields = fields..", StreetCleanPoints = '"..math.floor ( MtxGetElementData ( source, "streetCleanPoints" ) ).."'"
		fields = fields..", hud = '"..math.floor ( getElementData ( source, "hud" ) ).."'"
		fields = fields..", PremiumPaket = '"..MtxGetElementData ( source, "Paket" ).."'"
		fields = fields..", PremiumData = '"..MtxGetElementData ( source, "PremiumData" ).."'"
		fields = fields..", lastSocialChange = '"..MtxGetElementData ( source, "lastSocialChange" ).."'"
		fields = fields..", lastNumberChange = '"..MtxGetElementData ( source, "lastNumberChange" ).."'"
		fields = fields..", lastPremCarGive = '"..MtxGetElementData ( source, "lastPremCarGive" ).."'"
		fields = fields..", PremiumCars = '"..MtxGetElementData ( source, "PremiumCars" ).."'"
		fields = fields..", exp = '"..MtxGetElementData ( source, "exp" ).."'"
		fields = fields..", level = '"..MtxGetElementData ( source, "level" ).."'"
		fields = fields..", Introtask = '"..MtxGetElementData ( source, "Introtask" ).."'"
		fields = fields..", levelshop1 = '"..MtxGetElementData ( source, "levelshop1" ).."'"
		fields = fields..", levelshop2 = '"..MtxGetElementData ( source, "levelshop2" ).."'"
		fields = fields..", levelshop3 = '"..MtxGetElementData ( source, "levelshop3" ).."'"
		fields = fields..", levelshop4 = '"..MtxGetElementData ( source, "levelshop4" ).."'"
		fields = fields..", TacticKills = '"..getElementData ( source, "TacticKills" ).."'"
		fields = fields..", TacticTode = '"..getElementData ( source, "TacticTode" ).."'"
		local v1 = "|"..MtxGetElementData ( source, "handyType" ).."|"
		local v2 = MtxGetElementData ( source, "handyCosts" ).."|"
		local v3 = v1..v2
		fields = fields..", Handy = '"..v3.."'"
		dbExec ( handler, "UPDATE userdata "..fields.." WHERE UID=?", playerUID[pname] )
		
		saveAddictionsForPlayer ( source )
		achievsave(source)
		inventorysave(source)
		skillDataSave ( player )
		saveArmyPermissions ( player )
		saveStatisticsMySQL ( player )
		outputDebugString ("Daten für Spieler "..pname.." wurden gesichert!")
	end
end

function achievsave ( player )

	local pname = getPlayerName ( player )
	saveHorseShoesFound ( player, pname )
	dbExec ( handler, "UPDATE ?? SET ??=? WHERE ??=?", "achievments", "Waffenschieber", MtxGetElementData ( player, "gunloads"), "UID", playerUID[pname] )
	savePlayingTimeForSleeplessAchiev ( player, pname )
end



function inventorysave ( player )
	local pname = getPlayerName ( player )	
	dbExec ( handler, "UPDATE ?? SET ??=?, ??=?, ??=?, ??=?, ??=?, ??=?, ??=?, ??=?, ??=?, ??=?, ??=?, ??=? WHERE ??=?", "inventar", "Blumensamen", MtxGetElementData ( player, "flowerseeds" ), "Essensslot1", MtxGetElementData ( player, "food1" ), "Essensslot2", MtxGetElementData ( player, "food2" ), "Essensslot3", MtxGetElementData ( player, "food3" ), "Zigaretten", MtxGetElementData ( player, "zigaretten" ), "Materials", MtxGetElementData ( player, "mats" ), "Benzinkanister", MtxGetElementData ( player, "benzinkannister" ), "Objekt", MtxGetElementData ( player, "object" ), "Chips", MtxGetElementData ( player, "casinoChips" ), "Medikit", MtxGetElementData ( player, "medikits" ), "Repairkit", MtxGetElementData ( player, "repairkits" ), "eggs", MtxGetElementData ( player, "easterEggs" ), "UID", playerUID[pname] )
end

function casinoMoneySave ( player )

	if MtxGetElementData ( player, "loggedin" ) == 1 then
		local name = getPlayerName ( player )
		local chips = math.abs ( math.floor ( MtxGetElementData ( player, "casinoChips" ) ) )
		local money = math.floor ( MtxGetElementData ( player, "money" ) )
		local bankMoney = math.floor ( MtxGetElementData ( player, "bankmoney" ) )
		dbExec ( handler,"UPDATE userdata SET ??=?, ??=? WHERE UID=?", "Geld", money, "Bankgeld", bankMoney, playerUID[name] )
		dbExec ( handler, "UPDATE inventar SET Chips=? WHERE UID=?", chips, playerUID[name] )
	end
end



-- Info: Angabe von Last_Login in Tagen seit Jahresanfang, Angabe von Geschlecht in 1 u. 0 - 1 = Weiblich, 0 = männlich
-- Anreise in 1 u. 0, 0 = Schiff, 1 = Flugzeug
-- Scheine: 0 = nicht vorhanden, 1 = vorhanden

function logoutPlayer_func(player, x, y, z, int, dim)

    local client = player
    if MtxGetElementData(client, "shootingRanchGun") then
    else
        local pname = getPlayerName(client)
        local int = tonumber(int)
        local dim = tonumber(dim)
        local curWeaponsForSave = "|"
        if shootingRanchGun[client] then
            takeWeapon(client, shootingRanchGun[client])
        end
        for i = 1, 11 do
            if i ~= 10 then
                local weapon = getPedWeapon(client, i)
                local ammo = getPedTotalAmmo(client, i)
                if weapon and ammo then
                    if weapon > 0 and ammo > 0 then
                        if #curWeaponsForSave <= 40 then
                            curWeaponsForSave = curWeaponsForSave .. weapon .. "," .. ammo .. "|"
                        end
                    end
                end
            end
        end
        pos = "|" .. (math.floor(x * 100) / 100) .. "|" .. (math.floor(y * 100) / 100) .. "|" .. (math.floor(z * 100) / 100) .. "|" .. int .. "|" .. dim .. "|"
        if #curWeaponsForSave < 5 then
            curWeaponsForSave = ""
        end
        local result = dbExec(handler, "INSERT INTO logout (Position, Waffen, UID) VALUES (?,?,?)", pos, curWeaponsForSave, playerUID[pname])
        kickPlayer(client, "Ausgeloggt.")
    end
end
addEvent("logoutPlayer", true)
addEventHandler("logoutPlayer", getRootElement(), logoutPlayer_func)