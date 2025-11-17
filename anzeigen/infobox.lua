--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

Infobox = {}
local sx, sy = guiGetScreenSize()

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
    self.m_Width = 325
    self.m_Height = 100
    self.m_Height2 = 25
    self.m_PosX = sx - 5 - self.m_Width
    self.m_PosY = 300
    self.m_Alpha = 255
    --------------------------
    self.m_WidthNew = 325
    self.m_HeightNew = 100
    self.m_PosYNew = 325
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
    table.insert(self.m_Boxs, {
        -- Content
        title = title or "German "..Tables.servername.." Reallife",
        msg   = msg or "",
		
		
        -- Position
        posX = sx + 5,
        posY = self.m_PosY + (self.m_Height * #self.m_Boxs) + (10 * #self.m_Boxs),
        posYNew = self.m_PosY + (self.m_Height * #self.m_Boxs) + (20 * #self.m_Boxs),
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

            -- Body
            dxDrawRectangle(posX, box.posY, self.m_Width, self.m_Height2, tocolor(0, 0, 0, 200))
            dxDrawRectangle(posX, box.posY+25, self.m_Width, 75, tocolor(0, 0, 0, 160))

            -- Outline
            dxDrawLine(posX, box.posY, posX + self.m_Width, box.posY, tocolor(0, 105, 145, alpha))    
            dxDrawLine(posX, box.posY + 25, posX + self.m_Width, box.posY + 25, tocolor(0, 0, 0, alpha))    
            dxDrawLine(posX, box.posY + self.m_Height, posX + self.m_Width, box.posY + self.m_Height, tocolor(0, 0, 0, alpha))
            dxDrawLine(posX, box.posY, posX, box.posY + self.m_Height, tocolor(0, 0, 0, alpha))
            dxDrawLine(posX + self.m_Width, box.posY, posX + self.m_Width, box.posY + self.m_Height, tocolor(0, 0, 0, alpha))

            -- Content
            dxDrawText(box.title, posX, box.posY, posX + self.m_Width, box.posY + 25, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
            dxDrawText(box.msg, posX, box.posY + 25, posX + self.m_Width, box.posY + 25 + 75, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")

            -- Next state?
            if getTickCount() >= box.endTime then
                -- Update position
                box.posX = self.m_PosX
                box.alpha = self.m_Alpha

                -- Update times
                box.startTime = getTickCount()
                box.endTime = box.startTime + 4000 

                -- Update stage
                box.stage = 2
            end
        end
        
        -- Idle
        if box.stage == 2 then
            -- Body
            dxDrawRectangle(box.posX, box.posY, self.m_Width, self.m_Height2, tocolor(0, 0, 0, 200))
            dxDrawRectangle(box.posX, box.posY+25, self.m_Width, 75, tocolor(0, 0, 0, 160))
            ------------------------------------------------------------------------------------------

            -- Outline
            dxDrawLine(box.posX, box.posY, box.posX + self.m_Width, box.posY, tocolor(0, 105, 145, box.alpha))    
            dxDrawLine(box.posX, box.posY + 25, box.posX + self.m_Width, box.posY + 25, tocolor(0, 0, 0, box.alpha))    
            dxDrawLine(box.posX, box.posY + self.m_Height, box.posX + self.m_Width, box.posY + self.m_Height, tocolor(0, 0, 0, box.alpha))
            dxDrawLine(box.posX, box.posY, box.posX, box.posY + self.m_Height, tocolor(0, 0, 0, box.alpha))
            dxDrawLine(box.posX + self.m_Width, box.posY, box.posX + self.m_Width, box.posY + self.m_Height, tocolor(0, 0, 0, box.alpha))

            -- Content
            dxDrawText(box.title, box.posX, box.posY, box.posX + self.m_Width, box.posY + 25, tocolor(255, 255, 255, box.alpha), 1, "default-bold", "center", "center")
            dxDrawText(box.msg, box.posX, box.posY + 25, box.posX + self.m_Width, box.posY + 25 + 75, tocolor(255, 255, 255, box.alpha), 1, "default-bold", "center", "center")

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
            local alpha, posY, _ = interpolateBetween(box.alpha, box.posY, 0, 0, -self.m_Height - 5, 0, self:getProgress(idx), "Linear")

            -- Body
            dxDrawRectangle(box.posX, posY, self.m_Width, self.m_Height2, tocolor(0, 0, 0, 200))
            dxDrawRectangle(box.posX, posY+25, self.m_Width, 75, tocolor(0, 0, 0, 160))

            -- Outline
            dxDrawLine(box.posX, posY, box.posX + self.m_Width, posY, tocolor(0, 105, 145, alpha))    
            dxDrawLine(box.posX, posY + 25, box.posX + self.m_Width, posY + 25, tocolor(0, 0, 0, alpha))    
            dxDrawLine(box.posX, posY + self.m_Height, box.posX + self.m_Width, posY + self.m_Height, tocolor(0, 0, 0, alpha))
            dxDrawLine(box.posX, posY, box.posX, posY + self.m_Height, tocolor(0, 0, 0, alpha))
            dxDrawLine(box.posX + self.m_Width, posY, box.posX + self.m_Width, posY + self.m_Height, tocolor(0, 0, 0, alpha))

            -- Content
            dxDrawText(box.title, box.posX, posY, box.posX + self.m_Width, posY + 25, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
            dxDrawText(box.msg, box.posX, posY + 25, box.posX + self.m_Width, posY + 25 + 75, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")

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