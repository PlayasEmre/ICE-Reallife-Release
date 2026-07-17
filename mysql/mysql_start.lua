--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

gMysqlHost = "127.0.0.1" 
gMysqlUser = "root"  
gMysqlPass = ""
gMysqlDatabase = "reallife"
 
playerUID = {}
playerUIDName = {}

function MySQL_Startup ( ) 
	handler = dbConnect ( "mysql", "dbname=".. gMysqlDatabase .. ";host="..gMysqlHost..";port=3306", gMysqlUser, gMysqlPass )
	if not handler then
		outputDebugString("[MySQL_Startup] Abfrage konnte nicht ausgeführt werden: Verbindung zum MySQL-Server kann nicht hergestellt werden!",3)
		outputDebugString("[MySQL_Startup] Bitte fahren Sie den Server herunter und starten Sie den MySQL-Server!",3)
		getThisResource():stop()
		return
	end	
	local result = dbPoll ( dbQuery ( handler, "SELECT ??,?? FROM ??", "UID", "Name", "players" ), -1 )
	for i=1, #result do
		local id = tonumber ( result[i]["UID"] )
		local name = result[i]["Name"]
		playerUID[name] = id
		playerUIDName[id] = name
	end
	playerUIDName[0] = "none"
	playerUID["none"] = 0
end
MySQL_Startup()

function saveEverythingForScriptStop ( )
	saveDepotInDB()
	updateBizKasse()
end
addEventHandler ( "onResourceStop", resourceRoot, saveEverythingForScriptStop )

function dbExist(tablename, objekt)
	local result = dbQuery(handler,"SELECT * FROM "..tablename.." WHERE "..objekt)
	rows, numrows, err= dbPoll(result, -1)
	if rows[1] then
		return true
	else
		return false
	end
end

function getPlayerData(from,where,name,data)
	local sql = dbQuery(handler,"SELECT * FROM "..from.." WHERE "..where.." = '"..name.."'");
	if(sql)then
		local rows = dbPoll(sql,-1);
		for _,v in pairs(rows)do
			return v[data];
		end
	end
end


function dbExecAsync(target, query, ...)
    -- Debug-Ausgabe: Zeigt an, dass der Befehl an die DB geschickt wurde
    outputDebugString("Async DB Query gestartet: " .. query)
    
    local player = (type(target) == "userdata" and getElementType(target) == "player") and target or nil
    
    dbQuery(function(queryHandle, p)
        local result, numAffected = dbPoll(queryHandle, 0)
        
        if result then
            -- Erfolgsmeldung in der Konsole
            outputDebugString("Async DB erfolgreich ausgeführt. Zeilen betroffen: " .. tostring(numAffected))
        else
            -- Fehlermeldung, falls etwas nicht geklappt hat
            local err = "Unbekannter Fehler"
            if p then err = "Fehler bei Spieler: " .. getPlayerName(p) end
            outputDebugString("Async DB Fehler: " .. err)
        end
    end, {player}, handler, query, ...)
end


local whitelist = false

--//Whitelist Func
local function whitelists ( player )
	if MtxGetElementData ( player, "adminlvl" ) >= 11 then
		if whitelist == true then
			whitelist = false
			outputChatBox ("Die Whitelist wurde deaktiviert!",root,255,120,0)
		else
			whitelist = true
			outputChatBox ("Die Whitelist wurde aktiviert!",root,255,0,0)
		end
	end
end
addCommandHandler("wh",whitelists)

addEventHandler("onPlayerConnect",root,
function(ni,ip,uni,se,ver)
if (whitelist == true) then
		local result=dbPoll(dbQuery(handler,"SELECT * FROM ?? WHERE ??=?","whitelist","Serial",se),-1)
		if(result and result[1])then
			if(result[1]["Access"]~="Yes")then
				cancelEvent(true,"Du bist auf der Whitelist, jedoch ohne Zugriff!")
				return false
			end
		else
			cancelEvent(true,"Du stehst nicht auf der Whitelist! Teamspeak-IP: "..Tables.tsip.."")
			return false
		end
	end
end)



addCommandHandler("addwhitelist",
function(player,cmd,name,serial)
	if MtxGetElementData ( player, "adminlvl" ) >= 11 then
		if (name) and (serial) then
			dbExecAsync(handler,"INSERT INTO whitelist (Name,Serial) VALUES (?,?)",name,serial)
			outputChatBox("Hinzugefügt "..name.." "..serial.." zu whitelist",player,0,255,0)
		else
			outputChatBox("Der korrekte Befehl lautet: /addwhitelist Name Serial",player,255,0,0)
		end
	end
end)
