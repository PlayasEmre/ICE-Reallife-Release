--//               Project: MTA - German ICE Reallife Gamode               \\
--||               Developers: PlayasEmre                                  ||
--||               Version: 5.6 (Finaler Font-Fix von Gemini)              ||
--\\                                                                       //

local updateTimer

-- Screen-Skalierung Variablen
local sx, sy = guiGetScreenSize()
local spx, spy = 1366, 768
local px, py = (sx/spx) , (sy/spy)

-- NEUE MODERNE KONSTANTEN (Blau)
local COLOR_ACCENT = tocolor(0, 150, 255, 255) -- Haupt-Akzentfarbe (Blau)
local COLOR_HEADER = tocolor(20, 20, 25, 255)
local COLOR_BG_DARK = tocolor(30, 30, 35, 200)
local COLOR_BG_ROW = tocolor(40, 40, 45, 180)
local COLOR_TEXT_DIM = tocolor(150, 150, 150, 255)
local COLOR_TEXT_WHITE = tocolor(255, 255, 255, 255)
local ROW_HEIGHT_UNIT = 20

-- Definiert die Reihenfolge, Breite UND Schriftgröße JEDER Spalte
local COLUMN_DEFINITION = {
    { title = "Name",      width = 150, align = "left",   dataKey = "name",      fontSize = 0.90 },
    { title = "Spielzeit", width = 80,  align = "center", dataKey = "spielzeit", fontSize = 0.90 },
    { title = "Status",    width = 120, align = "center", dataKey = "status",    fontSize = 0.90 },
    { title = "Telefon",   width = 90,  align = "center", dataKey = "telnr",     fontSize = 0.90 },
    { title = "Fraktion",  width = 120, align = "center", dataKey = "frak",      fontSize = 0.85 },
    { title = "Premium",   width = 80,  align = "center", dataKey = "paket",     fontSize = 0.80 },
    { title = "Level",     width = 55,  align = "center", dataKey = "level",     fontSize = 0.90 },
    { title = "Ping",      width = 75,  align = "center", dataKey = "ping",      fontSize = 0.90 },
}
local LIST_START_X = 325
local TOTAL_LIST_WIDTH = 785

-- ######################################################################
-- SKALIERUNGSFUNKTIONEN (Sichere, lokale Versionen)
-- ######################################################################

-- Original-Funktionen sichern
local _dxDrawLine = dxDrawLine
local _dxDrawRectangle = dxDrawRectangle
local _dxDrawText = dxDrawText
local _dxDrawImage = dxDrawImage

-- Skalierte Versionen
local function dxDrawLineS ( ... )
    local array = { ... }
    array[1] = array[1]*px
    array[2] = array[2]*py
    array[3] = array[3]*px
    array[4] = array[4]*py
    
    if array[6] then
        array[6] = array[6]*py -- Skaliert die Liniendicke
    end
    
    return _dxDrawLine ( unpack ( array ) )
end

local function dxDrawRectangleS ( ... )
    local array = { ... }
    array[1] = array[1]*px
    array[2] = array[2]*py
    array[3] = array[3]*px
    array[4] = array[4]*py
    return _dxDrawRectangle ( unpack ( array ) )
end

local function dxDrawTextS ( ... )
    local array = { ... }
    array[2] = array[2]*px -- left
    array[3] = array[3]*py -- top
    array[4] = array[4]*px -- right
    array[5] = array[5]*py -- bottom
    
    if array[7] then
        array[7] = array[7]*py -- Skaliert die Schriftgröße (scale)
    end
    return _dxDrawText ( unpack ( array ) )
end

local function dxDrawImageS ( ... )
    local array = { ... }
    array[1] = array[1]*px
    array[2] = array[2]*py
    array[3] = array[3]*px
    array[4] = array[4]*py
    return _dxDrawImage ( unpack ( array ) )
end

-- ######################################################################
-- GLOBALE VARIABLEN UND HELFERFUNKTIONEN
-- ######################################################################

local pl = {}
local scroll = 0
local player = localPlayer

