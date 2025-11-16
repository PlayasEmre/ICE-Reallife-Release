local REPO_USER = "PlayasEmre"
local REPO_NAME = "ICE-Reallife-Release"
local RES_NAME = "ICE"
local REPO_BRANCH = "main"

local UPDATE_CFG_FILE = "update.cfg"
local DEBUG_TAG = "["..RES_NAME.."]"

-- Überprüft, ob der Spieler das Admin-Level 9 oder höher hat.
function isAdmin(player)
	if player and getElementType(player) == "player" then
		local adminLevel = tonumber(getElementData(player, "adminlvl")) or 0
		return adminLevel >= 9
	end
	return false
end

-- Hilfsfunktion: Sendet eine Nachricht nur an Spieler mit adminlvl >= 9
local function outputChatBoxToAdmins(message, r, g, b)
	local players = getElementsByType("player")
	for _, player in ipairs(players) do
		if isAdmin(player) then
			outputChatBox(message, player, r, g, b)
		end
	end
    -- Sende die Nachricht zusätzlich zur Konsole/Server-Log
    outputDebugString(message)
end

local function normalize_path(p)
  if not p then return p end
  p = tostring(p):gsub("\\", "/"):gsub("^/+", "")
  return p
end

local check = fileExists(UPDATE_CFG_FILE) and fileOpen(UPDATE_CFG_FILE) or fileCreate(UPDATE_CFG_FILE)
local version = tonumber(fileRead(check,fileGetSize(check))) or 0
fileClose(check)
setElementData(resourceRoot, "Version", version)

local updateSystemDisabled = false
if updateSystemDisabled then return end

local _fetchRemote = fetchRemote
function fetchRemote(...)
	return _fetchRemote(...)
end

RemoteVersion = 0
ManualUpdate = false
updateTimer = false
updatePeriodTimer = false
local updateCheckNoticeInterval = 30
local updateCheckInterval = 6


function checkUpdate()
	outputDebugString(DEBUG_TAG.."Verbinde mit GitHub...")
	local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..UPDATE_CFG_FILE
	outputDebugString(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url)
	
	fetchRemote(url, function(data, err)
		if err == 0 then
			RemoteVersion = tonumber(data)
			if not RemoteVersion then
				outputChatBoxToAdmins(DEBUG_TAG.."FEHLER: Remote-Version ist keine Zahl. update.cfg Format prüfen! Remote-Daten: '"..tostring(data).."'", 255, 0, 0)
				return
			end
			
			if not ManualUpdate then
				if RemoteVersion > version then
					if isTimer(updateTimer) then killTimer(updateTimer) end
					updateTimer = setTimer(function()
						if RemoteVersion > version then
							outputChatBoxToAdmins(DEBUG_TAG.."Remote Version erhalten [Remote:" .. data .. " Aktuell:" .. version .. "].", 255, 255, 0)
							outputChatBoxToAdmins(DEBUG_TAG.." [WICHTIG] Ein Update ("..RemoteVersion..") ist verfügbar! Befehl: /update "..RES_NAME, 255, 50, 50)
						else
							killTimer(updateTimer)
						end
					end, updateCheckNoticeInterval * 60000, 0)
				else
					outputChatBox(DEBUG_TAG.." [Info] Die Ressource ist aktuell (Version: "..version..").", root, 50, 255, 50) 
				end
			else
				startUpdate()
			end
		else
			outputChatBoxToAdmins(DEBUG_TAG.."SCHWERWIEGENDER FEHLER BEI DER VERSIONSÜBERPRÜFUNG! URL: "..url, 255, 0, 0)
			local errorString = "Unbekannter Fehler"
			if err == 2 then errorString = "Netzwerk-Timeout / Verbindung blockiert (Firewall?)" end
			if err == 404 then errorString = "Datei nicht gefunden (URL / Branch ist falsch)" end
			if err == -1 then errorString = "ACL-Zugriff verweigert (Benötigt function.fetchRemote)" end
			
			outputChatBoxToAdmins(DEBUG_TAG.."Kann Remote-Version nicht abrufen (FEHLER: "..err.." / "..errorString..")", 255, 0, 0)
		end
	end)
end

local updateCheckAuto = true 
if updateCheckAuto then
	checkUpdate() 
	updatePeriodTimer = setTimer(checkUpdate, updateCheckInterval * 3600000, 0)
end

