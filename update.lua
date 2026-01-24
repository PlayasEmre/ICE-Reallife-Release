-- ==========================================================
-- I. KONFIGURATION
-- ==========================================================
local REPO_USER = "PlayasEmre"
local REPO_NAME = "ICE-Reallife-Release"
local RES_NAME = "ICE"
local REPO_BRANCH = "main"
local UPDATE_CFG_FILE = "update.cfg"
local DEBUG_TAG = "["..RES_NAME.."]"

-- SICHERHEIT: Token leer lassen (""), wenn Repo öffentlich ist.
local GITHUB_TOKEN = ""

local AUTO_DOWNLOAD_ENABLED = false
local AUTO_CHECK_ENABLED = true
local NOTICE_REMINDER_INTERVAL_HOURS = 1
local AUTO_CHECK_INTERVAL_HOURS = 1

-- ==========================================================
-- II. Globale Variablen
-- ==========================================================
RemoteVersion = 0
ManualUpdate = false
updateTimer = false
updatePeriodTimer = false

local requestHeaders = {
    headers = {
        ["User-Agent"] = "MTA-Resource-Updater",
        ["Accept"] = "application/vnd.github.v3+json"
    }
}

if GITHUB_TOKEN and #GITHUB_TOKEN > 10 then
    requestHeaders.headers["Authorization"] = "token " .. GITHUB_TOKEN
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

-- Nachricht NUR an Admins
local function outputChatBoxToAdmins(message, r, g, b)
    outputDebugString(message)
    local players = getElementsByType("player")
    for _, player in ipairs(players) do
        if isAdmin(player) then
            outputChatBox(message, player, r, g, b, true)
        end
    end
end

local function normalize_path(p)
    if not p then return p end
    p = tostring(p):gsub("\\", "/"):gsub("^/+", "")
    return p
end

local function createDirectoryRecursive(path)
    if not createDirectory then
        outputChatBoxToAdmins(DEBUG_TAG.." KRITISCHER FEHLER: 'createDirectory' fehlt!", 255, 0, 0)
        return
    end
    local parts = split(path, "/")
    local currentPath = ""
    for i, part in ipairs(parts) do
        currentPath = currentPath .. (i > 1 and "/" or "") .. part
        if not fileExists(currentPath) then
            createDirectory(currentPath)
        end
    end
end

-- Version initialisieren
local check = fileExists(UPDATE_CFG_FILE) and fileOpen(UPDATE_CFG_FILE) or fileCreate(UPDATE_CFG_FILE)
local version = tonumber(fileRead(check, fileGetSize(check) or 0)) or 0
fileClose(check)
setElementData(resourceRoot, "Version", version)

function stopAllTimers()
    if isTimer(updateTimer) then killTimer(updateTimer) end
    if isTimer(updatePeriodTimer) then killTimer(updatePeriodTimer) end
    updateTimer = false
    updatePeriodTimer = false
end

-- ==========================================================
-- IV. Hauptlogik
-- ==========================================================

function checkUpdate(isManualCheck)
    isManualCheck = isManualCheck or false
    
    -- HIER IST DEINE ÄNDERUNG: Nachricht an ALLE (root)
    if isManualCheck then 
        outputChatBox(DEBUG_TAG.." Github Verbindung: Prüfe auf Updates...", root, 255, 255, 0, true)
    end
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..UPDATE_CFG_FILE
    
    fetchRemote(url, requestHeaders, function(data, info)
        if info.success and info.statusCode == 200 then
            RemoteVersion = tonumber(data)
            if not RemoteVersion then
                if isManualCheck then outputChatBoxToAdmins(DEBUG_TAG.." Fehler: Keine gültige Version gefunden.", 255, 0, 0) end
                return
            end
            
            if RemoteVersion > version then
                -- Öffentliche Info an ALLE, dass ein Update da ist
                outputChatBox(DEBUG_TAG.." Update ("..RemoteVersion..") gefunden! Der Download wird vorbereitet.", root, 0, 255, 0, true)
                
                if AUTO_DOWNLOAD_ENABLED or isManualCheck then
                    startUpdate()
                else
                    if isTimer(updateTimer) then killTimer(updateTimer) end
                    -- Umrechnung Stunden -> Millisekunden
                    local intervalMs = NOTICE_REMINDER_INTERVAL_HOURS * 60 * 1000
                    updateTimer = setTimer(function()
                        if RemoteVersion > version then
                            outputChatBoxToAdmins(DEBUG_TAG.." [INFO] Update ("..RemoteVersion..") verfügbar! /update "..RES_NAME, 255, 50, 50)
                        end
                    end, intervalMs, 0)
                end
            else
                if isManualCheck then outputChatBoxToAdmins(DEBUG_TAG.." Ressource ist aktuell.", 0, 255, 0) end
            end
        else
            if isManualCheck then 
                outputChatBoxToAdmins(DEBUG_TAG.." Verbindungsfehler (Code: "..tostring(info.statusCode)..")", 255, 0, 0) 
            end
        end
    end)
