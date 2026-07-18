--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local marryinprogress = false

local kircheraus = createMarker( 1277.099, 1301.599, 453.2, "corona", 1.2, 255, 255, 255, 120 )
setElementInterior(kircheraus, 66)
local markerin = createMarker( -1989.04, 1117.92, 54.2, "corona", 1.2, 255, 255, 255, 120 )
local info = createPickup ( -1987.975, 1120.550, 54.12, 3, 1239, 1, 0 )

local xa, ya, za = 1271.948, 1297.240, 453

function inDieKirche(player)
	if marryinprogress == true then
		outputChatBox("Man kommt nicht zu Spät zu einer Hochzeit!", player, 255, 0, 0)
	else
	if getElementType ( player ) == "player" and getPedOccupiedVehicle ( player ) == false then
			setElementPosition(player, 1275.361, 1301.411, 453.084)
			setElementInterior(player, 66)
		end
	end
end
addEventHandler("onMarkerHit", markerin, inDieKirche)

function ausDieKirche(player)
	setElementInterior(player, 0)
	setElementPosition(player, -1986.466, 1117.362, 53.857)
	if marryinprogress == true then
		outputChatBox("Pff.. Die Hochzeit ist ja noch garnicht zu ende, eine Frechheit!", player, 255, 0, 0)
	end
end
addEventHandler("onMarkerHit", kircheraus, ausDieKirche)

function KirchePickup(player)
	outputChatBox("Um in der Kirche einen anderen Spieler zu Heiraten wende dich per /report an einen Admin oder einem Reporter.", player, 255, 155, 0)
	outputChatBox("Kosten einer Heirat: 50.000$", player, 255, 155, 0)
	outputChatBox("Vorteile: Spawn Haus des Partners, Sozialer Status, Steuern niedriger, Ring unter Name und mehr...", player, 255, 155, 0)
end
addEventHandler("onPickupHit", info, KirchePickup)

function marry_func ( player, cmd, pl1, pl2, nachname )
	if MtxGetElementData(player, "adminlvl") >= 2 then
	if pl1 and pl2 then
		local pl1 = getPlayerFromName ( pl1 )
		local pl2 = getPlayerFromName ( pl2 )
		if pl1 and pl2 and nachname then
			local x, y, z = getElementPosition ( player )
			local x1, y1, z1 = getElementPosition ( pl1 )
			local x2, y2, z2 = getElementPosition ( pl2 )
			if getDistanceBetweenPoints3D ( xa, ya, za, x, y, z ) <= 10 and getDistanceBetweenPoints3D ( xa, ya, za, x1, y1, z1 ) <= 10 and getDistanceBetweenPoints3D ( xa, ya, za, x2, y2, z2 ) <= 10 then
				if MtxGetElementData ( pl1, "playingtime" ) >= 59 and MtxGetElementData ( pl2, "playingtime" ) >= 59 then
					if MtxGetElementData ( pl1, "married" ) == 0 and MtxGetElementData ( pl2, "married" ) == 0 then
						if pl1 == pl2 or pl1 == player or pl2 == player then
							outputChatBox("Der Braeutigam / die Braut und du muessen 3 verschiedene Spieler sein!.", player, 255, 150, 0)
						else
							dbExec(handler,"INSERT INTO marry (pl1,pl2,nachname) VALUES ('"..getPlayerName(pl1).."', '"..getPlayerName(pl2).."', '"..nachname.."')")
							outputChatBox(""..getPlayerName(pl1).." und "..getPlayerName(pl2).." wurden erfolgreich Verheiratet!", player, 255, 150, 0)
							giveWeapon ( pl1, 14, 1 )
							giveWeapon ( pl2, 14, 1 )
							MtxSetElementData(pl1, "married", 1)
							MtxSetElementData(pl1, "marwith", getPlayerName(pl2))
							MtxSetElementData(pl2, "married", 1)
							MtxSetElementData(pl2, "marwith", getPlayerName(pl1))
							MtxSetElementData(pl2, "nachname", nachname)
							MtxSetElementData(pl1, "nachname", nachname)
						end
					else
						outputChatBox("Der Braeutigam / die Braut sind bereits verheiratet! Tzz... Solche Heiratsschwindler...", player, 255, 150, 0)
					end
				else
					outputChatBox("Der Braeutigam / die Braut müssen min. 1 Spielstunde haben.", player, 255, 150, 0)
				end
			else
				outputChatBox("Ihr seit nicht bei der Kirche.", player, 255, 150, 0)
			end
		else
			outputChatBox("Verwende /marry Spieler1 Spieler2 Nachname | Der Nachname darf keine Leerzeichen enthalten!", player, 255, 150, 0)
		end
	end
	else
		outputChatBox("Du bist kein Moderator!", player, 200, 0, 0)
	end