addCommandHandler("update", function(player, cmd, targetResourceName)
	if targetResourceName ~= RES_NAME then
		if not targetResourceName then
			outputChatBox("Nutzung: /update "..RES_NAME, player, 255, 255, 0)
		end
		return
	end
	
	local isPermit = isAdmin(player)

	if isPermit then
		outputChatBoxToAdmins(DEBUG_TAG..getPlayerName(player) .. " versucht, "..RES_NAME.." zu aktualisieren (Erlaubt)", 100, 100, 255)
		outputChatBoxToAdmins(DEBUG_TAG.."Vorbereitung zur Aktualisierung von "..RES_NAME, 100, 100, 255)
		if RemoteVersion > version then
			startUpdate()
		else
			ManualUpdate = true
			checkUpdate()
		end
	else
		outputChatBox(DEBUG_TAG.."Zugriff verweigert!", player, 255, 0, 0)
		outputChatBoxToAdmins(DEBUG_TAG..getPlayerName(player) .. " versucht, "..RES_NAME.." zu aktualisieren (Verweigert)!", 255, 0, 0)
	end
end)

function startUpdate()
	ManualUpdate = false
	setTimer(function()
		outputChatBoxToAdmins(DEBUG_TAG.."Fordere Update-Daten von GitHub an...", 150, 150, 150)
		local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/meta.xml"
		outputChatBoxToAdmins(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url, 150, 150, 150)
		
		fetchRemote(url, function(data, err)
			if err == 0 then
				outputChatBoxToAdmins(DEBUG_TAG.."Update-Daten erhalten", 50, 255, 50)
				if fileExists("updated/meta.xml") then
					fileDelete("updated/meta.xml")
				end
				local meta = fileCreate("updated/meta.xml")
				fileWrite(meta, data)
				fileClose(meta)
				outputChatBoxToAdmins(DEBUG_TAG.."Fordere Verifikationsdaten an...", 150, 150, 150)
				getGitHubTree()
			else
				local errorString = "Unbekannter Fehler"
				if err == 2 then errorString = "Netzwerk-Timeout / Verbindung blockiert (Firewall?)" end
				if err == 404 then errorString = "Datei nicht gefunden (meta.xml fehlt)" end
				if err == -1 then errorString = "ACL-Zugriff verweigert (Benötigt function.fetchRemote)" end
				
				outputChatBoxToAdmins(DEBUG_TAG.."Kann Remote-Update-Daten nicht abrufen (FEHLER: "..err.." / "..errorString..")", 255, 0, 0)
			end
		end)
	end, 50, 1)
end

preUpdate = {}
fileHash = {}
UpdateCount = 0
folderGetting = {}
function getGitHubTree(path, nextPath)
	nextPath = nextPath or ""
	
	local url = path or "https://api.github.com/repos/"..REPO_USER.."/"..REPO_NAME.."/git/trees/"..REPO_BRANCH.."?recursive=1"
	outputChatBoxToAdmins(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url, 150, 150, 150)
	
	fetchRemote(url, function(data, err)
		if err == 0 then
			local theTable = fromJSON(data)
			if not theTable or not theTable.tree then
				outputChatBoxToAdmins(DEBUG_TAG.."Fehler beim Parsen der GitHub API Antwort. Antwort ungültig oder leer.", 255, 0, 0)
				return
			end
			
			for k, v in pairs(theTable.tree) do
				local thePath = normalize_path(nextPath..v.path)
				
				if v.mode == "040000" then
				elseif v.type == "blob" then
					if v.path ~= UPDATE_CFG_FILE and v.path ~= "meta.xml" then
						fileHash[thePath] = v.sha
					end
				end
			end
			checkFiles()
			
		else
			local errorString = "Unbekannter Fehler"
			if err == 2 then errorString = "Netzwerk-Timeout / Verbindung blockiert (Firewall?)" end
			if err == 404 then errorString = "Repo/Branch nicht gefunden (API)" end
			if err == -1 then errorString = "ACL-Zugriff verweigert (Benötigt function.fetchRemote)" end
			
			outputChatBoxToAdmins(DEBUG_TAG.."Fehler beim Abrufen der Verifikationsdaten (FEHLER: "..err.." / "..errorString..")!", 255, 0, 0)
		end
	end)
end

function checkFiles()
	local xml = xmlLoadFile("updated/meta.xml")
	if not xml then
		outputChatBoxToAdmins(DEBUG_TAG.."SCHWERWIEGEND: meta.xml konnte zur Dateiüberprüfung nicht geladen werden.", 255, 0, 0)
		return
	end

	for k, v in pairs(xmlNodeGetChildren(xml)) do
		if xmlNodeGetName(v) == "script" or xmlNodeGetName(v) == "file" then
			local path = xmlNodeGetAttribute(v, "src")
			
			local correctedPath = normalize_path(path)
			
			if correctedPath ~= "meta.xml" then
				local sha = ""
				local file = fileOpen(path) -- Datei öffnen
				if file then -- Prüfen, ob Öffnen erfolgreich war
					local size = fileGetSize(file)
					local text = fileRead(file, size)
					fileClose(file) -- Datei schließen
					
					if text then
						sha = hash("sha1", "blob " .. size .. "\0" .. text)
					end
				end
				
				if sha ~= fileHash[correctedPath] then 
					outputChatBoxToAdmins(DEBUG_TAG.."Update erforderlich: (" .. path .. ")", 255, 255, 0)
					table.insert(preUpdate, path)
				end
			end
		end
	end
	DownloadFiles()
