-- ==========================================================
-- I. KONFIGURATION
-- ==========================================================
local REPO_USER = "PlayasEmre"
local REPO_NAME = "ICE-Reallife-Release"
local RES_NAME = "ICE"
local REPO_BRANCH = "main"
local UPDATE_CFG_FILE = "update.cfg"

-- DESIGN: [ICE] in Orange, Text danach Weiß
local DEBUG_TAG = "#FF9900["..RES_NAME.."]#FFFFFF"

local AUTO_DOWNLOAD_ENABLED = false
local AUTO_CHECK_ENABLED = true
local NOTICE_REMINDER_INTERVAL_HOURS = 1
local AUTO_CHECK_INTERVAL_HOURS = 1


-- ==========================================================
-- III. Globale Variablen
-- ==========================================================
local RemoteVersion = 0
local updateTimer = false
local updatePeriodTimer = false
local preUpdate = {}
local fileHash = {}
local UpdateCount = 0

-- ==========================================================
-- IV. Hilfsfunktionen
-- ==========================================================

function isAdmin(player)
    if player and isElement(player) and getElementType(player) == "player" then
        local adminLevel = tonumber(getElementData(player, "adminlvl")) or 0
        return adminLevel >= 9
    end
    return false
end

local function outputChatBoxToAdmins(message)
    local players = getElementsByType("player")
    for _, player in ipairs(players) do
        if isAdmin(player) then
            outputChatBox(message, player, 255, 255, 255, true)
        end
    end
    outputDebugString(string.gsub(message, "#%x%x%x%x%x%x", "")) 
end

local function normalize_path(p)
    if not p then return p end
    p = tostring(p):gsub("\\", "/"):gsub("^/+", "")
    return p
end

function createDirectoryRecursive(path)
    if not path or path == "" or path == "." then return end
    path = string.gsub(path, "\\", "/")
    local parts = split(path, "/")
    local currentPath = ""
    for i, part in ipairs(parts) do
        if part and part ~= "" then
            currentPath = currentPath .. (i > 1 and "/" or "") .. part
            if not fileExists(currentPath) then
                createDirectory(currentPath)
            end
        end
    end
end

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
-- V. Hauptlogik
-- ==========================================================

function checkUpdate(isManualCheck)
    isManualCheck = isManualCheck or false 
    
    if isManualCheck then
        outputChatBox(DEBUG_TAG.." Verbinde mit GitHub...", root, 255, 255, 0, true)
    end
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..UPDATE_CFG_FILE
    
    fetchRemote(url, function(data, err)
        if err == 0 then
            RemoteVersion = tonumber(data)
            if not RemoteVersion then return end
            
            if RemoteVersion > version then
                if AUTO_DOWNLOAD_ENABLED or isManualCheck then
                    outputChatBox(DEBUG_TAG.." Update (#00FF00"..RemoteVersion.."#FFFFFF) gefunden! #00FF00Download startet...", root, 255, 255, 255, true)
                    startUpdate()
                else
                    if isTimer(updateTimer) then killTimer(updateTimer) end
                    local interval = NOTICE_REMINDER_INTERVAL_HOURS * 60 * 1000
                    updateTimer = setTimer(function()
                        if RemoteVersion > version then
                            outputChatBoxToAdmins(DEBUG_TAG.." #FF0000[INFO] #FFFFFFUpdate (#00FF00"..RemoteVersion.."#FFFFFF) verfügbar! Nutze #FFFF00/update "..RES_NAME)
                        end
                    end, interval, 0)
                    outputChatBoxToAdmins(DEBUG_TAG.." #FF0000[INFO] #FFFFFFUpdate (#00FF00"..RemoteVersion.."#FFFFFF) verfügbar! Nutze #FFFF00/update "..RES_NAME)
                end
            else
                if isManualCheck then 
                    outputChatBoxToAdmins(DEBUG_TAG.." Ressource ist aktuell (#00FF00v"..version.."#FFFFFF).") 
                end
            end
        else
            if isManualCheck then 
                outputChatBoxToAdmins(DEBUG_TAG.." #FF0000Verbindungsfehler (Code: "..tostring(err)..")") 
            end
        end
    end)
end

-- ==========================================================
-- VI. Download & Dateien
-- ==========================================================

