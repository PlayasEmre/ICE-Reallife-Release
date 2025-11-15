--|**********************************************************************
--|* Project           : Reallife
--|* Author            : n0pe
--|* Date created      : 31.03.2020
--|**********************************************************************

local Levelsystem = {}

function Levelsystem.new(...)
    local o = setmetatable({}, { __index = Levelsystem })
    if o.constructor then
        o:constructor(...)
    end
    return o
end

function Levelsystem:constructor()
    self.m_EXP = 100 --> EXP * Level
    self.m_MaxLevel = 30 --> Max Level

    givePlayerEXP = function(...) self:addEXP(...) end
    addCommandHandler("showLevel", function(...) self:showLevel(...) end)
end

function Levelsystem:addEXP(player, exp)
    assert(type(player) == "userdata", "Bad argument @ Levelsystem:addEXP #1")
    assert(type(exp) == "number", "Bad argument @ Levelsystem:addEXP #2")
    MtxSetElementData(player, "exp", MtxGetElementData(player, "exp") + math.floor(exp))

    local neededEXP = self.m_EXP * MtxGetElementData(player, "level")
    if MtxGetElementData(player, "exp") >= neededEXP then
        if MtxGetElementData(player, "level") < self.m_MaxLevel then
            MtxSetElementData(player, "exp", 0)
            MtxSetElementData(player, "level", MtxGetElementData(player, "level") + 1)
            player:triggerEvent("infobox_start", player, "Dein Level hat sich erhöht! Aktuelles Level: " .. MtxGetElementData(player, "level"), 5000, 0, 120, 0)
        end
    end
end

function Levelsystem:showLevel(player)
    player:outputChat(("Dein aktuelles Level: %d, Deine aktuellen EXP: %d / %d"):format(MtxGetElementData(player, "level"), MtxGetElementData(player, "exp"), self.m_EXP * MtxGetElementData(player, "level")), 255, 255, 0)
end

Levelsystem.new()

function levelshop(player)
	if MtxGetElementData(player, "level") >= 5 and MtxGetElementData(player, "levelshop1") == 0 then
		MtxSetElementData(player, "money", MtxGetElementData(player, "money") + 30000)
		outputChatBox("Du hast 30.000€ erhalten für das erreichen von Level 5!",player,255,255,0)
		MtxSetElementData(player,"levelshop1",1)
		datasave_remote(player)
	else
		outputChatBox("Du hast bereits deine Belohnung schon erhalten",player,255,255,255)
	end
end
addEvent("levelshop", true)
addEventHandler("levelshop",root,levelshop)

function levelshop2(player)
	if MtxGetElementData(player, "level") >= 10 and MtxGetElementData(player, "levelshop2") == 0 then
		setPremiumData(player,30,3)
		outputChatBox("Du hast Premuim Gold Für 1 Monat erhalten für das erreichen von Level 10!",player,255,255,255)
		MtxSetElementData(player,"levelshop2",1)
		datasave_remote(player)
	else
		outputChatBox("Du hast bereits deine Belohnung schon erhalten",player,255,255,255)
	end
end
addEvent("levelshop2", true)
addEventHandler("levelshop2",root,levelshop2)

function levelshop3(player)
	if MtxGetElementData(player, "level") >= 20 and MtxGetElementData(player, "levelshop3") == 0 then
		outputChatBox("Du hast 250 Coins erhalten für das erreichen von Level 20!",player,255,255,255)
		MtxSetElementData(player, "coins", MtxGetElementData(player, "coins") + 250)
		MtxSetElementData(player,"levelshop3",1)
		datasave_remote(player)
	else
		outputChatBox("Du hast bereits deine Belohnung schon erhalten",player,255,255,255)
	end
end
addEvent("levelshop3", true)
addEventHandler("levelshop3",root,levelshop3)

function levelshop4(player)
	if MtxGetElementData(player, "level") >= 30 and MtxGetElementData(player, "levelshop4") == 0 then
		-- code ?
		MtxSetElementData(player,"levelshop4",1)
		datasave_remote(player)
    else
		outputChatBox("Du hast bereits deine Belohnung schon erhalten",player,255,255,255)
	end
end
addEvent("levelshop4", true)
addEventHandler("levelshop4",root,levelshop4)