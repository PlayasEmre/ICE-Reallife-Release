-- Passt den DGS-Updater an, um IHR_SKRIPT_NAME von IHR_REPO_USER/IHR_REPO_NAME zu aktualisieren.

-- *** BITTE DIESE PLATZHALTER ANPASSEN! ***
local REPO_USER = "PlayasEmre"       -- Ihr GitHub-Benutzername
local REPO_NAME = "ICE-Reallife-Release"       -- Der Name Ihres Repositories auf GitHub
local RES_NAME = "ICE"       -- Der Name Ihrer Ressource
local REPO_BRANCH = "main"             -- Normalerweise "main" oder "master"
-- *******************************************

local UPDATE_CFG_FILE = "update.cfg"
local DEBUG_TAG = "["..RES_NAME.."]"

<<<<<<< HEAD
-- Funktion zur Normalisierung von Pfaden (ersetzt Backslashes durch Forwardslashes)
local function normalize_path(p)
  if not p then return p end
  -- Backslashes (\) werden durch Forwardslashes (/) ersetzt.
  -- Führende Slashes werden entfernt, um doppelte Slashes in der URL zu vermeiden.
  p = tostring(p):gsub("\\", "/"):gsub("^/+", "")
  return p
=======
-- Pfad-Normalisierung: Backslashes -> forward slashes, entferne führende Slashes
local function normalize_path(p)
    if not p then return p end
    return tostring(p):gsub("\\", "/"):gsub("^/+", "")
>>>>>>> b51a20aa5280ab83a8612b0b9e8c2f30978d9cb9
end

-- Lokale Versionsnummer aus der update.cfg lesen
local check = fileExists(UPDATE_CFG_FILE) and fileOpen(UPDATE_CFG_FILE) or fileCreate(UPDATE_CFG_FILE)
local version = tonumber(fileRead(check,fileGetSize(check))) or 0
fileClose(check)
setElementData(resourceRoot, "Version", version)

local updateSystemDisabled = false
if updateSystemDisabled then return end

-- Hilfsfunktion für fetchRemote (Interne ACL-Prüfung wurde entfernt)
local _fetchRemote = fetchRemote
function fetchRemote(...)
	return _fetchRemote(...)
end

RemoteVersion = 0
ManualUpdate = false
updateTimer = false
updatePeriodTimer = false
local updateCheckNoticeInterval = 30 -- Minuten
local updateCheckInterval = 6 -- Stunden


function checkUpdate()
<<<<<<< HEAD
	outputDebugString(DEBUG_TAG.."Verbinde mit GitHub...")
	local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..UPDATE_CFG_FILE
	outputDebugString(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url)
	
	fetchRemote(url, function(data, err)
		if err == 0 then
			RemoteVersion = tonumber(data)
			if not RemoteVersion then
				outputDebugString(DEBUG_TAG.."FEHLER: Remote-Version ist keine Zahl. update.cfg Format prüfen! Remote-Daten: '"..tostring(data).."'", 2)
				return
			end
			
			if not ManualUpdate then
				if RemoteVersion > version then
					outputDebugString(DEBUG_TAG.."Remote Version erhalten [Remote:" .. data .. " Aktuell:" .. version .. "].")
					outputDebugString(DEBUG_TAG.."Update? Befehl: update "..RES_NAME)
					if isTimer(updateTimer) then killTimer(updateTimer) end
					updateTimer = setTimer(function()
						if RemoteVersion > version then
							outputDebugString(DEBUG_TAG.."Remote Version erhalten [Remote:" .. RemoteVersion .. " Aktuell:" .. version .. "].")
							outputDebugString(DEBUG_TAG.."Update? Befehl: update "..RES_NAME)
						else
							killTimer(updateTimer)
						end
					end, updateCheckNoticeInterval * 60000, 0)
				else
					outputDebugString(DEBUG_TAG.."Aktuelle Version (" .. version .. ") ist die neueste!")
				end
			else
				startUpdate()
			end
		else
			outputDebugString(DEBUG_TAG.."SCHWERWIEGENDER FEHLER BEI DER VERSIONSÜBERPRÜFUNG! URL: "..url, 2)
			local errorString = "Unbekannter Fehler"
			if err == 2 then errorString = "Netzwerk-Timeout / Verbindung blockiert (Firewall?)" end
			if err == 404 then errorString = "Datei nicht gefunden (URL / Branch ist falsch)" end
			if err == -1 then errorString = "ACL-Zugriff verweigert (Benötigt function.fetchRemote)" end
			
			outputDebugString(DEBUG_TAG.."Kann Remote-Version nicht abrufen (FEHLER: "..err.." / "..errorString..")", 2)
		end
	end)