function startUpdate()
    stopAllTimers()
    outputChatBoxToAdmins(DEBUG_TAG.." #AAAAAALade meta.xml...")
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/meta.xml"
    fetchRemote(url, function(data, err)
        if err == 0 then
            if not fileExists("updated") then createDirectory("updated") end
            if fileExists("updated/meta.xml") then fileDelete("updated/meta.xml") end
            
            local meta = fileCreate("updated/meta.xml")
            fileWrite(meta, data)
            fileClose(meta)
            getGitHubTree()
        else
            outputChatBoxToAdmins(DEBUG_TAG.." #FF0000Fehler beim Laden der meta.xml")
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
             outputChatBoxToAdmins(DEBUG_TAG.." #FF0000Fehler bei GitHub API.")
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
            if sha ~= fileHash[cleanPath] then table.insert(preUpdate, path) end
        end
    end
    xmlUnloadFile(xml)
    
    if #preUpdate > 0 then 
        UpdateCount = 0 
        DownloadFiles() 
    else 
        outputChatBoxToAdmins(DEBUG_TAG.." #00FF00Dateien aktuell. #FFFFFFVersion wird gespeichert.")
        DownloadFinish() 
    end
end

function DownloadFiles()
    UpdateCount = UpdateCount + 1
    if not preUpdate[UpdateCount] then DownloadFinish() return end
    
    local currentPath = preUpdate[UpdateCount]
    local urlPath = normalize_path(currentPath)
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..urlPath
    
    outputChatBoxToAdmins(DEBUG_TAG.." #AAAAAALade Datei ("..UpdateCount.."/"..#preUpdate.."): "..currentPath)
    
    fetchRemote(url, function(data, err)
        if err == 0 then
            if fileExists(currentPath) then fileDelete(currentPath) end
            local folderPath = string.match(currentPath, "^(.-)/[^/]+$")
            if folderPath then createDirectoryRecursive(folderPath) end
            local file = fileCreate(currentPath)
            if file then fileWrite(file, data) fileClose(file) end
        else
            outputChatBoxToAdmins(DEBUG_TAG.." #FF0000Fehler bei Datei: "..currentPath)
        end
        DownloadFiles()
    end)
end

function DownloadFinish()
    if fileExists(UPDATE_CFG_FILE) then fileDelete(UPDATE_CFG_FILE) end
    local file = fileCreate(UPDATE_CFG_FILE)
    fileWrite(file, tostring(RemoteVersion))
    fileClose(file)
    
    if fileExists("meta.xml") then fileDelete("meta.xml") end
    if fileExists("updated/meta.xml") then fileRename("updated/meta.xml", "meta.xml") end
    
    outputChatBox(DEBUG_TAG.." #00FF00Update erfolgreich! #FFFFFFNeustart erfolgt...", root, 255, 255, 255, true)
    setTimer(function() restartResource(getThisResource()) end, 3000, 1)
end

-- ==========================================================
-- VII. Befehle & Events
-- ==========================================================
addCommandHandler("update", function(player, cmd, target)
    if target == RES_NAME and isAdmin(player) then 
        checkUpdate(true) 
    end
end)

addCommandHandler(RES_NAME.."ver", function(player)
    local localVer = getElementData(resourceRoot, "Version") or 0
    outputChatBox(DEBUG_TAG.." Installierte Version: #00FF00" .. localVer, player, 255, 255, 255, true)
    outputChatBox(DEBUG_TAG.." #AAAAAALade neueste Version von GitHub...", player, 255, 255, 255, true)
    
    local url = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..REPO_BRANCH.."/"..UPDATE_CFG_FILE
    fetchRemote(url, function(data, err)
        if err == 0 then
            local remoteVer = tonumber(data)
            if remoteVer then
                outputChatBox(DEBUG_TAG.." Neueste GitHub-Version: #00FF00" .. remoteVer, player, 255, 255, 255, true)
                if remoteVer > localVer then
                    outputChatBox(DEBUG_TAG.." #FFFF00(Ein Update ist verfügbar!)", player, 255, 255, 255, true)
                else
                    outputChatBox(DEBUG_TAG.." #00FF00(Du bist auf dem neuesten Stand)", player, 255, 255, 255, true)
                end
            end
        end
    end)
end)

if AUTO_CHECK_ENABLED then
    setTimer(function() checkUpdate(false) end, 5000, 1)
    updatePeriodTimer = setTimer(function() checkUpdate(false) end, AUTO_CHECK_INTERVAL_HOURS * 60 * 1000, 0)
end

addEventHandler("onPlayerJoin", root, function()
    outputChatBox(DEBUG_TAG.." Github Verbindung: #FFFF00Prüfe auf Updates...", source, 255, 255, 255, true)
end)