local fraktionNames = { [-1]= "-", [0]= "Zivilist", [1]= "S.F.P.D", [2]= "Mafia", [3]= "Triaden", [4]= "Terroristen", [5]= "San News", [6]= "F.B.I", [7]= "Los Aztecas", [8]= "Bundeswehr", [9]= "Angels of Death", [10]= "Medic", [11]= "Mechaniker", [12]= "Ballas", [13]= "Grove",[14]= "Anonymus", [15]= "Fahrschule" }
local vipPackageName= {
    [1] = "Bronze",
    [2] = "Silber",
    [3] = "Gold",
    [4] = "Platin",
    [5] = "TOP DONATOR"
}

-- Farbtabelle für den Premium-Status
local vipPackageColors = {
    [0] = COLOR_TEXT_DIM, -- "Nicht Aktiv"
    [1] = tocolor(205, 127, 50, 255),  -- Bronze
    [2] = tocolor(192, 192, 192, 255), -- Silber
    [3] = tocolor(255, 215, 0, 255),  -- Gold
    [4] = tocolor(200, 200, 255, 255), -- Platin (helles blau/lila)
    [5] = tocolor(255, 0, 255, 255)   -- TOP DONATOR (Magenta)
}

function scrollDown()
    if #getElementsByType("player") - scroll <= 2 then
        scroll = #getElementsByType("player")
    else
        scroll = scroll + 2
    end
end

function scrollUp()
    if scroll <= 2 then
        scroll = 0
    else
        scroll = scroll - 2
    end
end
    
function formString(text)
    text = tostring(text) -- Sicherstellen, dass es ein String ist
    if string.len(text) == 1 then
        text = "0"..text
    end
    return text
end

-- KORRIGIERTE Logik
function getPingColor(ping)
    if (ping <= 100) then
        return 20, 200, 20 -- Grün
    elseif (ping <= 200) then
        return 255, 165, 0 -- Orange
    else
        return 200, 20, 20 -- Rot
    end
end

-- ######################################################################
-- TAB KEY HANDLER
-- ######################################################################

-- Scoreboard öffnen (TAB DOWN)
-- Fügen Sie diese Zeile am Anfang Ihres Client-Skripts (scoreboard.lua o.ä.) hinzu
-- isScoreboardWeaponControlDisabled = false 

-- Scoreboard öffnen (TAB DOWN)
bindKey("tab","down",function()
	if getElementData(localPlayer, "loggedin") == 1 and not loadingScreenShown then
		addEventHandler("onClientRender", root, drawScoreboard)
		updateScoreboard()
		if isTimer(updateTimer)then 
			killTimer(updateTimer) 
		end
		updateTimer = setTimer(updateScoreboard,100,0)
		bindKey("mouse_wheel_down","down",scrollDown)
		bindKey("mouse_wheel_up","down",scrollUp)
		if isControlEnabled ( "next_weapon" ) then
			elseif isControlEnabled ( "previous_weapon" ) then
			elseif isControlEnabled ( "fire" ) then
			elseif isControlEnabled ( "aim_weapon" ) then
			toggleControl("next_weapon",false)
			toggleControl("previous_weapon",false)
			toggleControl("fire",false)
			toggleControl("aim_weapon",false)
		end	
	end
end)



bindKey("tab","up",function()
	unbindKey("mouse_wheel_down","down",scrollDown)
	unbindKey("mouse_wheel_up","down",scrollUp)
	removeEventHandler("onClientRender", root, drawScoreboard)
	if isControlEnabled ( "next_weapon" ) then
		elseif isControlEnabled ( "previous_weapon" ) then
		elseif isControlEnabled ( "fire" ) then
		elseif isControlEnabled ( "aim_weapon" ) then
		toggleControl("next_weapon",true)
		toggleControl("previous_weapon",true)
		toggleControl("fire",true)
		toggleControl("aim_weapon",true)
	end
end)






-- ######################################################################
-- DATENVERARBEITUNG (Optimiert)
-- ######################################################################