end

function startUpdate()
    stopAllTimers()
    outputChatBoxToAdmins(DEBUG_TAG.." Lade meta.xml...", 200, 200, 200)
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/meta.xml"
    fetchRemote(url, requestHeaders, function(data, info)
        if info.success and info.statusCode == 200 then
            if fileExists("updated/meta.xml") then fileDelete("updated/meta.xml") end
            if not fileExists("updated") then createDirectoryRecursive("updated") end
            
            local meta = fileCreate("updated/meta.xml")
            fileWrite(meta, data)
            fileClose(meta)
            getGitHubTree()
        end
    end)
end

function getGitHubTree()
    local url = "https://api.github.com/repos/"..REPO_USER.."/"..REPO_NAME.."/git/trees/"..REPO_BRANCH.."?recursive=1"
    fetchRemote(url, requestHeaders, function(data, info)
        if info.success and info.statusCode == 200 then
            local theTable = fromJSON(data)
            if not theTable or not theTable.tree then return end
            fileHash = {}
            for k, v in pairs(theTable.tree) do
                if v.type == "blob" and v.path ~= UPDATE_CFG_FILE and v.path ~= "meta.xml" then
                    fileHash[normalize_path(v.path)] = v.sha
                end
            end
            checkFiles()
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
            local cPath = normalize_path(path)
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
            if sha ~= fileHash[cPath] then table.insert(preUpdate, path) end
        end
    end
    xmlUnloadFile(xml)
    
    if #preUpdate > 0 then
        UpdateCount = 0
        DownloadFiles()
    else
        outputChatBox(DEBUG_TAG.." Update abgeschlossen. Version wird erhöht.", root, 0, 255, 0, true)
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
    
    -- Datei-Details nur an Admins (damit der Chat nicht explodiert)
    outputChatBoxToAdmins(DEBUG_TAG.." Lade Datei ("..UpdateCount.."/"..#preUpdate.."): "..currentPath, 150, 150, 150)
    
    fetchRemote(url, requestHeaders, function(data, info, path)
        if info.success and info.statusCode == 200 then
            if fileExists(path) then fileDelete(path) end
            local folderPath = string.match(path, "^(.-)/[^/]+$")
            if folderPath then createDirectoryRecursive(folderPath) end
            local file = fileCreate(path)
            if file then
                fileWrite(file, data)
                fileClose(file)
            end
        end
        DownloadFiles()
    end, {path = currentPath})
end

function DownloadFinish()
    if fileExists(UPDATE_CFG_FILE) then fileDelete(UPDATE_CFG_FILE) end
    local file = fileCreate(UPDATE_CFG_FILE)
    fileWrite(file, tostring(RemoteVersion))
    fileClose(file)
    
    if fileExists("meta.xml") then fileDelete("meta.xml") end
    if fileExists("updated/meta.xml") then fileRename("updated/meta.xml", "meta.xml") end
    
    -- Erfolgsmeldung an ALLE
    outputChatBox(DEBUG_TAG.." Update erfolgreich abgeschlossen! Neustart erfolgt...", root, 0, 255, 0, true)
    
    setTimer(function() restartResource(getThisResource()) end, 3000, 1)
end

addCommandHandler("update", function(player, cmd, target)
    if target == RES_NAME and isAdmin(player) then
        checkUpdate(true)
    end
end)

addCommandHandler(RES_NAME.."ver", function(player, cmd)
    local localVer = getElementData(resourceRoot, "Version") or 0
    outputChatBox(DEBUG_TAG.." --------------------------------------------------", player, 255, 255, 0, true)
    outputChatBox(DEBUG_TAG.." Installierte Version: " .. tostring(localVer), player, 255, 255, 255, true)
    outputChatBox(DEBUG_TAG.." GitHub-Version: " .. (RemoteVersion > 0 and tostring(RemoteVersion) or "Ungeprüft"), player, 200, 200, 200, true)
    outputChatBox(DEBUG_TAG.." --------------------------------------------------", player, 255, 255, 0, true)
end)

if AUTO_CHECK_ENABLED then
    setTimer(function() checkUpdate(false) end, 5000, 1)
    
    -- Automatische Prüfung (Stunden * 60 * 60 * 1000)
    local intervalMs = AUTO_CHECK_INTERVAL_HOURS * 60 * 1000
    setTimer(function() checkUpdate(false) end, intervalMs, 0)
end