end

function DownloadFiles()
	UpdateCount = UpdateCount + 1
	if not preUpdate[UpdateCount] then
		DownloadFinish()
		return
	end
	
	local currentPath = preUpdate[UpdateCount]
	
	local urlPath = normalize_path(currentPath)
	
	outputChatBoxToAdmins(DEBUG_TAG.."Fordere an (" .. UpdateCount .. "/" .. (#preUpdate or "Unbekannt") .. "): " .. tostring(currentPath) .. "", 150, 150, 150)
	
	local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..urlPath
	outputChatBoxToAdmins(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url, 150, 150, 150)
	
	fetchRemote(url, function(data, err, path)
		if err == 0 then
			local size = 0
			local file = fileOpen(path)
			
			if file then
				size = fileGetSize(file)
				fileClose(file)
				fileDelete(path)
			end
			
			local folderPath = string.match(path, "^(.-)/[^/]+$")
			if folderPath and not fileExists(folderPath) then createDirectory(folderPath) end
			
			local file = fileCreate(path)
			fileWrite(file, data)
			
			local newsize = fileGetSize(file)
			fileClose(file)
			
			outputChatBoxToAdmins(DEBUG_TAG.."Datei erhalten (" .. UpdateCount .. "/" .. #preUpdate .. "): " .. path .. " [ " .. size .. "B -> " .. newsize .. "B ]", 50, 255, 50)
		else
			local errorString = "Unbekannter Fehler"
			if err == 2 then errorString = "Netzwerk-Timeout / Verbindung blockiert (Firewall?)" end
			if err == 404 then errorString = "Datei nicht gefunden (URL / Branch ist falsch)" end
			if err == -1 then errorString = "ACL Access Denied (Need function.fetchRemote)" end
			
			outputChatBoxToAdmins(DEBUG_TAG.."Download fehlgeschlagen: "..tostring(path or urlPath).." (FEHLER: "..err.." / "..errorString..")!", 255, 0, 0)
		end
		
		if preUpdate[UpdateCount+1] then
			DownloadFiles()
		else
			DownloadFinish()
		end
	end, "", false, currentPath)
end

function DownloadFinish()
	outputChatBoxToAdmins(DEBUG_TAG.."Ändere Konfigurationsdatei", 150, 150, 150)
	if fileExists(UPDATE_CFG_FILE) then
		fileDelete(UPDATE_CFG_FILE)
	end
	local file = fileCreate(UPDATE_CFG_FILE)
	fileWrite(file, tostring(RemoteVersion))
	fileClose(file)
	
	if fileExists("meta.xml") then
		fileDelete("meta.xml")
	end
    if fileExists("updated/meta.xml") then
	    fileRename("updated/meta.xml", "meta.xml")
	    fileDelete("updated/meta.xml")
    end
	
	outputChatBoxToAdmins(DEBUG_TAG.."Update abgeschlossen ( "..#preUpdate.." Dateien geändert )", 50, 255, 50)
	outputChatBoxToAdmins(DEBUG_TAG.."Bitte Ressource neu starten: "..RES_NAME, 50, 255, 50)
	
	preUpdate = {}
	UpdateCount = 0
	
    setTimer(function()
        outputChatBoxToAdmins(DEBUG_TAG.."Starte Ressource nach Verzögerung der Versionsspeicherung neu.", 150, 150, 150)
        restartResource(getThisResource())
    end, 100, 1)
end

addCommandHandler(RES_NAME.."ver", function(pla, cmd)
	local vsdd
	if fileExists(UPDATE_CFG_FILE) then
		local file = fileOpen(UPDATE_CFG_FILE)
		local vscd = fileRead(file, fileGetSize(file))
		fileClose(file)
		vsdd = tonumber(vscd)
		if vsdd then
			outputChatBox(DEBUG_TAG.."Version: " .. vsdd, root, 255, 255, 255)
		else
			outputChatBox(DEBUG_TAG.."Versionsstatus ist beschädigt! Bitte /update "..RES_NAME.." zum Aktualisieren verwenden", root, 255, 0, 0)
		end
	end	
end)