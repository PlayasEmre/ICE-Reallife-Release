--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

Infobox = {}
local sx, sy = guiGetScreenSize()

local BODY_FONT  = "default-bold"
local BODY_SCALE = 1
local TITLE_SCALE = 1.05
local TEXT_PADDING = 24 -- links/rechts insgesamt (Akzentbalken + Luft)

-- Zaehlt, wie viele Zeilen ein Text braucht (harte \n UND automatischer Umbruch
-- durch die Boxbreite), damit die Boxhoehe vorher exakt berechnet werden kann.
local function countWrappedLines(text, maxWidth, scale, font)
    local lines = 0
    for line in (text.."\n"):gmatch("(.-)\n") do
        if line == "" then
            lines = lines + 1
        else
            local current = ""
            for word in line:gmatch("%S+") do
                local test = (current == "") and word or (current.." "..word)
                if current ~= "" and dxGetTextWidth(test, scale, font) > maxWidth then
                    lines = lines + 1
                    current = word
                else
                    current = test
                end
            end
            lines = lines + 1
        end
    end
    return math.max(lines, 1)
end

function Infobox.new(...)
    -- Create class instance
    local o = setmetatable({}, {__index = Infobox})

    -- Call constructor
    if o.constructor then
        o:constructor(...)
    end

    -- Return valid instance
    return o
end

function Infobox:constructor()
    -- Drawing
    self.m_fDraw = function(...) self:draw(...) end
    self.m_IsDrawing = false


    -- All infoboxes
    self.m_Boxs = {}

    -- Propertions
    self.m_Width = 340
    self.m_Height2 = 25 -- Titelleiste, fix
    self.m_PosX = sx - 5 - self.m_Width
    self.m_PosY = 300
    self.m_Alpha = 255

    -- add events
    addEvent("infobox_start", true)
    addEventHandler("infobox_start", root, function(...) self:create(...) end)
end

function Infobox:getProgress(idx)
	return (getTickCount() - self.m_Boxs[idx].startTime)/(self.m_Boxs[idx].endTime - self.m_Boxs[idx].startTime)
end


