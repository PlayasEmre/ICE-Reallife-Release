-- ==========================================================
-- I. KONFIGURATION
-- ==========================================================

local REPO_USER = "PlayasEmre"
local REPO_NAME = "ICE-Reallife-Release"
local RES_NAME = "ICE"
local REPO_BRANCH = "main"
local UPDATE_CFG_FILE = "update.cfg"
local DEBUG_TAG = "["..RES_NAME.."]"

-- WICHTIG: 
-- false = Nur benachrichtigen (Sicherste Option)
-- true = Sofort herunterladen, wenn Update gefunden wird
local AUTO_DOWNLOAD_ENABLED = false

local AUTO_CHECK_ENABLED = true
local NOTICE_REMINDER_INTERVAL_HOURS = 1
local AUTO_CHECK_INTERVAL_HOURS = 1

-- ==========================================================
-- II. Globale Variablen und Initialisierung
-- ==========================================================
-- Wir machen diese Variablen lokal, damit sie sich nicht mit anderen Skripten beißen
local RemoteVersion = 0
local updateTimer = false
local updatePeriodTimer = false
local preUpdate = {}
local fileHash = {}
local UpdateCount = 0

-- Wrapper für fetchRemote (falls nötig, sonst Standard)
local _fetchRemote = fetchRemote
function fetchRemote(...)
    return _fetchRemote(...)
end

-- ==========================================================
-- III. Hilfsfunktionen
-- ==========================================================

function isAdmin(player)
    if player and isElement(player) and getElementType(player) == "player" then
        local adminLevel = tonumber(getElementData(player, "adminlvl")) or 0
        return adminLevel >= 9
    end
    return false
end

local function outputChatBoxToAdmins(message, r, g, b)
    outputDebugString(message)
    local players = getElementsByType("player")
    for _, player in ipairs(players) do
        if isAdmin(player) then
            outputChatBox(message, player, r, g, b, true) -- 'true' für Farbcodes
        end
    end
end

local function normalize_path(p)
    if not p then return p end
    p = tostring(p):gsub("\\", "/"):gsub("^/+", "")
    return p
end

-- WICHTIG: Funktion zum Erstellen von Unterordnern (z.B. assets/images/)
local function createDirectoryRecursive(path)
    local parts = split(path, "/")
    local currentPath = ""
    for i, part in ipairs(parts) do
        currentPath = currentPath .. (i > 1 and "/" or "") .. part
        if not fileExists(currentPath) then
            createDirectory(currentPath)
        end
    end
end

-- Lokale Version laden
local check = fileExists(UPDATE_CFG_FILE) and fileOpen(UPDATE_CFG_FILE) or fileCreate(UPDATE_CFG_FILE)
local version = tonumber(fileRead(check, fileGetSize(check) or 0)) or 0
fileClose(check)
setElementData(resourceRoot, "Version", version)

-- Timer stoppen
function stopAllTimers()
    if isTimer(updateTimer) then killTimer(updateTimer) end
    if isTimer(updatePeriodTimer) then killTimer(updatePeriodTimer) end
    updateTimer = false
    updatePeriodTimer = false
end

-- ==========================================================
-- IV. Hauptlogik: Versionsprüfung
-- ==========================================================