=======
    outputDebugString(DEBUG_TAG.."Connecting to github...")
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..UPDATE_CFG_FILE
    outputDebugString(DEBUG_TAG.."ICE DEBUG: requesting URL: "..url)
    
    fetchRemote(url, function(data, err)
        if err == 0 then
            RemoteVersion = tonumber(data)
            if not RemoteVersion then
                outputDebugString(DEBUG_TAG.."ERROR: Remote version is not a number. Check update.cfg format! Remote data: '"..tostring(data).."'", 2)
                return
            end
            
            if not ManualUpdate then
                if RemoteVersion > version then
                    outputDebugString(DEBUG_TAG.."Remote Version Got [Remote:" .. data .. " Current:" .. version .. "].")
                    outputDebugString(DEBUG_TAG.."Update? Command: update "..RES_NAME)
                    if isTimer(updateTimer) then killTimer(updateTimer) end
                    updateTimer = setTimer(function()
                        if RemoteVersion > version then
                            outputDebugString(DEBUG_TAG.."Remote Version Got [Remote:" .. RemoteVersion .. " Current:" .. version .. "].")
                            outputDebugString(DEBUG_TAG.."Update? Command: update "..RES_NAME)
                        else
                            killTimer(updateTimer)
                        end
                    end, updateCheckNoticeInterval * 60000, 0)
                else
                    outputDebugString(DEBUG_TAG.."Current Version(" .. version .. ") is the latest!")
                end
            else
                startUpdate()
            end
        else
            outputDebugString(DEBUG_TAG.."FATAL ERROR DURING VERSION CHECK! URL: "..url, 2)
            -- DETAILLIERTE FEHLERAUSGABE FÜR DEBUGGING
            local errorString = "Unknown error"
            if err == 2 then errorString = "Network Timeout / Connection Blocked (Firewall?)" end
            if err == 404 then errorString = "File Not Found (URL / Branch is wrong)" end
            if err == -1 then errorString = "ACL Access Denied (Need function.fetchRemote)" end
            
            outputDebugString(DEBUG_TAG.."Can't Get Remote Version (ERROR: "..err.." / "..errorString..")", 2)
        end
    end)
>>>>>>> b51a20aa5280ab83a8612b0b9e8c2f30978d9cb9
end

local updateCheckAuto = true 
if updateCheckAuto then
    checkUpdate()
    updatePeriodTimer = setTimer(checkUpdate, updateCheckInterval * 3600000, 0)
end

-- Command Handler zum Starten des Updates: /update [Ressourcenname]
addCommandHandler("update", function(player, cmd, targetResourceName)
<<<<<<< HEAD
	if targetResourceName ~= RES_NAME then
		if not targetResourceName then
			outputChatBox("Nutzung: /update "..RES_NAME, player, 255, 255, 0)
		end
		return
	end
	
	-- Berechtigungsprüfung vereinfacht
	local isPermit = hasObjectPermissionTo(player, "command.update")

	if isPermit then
		outputDebugString(DEBUG_TAG..getPlayerName(player) .. " versucht, "..RES_NAME.." zu aktualisieren (Erlaubt)")
		outputDebugString(DEBUG_TAG.."Vorbereitung zur Aktualisierung von "..RES_NAME)
		outputChatBox(DEBUG_TAG.."Vorbereitung zur Aktualisierung von "..RES_NAME, root, 0, 255, 0)
		if RemoteVersion > version then
			startUpdate()
		else
			ManualUpdate = true
			checkUpdate()
		end
	else
		outputChatBox(DEBUG_TAG.."Zugriff verweigert!", player, 255, 0, 0)
		outputDebugString(DEBUG_TAG..getPlayerName(player) .. " versucht, "..RES_NAME.." zu aktualisieren (Verweigert)!", 2)
	end
end)