function Infobox:create(msg, time, r, g, b, title)
    -- Insert informations
    local now = getTickCount()
    msg = msg or ""

    -- Der Aufrufer meint mit "time" die gesamte sichtbare Dauer (inkl. Ein-/Ausblenden).
    -- Untergrenze, damit auch kurze Texte lesbar bleiben.
    local totalTime = tonumber(time) or 5000
    if totalTime < 5000 then totalTime = 5000 end
    local holdTime = totalTime - 1500
    if holdTime < 1500 then holdTime = 1500 end

    -- Akzentfarbe aus r,g,b - faellt auf ein dezentes Blau zurueck, wenn nichts uebergeben wurde.
    local accentR = tonumber(r) or 0
    local accentG = tonumber(g) or 150
    local accentB = tonumber(b) or 220

    -- Boxhoehe an den tatsaechlichen Text anpassen, damit auch laengere/mehrzeilige
    -- Texte (davon gibt's im Skript einige) sauber reinpassen statt ueberzulaufen.
    local maxTextWidth = self.m_Width - TEXT_PADDING
    local lineHeight = dxGetFontHeight(BODY_SCALE, BODY_FONT)
    local lineCount = countWrappedLines(msg, maxTextWidth, BODY_SCALE, BODY_FONT)
    local bodyHeight = math.max(75, lineCount * lineHeight + 22)
    local totalHeight = self.m_Height2 + bodyHeight

    -- Neue Box unter allen aktuell verfolgten Boxen stapeln (variable Hoehen!).
    local stackY = self.m_PosY
    for _, existingBox in ipairs(self.m_Boxs) do
        stackY = stackY + existingBox.totalHeight + 10
    end

    table.insert(self.m_Boxs, {
        -- Content
        title = title or "German "..Tables.servername.." Reallife",
        msg   = msg,
        accentR = accentR,
        accentG = accentG,
        accentB = accentB,
        holdTime = holdTime,
        bodyHeight = bodyHeight,
        totalHeight = totalHeight,

        -- Position
        posX = sx + 5,
        posY = stackY,
        alpha = 0,

        -- Animation
        startTime = now,
        endTime   = now + 750,
        stage = 1
    })

	sound = playSound(":"..getResourceName(getThisResource()).."/anzeigen/info.mp3",false)
	setSoundVolume(sound, 0.5)

    -- Enable drawing
    if not self.m_IsDrawing then
        self.m_IsDrawing = true
        addEventHandler("onClientRender", root, self.m_fDraw)
    end
end

-- Zeichnet Schlagschatten, Koerper, Akzentfarbe, Rahmen und Text (mit Textschatten)
-- einer Box. Wird von allen drei Phasen (Einblenden/Halten/Ausblenden) gemeinsam genutzt.
function Infobox:drawBoxBody(posX, posY, alpha, box)
    local accent = tocolor(box.accentR, box.accentG, box.accentB, alpha)
    local totalHeight = box.totalHeight
    local bodyHeight = box.bodyHeight

    -- Dezenter Schlagschatten fuer etwas Tiefe
    dxDrawRectangle(posX + 3, posY + 3, self.m_Width, totalHeight, tocolor(0, 0, 0, math.min(120, alpha)))

    -- Koerper
    dxDrawRectangle(posX, posY, self.m_Width, self.m_Height2, tocolor(20, 20, 20, math.min(225, alpha)))
    dxDrawRectangle(posX, posY + self.m_Height2, self.m_Width, bodyHeight, tocolor(15, 15, 15, math.min(195, alpha)))

    -- Farbiger Akzentbalken links, passend zur uebergebenen r,g,b-Farbe
    dxDrawRectangle(posX, posY, 4, totalHeight, accent)

    -- Rahmen
    dxDrawLine(posX, posY, posX + self.m_Width, posY, accent)
    dxDrawLine(posX, posY + self.m_Height2, posX + self.m_Width, posY + self.m_Height2, tocolor(0, 0, 0, alpha))
    dxDrawLine(posX, posY + totalHeight, posX + self.m_Width, posY + totalHeight, accent)
    dxDrawLine(posX, posY, posX, posY + totalHeight, tocolor(0, 0, 0, alpha))
    dxDrawLine(posX + self.m_Width, posY, posX + self.m_Width, posY + totalHeight, tocolor(0, 0, 0, alpha))

    -- Text mit dezentem Schatten fuer bessere Lesbarkeit
    local shadow = tocolor(0, 0, 0, alpha)
    local white  = tocolor(255, 255, 255, alpha)

    dxDrawText(box.title, posX + 1, posY + 1, posX + self.m_Width + 1, posY + self.m_Height2 + 1, shadow, TITLE_SCALE, "default-bold", "center", "center")
    dxDrawText(box.title, posX, posY, posX + self.m_Width, posY + self.m_Height2, accent, TITLE_SCALE, "default-bold", "center", "center")

    local bodyTop = posY + self.m_Height2
    local bodyBottom = bodyTop + bodyHeight
    dxDrawText(box.msg, posX + 1 + 8, bodyTop + 1, posX + self.m_Width + 1 - 8, bodyBottom + 1, shadow, BODY_SCALE, BODY_FONT, "center", "center", false, true)
    dxDrawText(box.msg, posX + 8, bodyTop, posX + self.m_Width - 8, bodyBottom, white, BODY_SCALE, BODY_FONT, "center", "center", false, true)
end

function Infobox:draw()
    -- Performance checks
    if #self.m_Boxs == 0 then
        self.m_IsDrawing = false
        removeEventHandler("onClientRender", root, self.m_fDraw)
    end


    -- Draw info boxes
    for idx, box in ipairs(self.m_Boxs) do
        -- Fade In
        if box.stage == 1 then
            -- Animation
            local alpha, posX, _ = interpolateBetween(box.alpha, box.posX, 0, self.m_Alpha, self.m_PosX, 0, self:getProgress(idx), "Linear")

            self:drawBoxBody(posX, box.posY, alpha, box)

            -- Next state?
            if getTickCount() >= box.endTime then
                -- Update position
                box.posX = self.m_PosX
                box.alpha = self.m_Alpha

                -- Update times
                box.startTime = getTickCount()
                box.endTime = box.startTime + box.holdTime

                -- Update stage
                box.stage = 2
            end
        end

        -- Idle
        if box.stage == 2 then
            self:drawBoxBody(box.posX, box.posY, box.alpha, box)

            -- Next level?
            if getTickCount() >= box.endTime then
                -- Update times
                box.startTime = getTickCount()
                box.endTime = box.startTime + 750

                -- Update stage
                box.stage = 3
            end
        end

        -- Fade Outline
        if box.stage == 3 then
             -- Animation
            local alpha, posY, _ = interpolateBetween(box.alpha, box.posY, 0, 0, -box.totalHeight - 5, 0, self:getProgress(idx), "Linear")

            self:drawBoxBody(box.posX, posY, alpha, box)

            if getTickCount() >= box.endTime then
                table.remove(self.m_Boxs, idx)
            end
        end
    end
end

addEvent("cdn:onClientReady", true)
addEventHandler("cdn:onClientReady", resourceRoot,
    function()
        g_InfoBox = Infobox.new()

        -- Vio FIX
        function infobox_start_func(...)
            g_InfoBox:create(...)
        end
    end
)