function checkUpdate(isManualCheck)
    isManualCheck = isManualCheck or false 
    
    -- Wenn manuell geprüft wird, gib dem Spieler Feedback
    if isManualCheck then
        outputChatBox(DEBUG_TAG.." Verbinde mit GitHub...", root, 255, 255, 0, true)
    end
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..UPDATE_CFG_FILE
    
    fetchRemote(url, function(data, err)
        if err == 0 then
            RemoteVersion = tonumber(data)
            
            -- Sicherheitscheck: Ist die Version gültig?
            if not RemoteVersion then
                if isManualCheck then 
                    outputChatBoxToAdmins(DEBUG_TAG.." FEHLER: Keine gültige Version gefunden.", 255, 0, 0)
                end
                return
            end
            
            if RemoteVersion > version then
                -- UPDATE GEFUNDEN
                
                -- Fall A: Download starten (Nur wenn Auto-Download an ist ODER manuell befohlen)
                if AUTO_DOWNLOAD_ENABLED or isManualCheck then
                    outputChatBox(DEBUG_TAG.." Update gefunden ("..RemoteVersion.."). Download startet...", root, 0, 255, 0, true)
                    startUpdate()
                    return
                end
                
                -- Fall B: Nur Benachrichtigen (Automatischer Check im Hintergrund)
                if isTimer(updateTimer) then killTimer(updateTimer) end
                
                -- Korrekte Umrechnung: Stunden * 60 * 60 * 1000
                local notice_interval_ms = NOTICE_REMINDER_INTERVAL_HOURS * 60 * 60 * 1000
                
                -- Erinnerungs-Timer starten
                updateTimer = setTimer(function()
                    if RemoteVersion > version then
                        outputChatBoxToAdmins(DEBUG_TAG.." [INFO] Update ("..RemoteVersion..") verfügbar! /update "..RES_NAME, 255, 50, 50)
                    end
                end, notice_interval_ms, 0)
                
                -- Einmalige sofortige Info an Admins
                outputChatBoxToAdmins(DEBUG_TAG.." [INFO] Update ("..RemoteVersion..") verfügbar! Nutze /update "..RES_NAME, 255, 50, 50)
                
            else
                -- KEIN UPDATE
                if isManualCheck then
                    outputChatBoxToAdmins(DEBUG_TAG.." Ressource ist aktuell (v"..version..").", 0, 255, 0)
                end
            end
        else
            if isManualCheck then
                outputChatBoxToAdmins(DEBUG_TAG.." Verbindungsfehler GitHub (Code: "..err..")", 255, 0, 0)
            end
        end
    end)
end

-- ==========================================================
-- V. Automatischer Timer Start
-- ==========================================================

if AUTO_CHECK_ENABLED then
    if not isTimer(updatePeriodTimer) then
        -- Erster Check nach 5 Sekunden (false = nur prüfen, nicht laden)
        setTimer(function() checkUpdate(false) end, 5000, 1)
        
        -- Periodischer Check (Stunden * 60 * 60 * 1000)
        local interval_ms = AUTO_CHECK_INTERVAL_HOURS * 60 * 60 * 1000
        
        outputChatBox(DEBUG_TAG.." Auto-Update-Check alle "..AUTO_CHECK_INTERVAL_HOURS.." Stunden aktiviert.", root, 100, 200, 255, true)
        updatePeriodTimer = setTimer(function() checkUpdate(false) end, interval_ms, 0)
    end
end

-- ==========================================================
-- VI. Update Befehlshandler (/update ICE)
-- ==========================================================

addCommandHandler("update", function(player, cmd, targetResourceName)
    -- Wenn kein Name angegeben, zeige Hilfe (aber nur für Admins relevant)
    if not targetResourceName or targetResourceName ~= RES_NAME then
        if isAdmin(player) then
            outputChatBox("Nutzung: /update "..RES_NAME, player, 255, 255, 0)
        end
        return
    end
    
    if isAdmin(player) then
        outputChatBoxToAdmins(DEBUG_TAG.." " .. getPlayerName(player) .. " startet Update-Prüfung...", 100, 100, 255)
        checkUpdate(true) -- 'true' bedeutet: Update sofort laden, wenn gefunden!
    else
        outputChatBox(DEBUG_TAG.." Zugriff verweigert!", player, 255, 0, 0, true)
    end
end)

-- ==========================================================
-- VII. Download- und Installationsfunktionen
-- ==========================================================

function startUpdate()
    stopAllTimers()
    outputChatBoxToAdmins(DEBUG_TAG.." Lade meta.xml...", 150, 150, 150)
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/meta.xml"
    
    fetchRemote(url, function(data, err)
        if err == 0 then
            if fileExists("updated/meta.xml") then fileDelete("updated/meta.xml") end
            
            -- Sicherstellen, dass der Ordner 'updated' existiert
            if not fileExists("updated") then createDirectory("updated") end
            
            local meta = fileCreate("updated/meta.xml")
            fileWrite(meta, data)
            fileClose(meta)
            
            getGitHubTree()
        else
            outputChatBoxToAdmins(DEBUG_TAG.." Fehler beim Laden der meta.xml (Code: "..err..")", 255, 0, 0)
        end
    end)
end