function startUpdate()
	ManualUpdate = false
	setTimer(function()
		outputDebugString(DEBUG_TAG.."Fordere Update-Daten von GitHub an...")
		local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/meta.xml"
		outputDebugString(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url)
		
		fetchRemote(url, function(data, err)
			if err == 0 then
				outputDebugString(DEBUG_TAG.."Update-Daten erhalten")
				if fileExists("updated/meta.xml") then
					fileDelete("updated/meta.xml")
				end
				local meta = fileCreate("updated/meta.xml")
				fileWrite(meta, data)
				fileClose(meta)
				outputDebugString(DEBUG_TAG.."Fordere Verifikationsdaten an...")
				getGitHubTree()
			else
				local errorString = "Unbekannter Fehler"
				if err == 2 then errorString = "Netzwerk-Timeout / Verbindung blockiert (Firewall?)" end
				if err == 404 then errorString = "Datei nicht gefunden (meta.xml fehlt)" end
				if err == -1 then errorString = "ACL-Zugriff verweigert (Benötigt function.fetchRemote)" end
				
				outputDebugString(DEBUG_TAG.."Kann Remote-Update-Daten nicht abrufen (FEHLER: "..err.." / "..errorString..")", 2)
			end
		end)
	end, 50, 1)
=======
    -- Prüfen, ob der Befehl korrekt für DIESE Ressource verwendet wurde
    if targetResourceName ~= RES_NAME then
        if not targetResourceName then
            outputChatBox("Nutzung: /update "..RES_NAME, player, 255, 255, 0)
        end
        return
    end
    
    -- Berechtigungsprüfung vereinfacht
    local isPermit = hasObjectPermissionTo(player, "command.update")

    if isPermit then
        outputDebugString(DEBUG_TAG..getPlayerName(player) .. " attempt to update "..RES_NAME.." (Allowed)")
        outputDebugString(DEBUG_TAG.."Preparing for updating "..RES_NAME)
        outputChatBox(DEBUG_TAG.."Preparing for updating "..RES_NAME, root, 0, 255, 0)
        if RemoteVersion > version then
            startUpdate()
        else
            ManualUpdate = true
            checkUpdate()
        end
    else
        outputChatBox(DEBUG_TAG.."Access Denined!", player, 255, 0, 0)
        outputDebugString(DEBUG_TAG..getPlayerName(player) .. " attempt to update "..RES_NAME.." (Denied)!", 2)
    end
end)

function startUpdate()
    ManualUpdate = false
    setTimer(function()
        outputDebugString(DEBUG_TAG.."Requesting Update Data (From github)...")
        local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/meta.xml"
        outputDebugString(DEBUG_TAG.."ICE DEBUG: requesting URL: "..url)
        
        fetchRemote(url, function(data, err)
            if err == 0 then
                outputDebugString(DEBUG_TAG.."Update Data Acquired")
                if fileExists("updated/meta.xml") then
                    fileDelete("updated/meta.xml")
                end
                local meta = fileCreate("updated/meta.xml")
                fileWrite(meta, data)
                fileClose(meta)
                outputDebugString(DEBUG_TAG.."Requesting Verification Data...")
                getGitHubTree()
            else
                local errorString = "Unknown error"
                if err == 2 then errorString = "Network Timeout / Connection Blocked (Firewall?)" end
                if err == 404 then errorString = "File Not Found (URL / Branch is wrong)" end
                if err == -1 then errorString = "ACL Access Denied (Need function.fetchRemote)" end
                
                outputDebugString(DEBUG_TAG.."Can't Get Remote Update Data (ERROR: "..err.." / "..errorString..")", 2)
            end
        end)
    end, 50, 1)