end
addCommandHandler ( "marry", marry_func )

function lockkirche(player)
	if MtxGetElementData(player, "adminlvl") >= 4 then
		if marryinprogress == true then
			marryinprogress = false
			outputChatBox("Kirche unlocked", player)
		else
			marryinprogress = true
			outputChatBox("Kirche locked", player)
		end
	else
		outputChatBox("Du bist kein Moderator!", player, 200, 0, 0)
	end
end
addCommandHandler("lockkirche", lockkirche)

function unmarry_func ( player, cmd, pl )
	if MtxGetElementData(player, "adminlvl") >= 2 then
		local pl = getPlayerFromName ( pl )
		if pl then
			if MtxGetElementData(pl, "married") == 1 then
				local partner = MtxGetElementData(pl, "marwith")
				outputChatBox("Moechtest du dich von "..partner.." Scheiden? Wenn ja Tippe /acceptunmarry", pl, 255, 150, 0)
				MtxSetElementData(pl, "unmarry", 1)
				outputChatBox("Der Spieler muss die Scheidung nun bestaetigen.", player, 255, 150, 0)
			else
				outputChatBox("Der Spieler ist nicht verheiratet!", player, 255, 150, 0)
			end
		else
			outputChatBox("Verwende /unmarry Spieler", player, 255, 150, 0)
		end
	else
		outputChatBox("Du bist kein Moderator.", player, 200, 0, 0)
	end
end
addCommandHandler ( "unmarry", unmarry_func )

function acceptunmarry_func ( player )
	if MtxGetElementData(player, "unmarry") == 1 then
		local pname = getPlayerName(player)
		local partner = MtxGetElementData(player, "marwith")
		local query1 = getPlayerData("marry", "pl1", pname, "pl1")
		local query2 = getPlayerData("marry", "pl2", pname, "pl2")
			if query1 == pname then
				outputChatBox("Du hast dich erfolgreich von "..partner.." getrennt!", player, 255, 150, 0)
				dbExec(handler,"DELETE FROM marry WHERE pl1='"..pname.."'")
				MtxSetElementData(player, "unmarry", 0)
				MtxSetElementData(player, "married", 0)
				MtxSetElementData(player, "marwith", "none")
				
				if getPlayerFromName(partner) then
					outputChatBox(""..getPlayerName(player).." hat sich von dir Scheiden Lassen.", getPlayerFromName(partner), 255, 150, 0)
					MtxSetElementData(getPlayerFromName(partner), "married", 0)
					MtxSetElementData(getPlayerFromName(partner), "marwith", "none")
				else
					offlinemsg ( ""..getPlayerName(player).." hat sich von dir Scheiden Lassen.", "Standesamt", partner )
				end
			elseif query2 == pname then
				outputChatBox("Du hast dich erfolgreich von "..partner.." getrennt!", player, 255, 150, 0)
				dbExec (handler,"DELETE FROM marry WHERE pl2='"..pname.."'" )
				MtxSetElementData(player, "unmarry", 0)
				MtxSetElementData(player, "married", 0)
				MtxSetElementData(player, "marwith", "none")
				
				if getPlayerFromName(partner) then
					outputChatBox(""..getPlayerName(player).." hat sich von dir Scheiden Lassen.", getPlayerFromName(partner), 255, 150, 0)
					MtxSetElementData(getPlayerFromName(partner), "married", 0)
					MtxSetElementData(getPlayerFromName(partner), "marwith", "none")
				else
					offlinemsg ( ""..getPlayerName(player).." hat sich von dir Scheiden Lassen.", "Standesamt", partner )
				end
			end
	else
		outputChatBox("Du hast keinen Scheidungsantrag.", player, 255, 155, 0)
	end
end
addCommandHandler ( "acceptunmarry", acceptunmarry_func )