function getGitHubTree()
    local url = "https://api.github.com/repos/"..REPO_USER.."/"..REPO_NAME.."/git/trees/"..REPO_BRANCH.."?recursive=1"
    
    fetchRemote(url, function(data, err)
        if err == 0 then
            local theTable = fromJSON(data)
            if not theTable or not theTable.tree then return end
            
            fileHash = {}
            for k, v in pairs(theTable.tree) do
                if v.type == "blob" and v.path ~= UPDATE_CFG_FILE and v.path ~= "meta.xml" then
                    fileHash[normalize_path(v.path)] = v.sha
                end
            end
            checkFiles()
        else
            outputChatBoxToAdmins(DEBUG_TAG.." API Fehler beim Abrufen der Dateiliste.", 255, 0, 0)
        end
    end)
end

function checkFiles()
    local xml = xmlLoadFile("updated/meta.xml")
    if not xml then return end

    preUpdate = {}
    
    for k, v in pairs(xmlNodeGetChildren(xml)) do
        local nodeName = xmlNodeGetName(v)
        if nodeName == "script" or nodeName == "file" then
            local path = xmlNodeGetAttribute(v, "src")
            local cleanPath = normalize_path(path)
            local sha = ""
            
            if fileExists(path) then
                local file = fileOpen(path)
                if file then
                    local size = fileGetSize(file)
                    local text = fileRead(file, size)
                    fileClose(file)
                    sha = hash("sha1", "blob " .. size .. "\0" .. text)
                end
            end
            
            if sha ~= fileHash[cleanPath] then
                table.insert(preUpdate, path)
            end
        end
    end
    xmlUnloadFile(xml)
    
    if #preUpdate > 0 then
        UpdateCount = 0
        DownloadFiles()
    else
        outputChatBoxToAdmins(DEBUG_TAG.." Dateien identisch. Aktualisiere nur Version.", 0, 255, 0)
        DownloadFinish()
    end
end

function DownloadFiles()
    UpdateCount = UpdateCount + 1
    if not preUpdate[UpdateCount] then
        DownloadFinish()
        return
    end
    
    local currentPath = preUpdate[UpdateCount]
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..normalize_path(currentPath)
    
    outputChatBoxToAdmins(DEBUG_TAG.." Lade Datei ("..UpdateCount.."/"..#preUpdate.."): "..currentPath, 150, 150, 150)
    
    fetchRemote(url, function(data, err, path)
        if err == 0 then
            if fileExists(path) then fileDelete(path) end
            
            -- WICHTIG: Ordner erstellen, falls Datei in einem Unterordner liegt
            local folderPath = string.match(path, "^(.-)/[^/]+$")
            if folderPath then createDirectoryRecursive(folderPath) end
            
            local file = fileCreate(path)
            if file then
                fileWrite(file, data)
                fileClose(file)
            end
        else
            outputChatBoxToAdmins(DEBUG_TAG.." Fehler beim Download: "..path, 255, 0, 0)
        end
        
        DownloadFiles()
    end, "", false, currentPath)
end

function DownloadFinish()
    if fileExists(UPDATE_CFG_FILE) then fileDelete(UPDATE_CFG_FILE) end
    local file = fileCreate(UPDATE_CFG_FILE)
    fileWrite(file, tostring(RemoteVersion))
    fileClose(file)
    
    if fileExists("meta.xml") then fileDelete("meta.xml") end
    if fileExists("updated/meta.xml") then 
        fileRename("updated/meta.xml", "meta.xml") 
    end
    
    outputChatBox(DEBUG_TAG.." Update erfolgreich! Neustart in 3 Sekunden...", root, 0, 255, 0, true)
    
    setTimer(function() restartResource(getThisResource()) end, 3000, 1)
end

-- Info-Befehl für Version
addCommandHandler(RES_NAME.."ver", function(player)
    local localVer = getElementData(resourceRoot, "Version") or 0
    outputChatBox(DEBUG_TAG.." Installierte Version: " .. localVer, player, 255, 255, 255, true)
    if RemoteVersion > 0 then
        outputChatBox(DEBUG_TAG.." GitHub Version: " .. RemoteVersion, player, 200, 200, 200, true)
    end
end)

-- Join Event (Nur Info für den Spieler)
addEventHandler("onPlayerJoin", root, function()
    outputChatBox(DEBUG_TAG.." Github Verbindung: Prüfe auf Updates...", source, 255, 255, 0, true)
end)