>>>>>>> b51a20aa5280ab83a8612b0b9e8c2f30978d9cb9
end

preUpdate = {}
fileHash = {}
UpdateCount = 0
folderGetting = {}
function getGitHubTree(path, nextPath)
<<<<<<< HEAD
	nextPath = nextPath or ""
	
	local url = path or "https://api.github.com/repos/"..REPO_USER.."/"..REPO_NAME.."/git/trees/"..REPO_BRANCH.."?recursive=1"
	outputDebugString(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url)
	
	fetchRemote(url, function(data, err)
		if err == 0 then
			local theTable = fromJSON(data)
			if not theTable or not theTable.tree then
				outputDebugString(DEBUG_TAG.."Fehler beim Parsen der GitHub API Antwort. Antwort ungültig oder leer.", 2)
				return
			end
			
			folderGetting[theTable.sha] = nil
			
			-- Vereinfachte Dateiverarbeitung (ohne DGS-spezische Filter)
			for k, v in pairs(theTable.tree) do
				local thePath = normalize_path(nextPath..v.path)
				
				if v.mode == "040000" then -- Dies ist ein Ordner
					-- ...
				elseif v.type == "blob" then -- Dies ist eine Datei
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
			
			outputDebugString(DEBUG_TAG.."Fehler beim Abrufen der Verifikationsdaten (FEHLER: "..err.." / "..errorString..")!", 2)
		end
	end)
=======
    nextPath = nextPath or ""
    
    local url = path or "https://api.github.com/repos/"..REPO_USER.."/"..REPO_NAME.."/git/trees/"..REPO_BRANCH.."?recursive=1"
    outputDebugString(DEBUG_TAG.."ICE DEBUG: requesting URL: "..url)
    
    fetchRemote(url, function(data, err)
        if err == 0 then
            local theTable = fromJSON(data)
            if not theTable or not theTable.tree then
                outputDebugString(DEBUG_TAG.."Failed to parse GitHub API response. Response invalid or empty.", 2)
                return
            end
            
            folderGetting[theTable.sha] = nil
            
            -- Vereinfachte Dateiverarbeitung (ohne DGS-spezifische Filter)
            for k, v in pairs(theTable.tree) do
                local thePath = normalize_path(nextPath..v.path)
                if v.mode == "040000" then -- Dies ist ein Ordner
                    -- Dies wird bei '?recursive=1' ignoriert, aber der Block bleibt
                elseif v.type == "blob" then -- Dies ist eine Datei
                    if v.path ~= UPDATE_CFG_FILE and v.path ~= "meta.xml" then
                        fileHash[thePath] = v.sha
                    end
                end
            end
            checkFiles()
            
        else
            local errorString = "Unknown error"
            if err == 2 then errorString = "Network Timeout / Connection Blocked (Firewall?)" end
            if err == 404 then errorString = "Repo/Branch not found (API)" end
            if err == -1 then errorString = "ACL Access Denied (Need function.fetchRemote)" end
            
            outputDebugString(DEBUG_TAG.."Failed To Get Verification Data (ERROR: "..err.." / "..errorString..")!", 2)
        end
    end)
>>>>>>> b51a20aa5280ab83a8612b0b9e8c2f30978d9cb9
end

function checkFiles()
    local xml = xmlLoadFile("updated/meta.xml")
    if not xml then
        outputDebugString(DEBUG_TAG.."SCHWERWIEGEND: meta.xml konnte zur Dateiüberprüfung nicht geladen werden.", 2)
        return
    end
    