function updateScoreboard()
    pl = {}
    local i = 1
    for id, p in pairs(getElementsByType("player")) do
        local name = getPlayerName(p)
        name = string.gsub(name,"#%x%x%x%x%x%x","")
        local spielzeit = "-"
        local nr = "-"
        local ping = getPlayerPing(p)
        local color = {255,255,255}
        local fname = "-"
        local frak = -1
        local status = "-"
        local r, g, b = 255, 255, 255
        local paketvip = 0
        local level = "-"
        local telenr = "-"
        
        -- adminlvl wird jetzt hier geholt und wiederverwendet
        local adminlvl = tonumber(getElementData(p, "adminlvl")) or 0
        
        if getElementData(p,"loggedin") == 1 then
            nr = tostring(getElementData ( p, "telenr" )) or "-"
            local ptime = tonumber(getElementData(p,"playingtime")) or 0
            local hour = math.floor(ptime/60)
            local minute = ptime - hour*60
            spielzeit = formString(hour)..":"..formString(minute)
            local fac = tonumber(getElementData(p,"fraktion")) or -1
            frak = fac
            -- adminlvl ist schon oben
            local rang = tonumber(getElementData(p, "rang"));
            level = tonumber(getElementData(p,"level")) or "-";
            paketvip = getElementData(p, "Paket") or 0
            
            -- Nil-Check für factionColors
            if factionColors and factionColors[fac] then
                r, g, b = factionColors[fac][1], factionColors[fac][2], factionColors[fac][3]
            end
            status = getElementData(p, "socialState") or "-";
        end
        
        -- Optimierte Admin-Namens-Prüfung
        if adminlvl >= 2 then
            -- Nil-Check für Tables
            if Tables and Tables.tablist then
                name = "["..Tables.tablist.."]"..name
            else
                name = "[Admin]"..name -- Fallback, falls 'Tables' nicht existiert
            end
        end
        
        
        pl[i] = {}
        pl[i].telnr = nr
        pl[i].name = name
        pl[i].adminlvl = adminlvl
        pl[i].level = level	
        pl[i].spielzeit = spielzeit
        pl[i].ping = ping
        pl[i].color = color
        pl[i].frak = frak
        pl[i].paket = paketvip
        pl[i].ping = ping;
        pl[i].status = status
        pl[i].r 	= r
        pl[i].g 	= g	
        pl[i].b 	= b
        i = i + 1

    end
    table.sort(pl, function(a,b)
        -- Sicherstellen, dass auch 'nil' oder ungültige Werte sortiert werden können
        local frakA = type(a.frak) == "number" and a.frak or -1
        local frakB = type(b.frak) == "number" and b.frak or -1
        return frakA < frakB
    end)	
end

-- ######################################################################
-- ZEICHNUNGSFUNKTION (MODERNISIERT & SKALIERT)
-- ######################################################################