<<<<<<< HEAD
	-- Prüft alle Dateien, die in der meta.xml gelistet sind
	for k, v in pairs(xmlNodeGetChildren(xml)) do
		if xmlNodeGetName(v) == "script" or xmlNodeGetName(v) == "file" then
			local path = xmlNodeGetAttribute(v, "src")
			
			-- KORREKTUR: Normalisierung des Pfades aus der meta.xml für den Hash-Vergleich
			local correctedPath = normalize_path(path)
			
			if correctedPath ~= "meta.xml" then -- meta.xml wird von uns neu geschrieben
				local sha = ""
				if fileExists(path) then
					local file = fileOpen(path)
					local size = fileGetSize(file)
					local text = fileRead(file, size)
					fileClose(file)
					-- Berechne den SHA-Hash der lokalen Datei
					sha = hash("sha1", "blob " .. size .. "\0" .. text)
				end
				-- Vergleicht den lokalen SHA-Hash mit dem Hash von GitHub (fileHash[correctedPath])
				if sha ~= fileHash[correctedPath] then 
					outputDebugString(DEBUG_TAG.."Update erforderlich: (" .. path .. ")")
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
	
	-- KORREKTUR: Normalisierung des Pfades für die URL-Erstellung
	local urlPath = normalize_path(currentPath)
	
	outputDebugString(DEBUG_TAG.."Fordere an (" .. UpdateCount .. "/" .. (#preUpdate or "Unbekannt") .. "): " .. tostring(currentPath) .. "")
	
	local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..urlPath
	outputDebugString(DEBUG_TAG.."ICE DEBUG: URL-Anfrage: "..url)
	
	-- Lädt die Datei direkt von GitHub (raw content)
	fetchRemote(url, function(data, err, path)
		if err == 0 then
			local size = 0
			if fileExists(path) then
				local file = fileOpen(path)
				size = fileGetSize(file)
				fileClose(file)
				fileDelete(path)
			end
			
		 -- Stelle sicher, dass der Ordner existiert, falls nötig
            local folderPath = string.match(path, "^(.-)/[^/]+$")
            if folderPath and not fileExists(folderPath) then createDirectory(folderPath) end
			
			local file = fileCreate(path)
			fileWrite(file, data)
			local newsize = fileGetSize(file)
			fileClose(file)
			outputDebugString(DEBUG_TAG.."Datei erhalten (" .. UpdateCount .. "/" .. #preUpdate .. "): " .. path .. " [ " .. size .. "B -> " .. newsize .. "B ]")
		else
			local errorString = "Unbekannter Fehler"
			if err == 2 then errorString = "Netzwerk-Timeout / Verbindung blockiert (Firewall?)" end
			if err == 404 then errorString = "Datei nicht gefunden (URL / Branch ist falsch)" end
			if err == -1 then errorString = "ACL-Zugriff verweigert (Benötigt function.fetchRemote)" end
			
			outputDebugString(DEBUG_TAG.."Download fehlgeschlagen: "..tostring(path or urlPath).." (FEHLER: "..err.." / "..errorString..")!", 2)
		end
		
		-- Startet den Download der nächsten Datei oder schließt ab
		if preUpdate[UpdateCount+1] then
			DownloadFiles()
		else
			DownloadFinish()
		end
	end, "", false, currentPath)
end

function DownloadFinish()
	outputDebugString(DEBUG_TAG.."Ändere Konfigurationsdatei")
	-- Schreibe die neue Versionsnummer in die lokale Datei
	if fileExists(UPDATE_CFG_FILE) then
		fileDelete(UPDATE_CFG_FILE)
	end
	local file = fileCreate(UPDATE_CFG_FILE)
	fileWrite(file, tostring(RemoteVersion))
	fileClose(file)
	
	-- Ersetze die meta.xml (HINWEIS: DGS-spezifischer Backup-Code wurde entfernt!)
	if fileExists("meta.xml") then
		fileDelete("meta.xml")
	end
    if fileExists("updated/meta.xml") then
	    fileRename("updated/meta.xml", "meta.xml") -- Verschiebe die neue meta.xml an den richtigen Ort
	    fileDelete("updated/meta.xml")
    end
	
	outputDebugString(DEBUG_TAG.."Update abgeschlossen ( "..#preUpdate.." Dateien geändert )")
	outputDebugString(DEBUG_TAG.."Bitte Ressource neu starten: "..RES_NAME)
	outputChatBox(DEBUG_TAG.."Update abgeschlossen ( "..#preUpdate.." Dateien geändert )", root, 0, 255, 0)
	
	preUpdate = {}
	UpdateCount = 0
	
    -- WICHTIG: Verzögert den Neustart, um die Speicherung von update.cfg sicherzustellen
    setTimer(function()
        outputDebugString(DEBUG_TAG.."Starte Ressource nach Verzögerung der Versionsspeicherung neu.")
        restartResource(getThisResource())
    end, 100, 1) -- 100 Millisekunden Verzögerung
=======
    -- Prüfe alle Dateien, die in der meta.xml gelistet sind
    for k, v in pairs(xmlNodeGetChildren(xml)) do
        if xmlNodeGetName(v) == "script" or xmlNodeGetName(v) == "file" then
            local path = normalize_path(xmlNodeGetAttribute(v, "src"))
            if path ~= "meta.xml" then -- meta.xml wird von uns neu geschrieben
                local sha = ""
                if fileExists(path) then
                    local file = fileOpen(path)
                    local size = fileGetSize(file)
                    local text = fileRead(file, size)
                    fileClose(file)
                    -- Berechne den SHA-Hash der lokalen Datei
                    sha = hash("sha1", "blob " .. size .. "\0" .. text)
                end
                -- Vergleiche den lokalen SHA-Hash mit dem Hash von GitHub (fileHash)
                if sha ~= fileHash[path] then
                    outputDebugString(DEBUG_TAG.."Update Required: (" .. path .. ")")
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
    local normalizedPath = normalize_path(currentPath)
    outputDebugString(DEBUG_TAG.."Requesting (" .. UpdateCount .. "/" .. (#preUpdate or "Unknown") .. "): " .. tostring(normalizedPath) .. "")
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..normalizedPath
    outputDebugString(DEBUG_TAG.."ICE DEBUG: requesting URL: "..url)
    
    -- Lade die Datei direkt von GitHub (raw content)
    -- wir geben als 'tag' den normalisierten Pfad mit, damit der Callback ihn als 'path' erhält
    fetchRemote(url, function(data, err, path)
        if err == 0 then
            local size = 0
            if fileExists(path) then
                local file = fileOpen(path)
                size = fileGetSize(file)
                fileClose(file)
                fileDelete(path)
            end
            -- Stelle sicher, dass der Ordner existiert, falls nötig
            local folderPath = string.match(path, "^(.-)/[^/]+$")
            if folderPath and not fileExists(folderPath) then createDirectory(folderPath) end
            
            local file = fileCreate(path)
            fileWrite(file, data)
            local newsize = fileGetSize(file)
            fileClose(file)
            outputDebugString(DEBUG_TAG.."File Got (" .. UpdateCount .. "/" .. #preUpdate .. "): " .. path .. " [ " .. size .. "B -> " .. newsize .. "B ]")
        else
            local errorString = "Unknown error"
            if err == 2 then errorString = "Network Timeout / Connection Blocked (Firewall?)" end
            if err == 404 then errorString = "File Not Found (URL / Branch is wrong)" end
            if err == -1 then errorString = "ACL Access Denied (Need function.fetchRemote)" end
            
            outputDebugString(DEBUG_TAG.."Download Failed: "..tostring(path or normalizedPath).." (ERROR: "..err.." / "..errorString..")!", 2)
        end
        
        -- Starte den Download der nächsten Datei oder schließe ab
        if preUpdate[UpdateCount+1] then
            DownloadFiles()
        else
            DownloadFinish()
        end
    end, "", false, normalizedPath)
end

function DownloadFinish()
    outputDebugString(DEBUG_TAG.."Changing Config File")
    -- Schreibe die neue Versionsnummer in die lokale Datei
    if fileExists(UPDATE_CFG_FILE) then
        fileDelete(UPDATE_CFG_FILE)
    end
    local file = fileCreate(UPDATE_CFG_FILE)
    fileWrite(file, tostring(RemoteVersion))
    fileClose(file)
    
    -- Ersetze die meta.xml (HINWEIS: Hier wurde DGS-spezifischer Backup-Code entfernt!)
    if fileExists("meta.xml") then
        fileDelete("meta.xml")
    end
    if fileExists("updated/meta.xml") then
        fileRename("updated/meta.xml", "meta.xml") -- Verschiebe die neue meta.xml an den richtigen Ort
        fileDelete("updated/meta.xml")
    end
    
    outputDebugString(DEBUG_TAG.."Update Complete ( "..#preUpdate.." File"..(#preUpdate==1 and "" or "s").." Changed )")
    outputDebugString(DEBUG_TAG.."Please Restart "..RES_NAME)
    outputChatBox(DEBUG_TAG.."Update Complete ( "..#preUpdate.." File"..(#preUpdate==1 and "" or "s").." Changed )", root, 0, 255, 0)
    
    preUpdate = {}
    UpdateCount = 0
    
    restartResource(getThisResource())
>>>>>>> b51a20aa5280ab83a8612b0b9e8c2f30978d9cb9
end

-- Command Handler für die Versionsanzeige (z.B. /SKRIPTNAMEver)
addCommandHandler(RES_NAME.."ver", function(pla, cmd)
<<<<<<< HEAD
	local vsdd
	if fileExists(UPDATE_CFG_FILE) then
		local file = fileOpen(UPDATE_CFG_FILE)
		local vscd = fileRead(file, fileGetSize(file))
		fileClose(file)
		vsdd = tonumber(vscd)
		if vsdd then
			outputDebugString(DEBUG_TAG.."Version: " .. vsdd, 3)
		else
			outputDebugString(DEBUG_TAG.."Versionsstatus ist beschädigt! Bitte /update "..RES_NAME.." zum Aktualisieren verwenden", 1)
		end
	else
		outputDebugString(DEBUG_TAG.."Versionsstatus ist beschädigt! Bitte /update "..RES_NAME.." zum Aktualisieren verwenden", 1)
	end
	if getPlayerName(pla) ~= "Console" then
		if vsdd then
			outputChatBox(DEBUG_TAG.."Version: " .. vsdd, pla, 0, 255, 0)
		else
			outputChatBox(DEBUG_TAG.."Versionsstatus ist beschädigt! Bitte /update "..RES_NAME.." zum Aktualisieren verwenden", pla, 255, 0, 0)
		end
	end
=======
    local vsdd
    if fileExists(UPDATE_CFG_FILE) then
        local file = fileOpen(UPDATE_CFG_FILE)
        local vscd = fileRead(file, fileGetSize(file))
        fileClose(file)
        vsdd = tonumber(vscd)
        if vsdd then
            outputDebugString(DEBUG_TAG.."Version: " .. vsdd, 3)
        else
            outputDebugString(DEBUG_TAG.."Version State is damaged! Please use /update "..RES_NAME.." to update", 1)
        end
    else
        outputDebugString(DEBUG_TAG.."Version State is damaged! Please use /update "..RES_NAME.." to update", 1)
    end
    if getPlayerName(pla) ~= "Console" then
        if vsdd then
            outputChatBox(DEBUG_TAG.."Version: " .. vsdd, pla, 0, 255, 0)
        else
            outputChatBox(DEBUG_TAG.."Version State is damaged! Please use /update "..RES_NAME.." to update", pla, 255, 0, 0)
        end
    end
>>>>>>> b51a20aa5280ab83a8612b0b9e8c2f30978d9cb9
end)