function drawScoreboard()
    local rows_to_draw = 14
    local content_height = rows_to_draw * ROW_HEIGHT_UNIT
    local total_height = content_height + ROW_HEIGHT_UNIT
    local FOOTER_HEIGHT = 50 -- ERHÖHT: Mehr Platz für sauberen Text
    
    local current_x = LIST_START_X
    local current_y = 215

    -- Gesamtfenster Hintergrund (mit skalierter Funktion)
    dxDrawRectangleS(LIST_START_X, 215, TOTAL_LIST_WIDTH, total_height, COLOR_BG_DARK, false)

    -- HEADER BEREICH (Dunkler Hintergrund)
    dxDrawRectangleS(LIST_START_X, current_y, TOTAL_LIST_WIDTH, ROW_HEIGHT_UNIT, COLOR_HEADER, false)
    dxDrawLineS(LIST_START_X, current_y, LIST_START_X + TOTAL_LIST_WIDTH, current_y, COLOR_ACCENT, 1, false)	
    
    -- 1. HEADER ZEICHNEN
    current_x = LIST_START_X
    for _, col in ipairs(COLUMN_DEFINITION) do
        local next_x = current_x + col.width
        
        -- dxDrawTextS (skalierte Version)
        -- Header-Text ist wieder weiß
        dxDrawTextS(col.title, current_x, current_y, next_x, current_y + ROW_HEIGHT_UNIT, COLOR_TEXT_WHITE, 1.00, "default-bold", "center", "center", false, false, false, false, false)
        
        -- Leichter Trenner zwischen Spalten
        dxDrawRectangleS(next_x - 1, current_y, 1, total_height + FOOTER_HEIGHT, tocolor(255, 255, 255, 20), false)
        
        current_x = next_x
    end
    current_y = current_y + ROW_HEIGHT_UNIT


    -- 2. DATENZEILEN ZEICHNEN
    local di = 0
    
    for i = 1+scroll, rows_to_draw+scroll do
        
        if pl[i] then
            local playerData = pl[i]
            
            -- Hintergrund für Zeile (Alternierende Farbe)
            if di % 2 == 0 then
                dxDrawRectangleS(LIST_START_X, current_y, TOTAL_LIST_WIDTH, ROW_HEIGHT_UNIT, COLOR_BG_ROW, false)
            end
            
            local current_col_x = LIST_START_X
            
            -- Durchlaufe die Spaltendefinition, um die Daten in der richtigen Reihenfolge zu zeichnen
            for _, col in ipairs(COLUMN_DEFINITION) do
                local next_x = current_col_x + col.width
                local text = ""
                local text_color = COLOR_TEXT_WHITE
                local font = col.fontSize or 0.90 -- Schriftgröße aus Definition geholt
                local align = col.align
                
                -- Datenzuweisung und spezifisches Styling
                if col.dataKey == "name" then
                    text = playerData.name
                    if playerData.adminlvl >= 2 then
                        text_color = COLOR_ACCENT
                    end
                    align = "left"
                
                elseif col.dataKey == "frak" then
                    text = fraktionNames[playerData.frak] or "-"
                    text_color = tocolor(playerData.r, playerData.g, playerData.b, 255) 
                
                elseif col.dataKey == "ping" then
                    text = tostring(playerData.ping)
                    local r_ping, g_ping, b_ping = getPingColor(playerData.ping)
                    text_color = tocolor(r_ping, g_ping, b_ping, 255)
                
                elseif col.dataKey == "paket" then
                    text = playerData.paket == 0 and "Nicht Aktiv" or (vipPackageName[playerData.paket] or "Unbekannt")
                    -- Nutzt die farbige Tabelle
                    text_color = vipPackageColors[playerData.paket] or COLOR_TEXT_DIM
                    
                elseif col.dataKey == "spielzeit" then
                    text = playerData.spielzeit
                    text_color = COLOR_TEXT_DIM
                    
                else
                    -- Standard für Status, Telefon, Level
                    text = tostring(playerData[col.dataKey] or "-")
                    text_color = COLOR_TEXT_DIM
                end
                
                local padding_x = (col.dataKey == "name" and 3 or 0)
                
                -- dxDrawTextS (skalierte Version)
                dxDrawTextS(text, current_col_x + padding_x, current_y, next_x, current_y + ROW_HEIGHT_UNIT, text_color, font, "default", align, "center", false, false, false, false, false)
                
                current_col_x = next_x
            end

            current_y = current_y + ROW_HEIGHT_UNIT
            di = di + 1
        end
    end
    
    -- 3. FOOTER BEREICH (Überarbeitetes Layout - Font-Fix)
    local footer_y = 215 + total_height
    dxDrawRectangleS(LIST_START_X, footer_y, TOTAL_LIST_WIDTH, FOOTER_HEIGHT, tocolor(0, 0, 0, 194), false)
    dxDrawLineS(LIST_START_X, footer_y, LIST_START_X + TOTAL_LIST_WIDTH, footer_y, COLOR_ACCENT, 1, false)

    -- Y-Positionen für den neuen 50px-Footer
    local y_line_1 = footer_y + 9
    
	local text_size_large = 0.9 -- Deutlich größer

    -- Spieler Online (Links)
    dxDrawTextS("Spieler Online:", 328, y_line_1, 425, y_line_1 + 20, COLOR_TEXT_WHITE, text_size_large, "default-bold", "left", "top", false, false, false, false, false)
    dxDrawTextS(#getElementsByType("player"), 425, y_line_1, 455, y_line_1 + 20, COLOR_TEXT_WHITE, text_size_large, "default-bold", "left", "top", false, false, false, false, false)
end