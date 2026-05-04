--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local Jetpack = {"brassknuckle","golfclub","nightstick","knife","bat","shovel","poolstick","katana","chainsaw","dildo","vibrator","flower","cane","grenade","teargas","molotov","colt 45","silenced","deagle","shotgun","sawed-off","combat shotgun","uzi","mp5","ak-47","m4","tec-9","rifle","sniper","rocket launcher","rocket launcher hs","flamethrower","minigun","satchel","bomb","spraycan","fire extinguisher","camera","nightvision","infrared"}
local notallowedcharacter = {" ","ä","ü","ö",",","#","'","+","*","~",":",";","=","}","?","\\","{","&","/","§","\"","!","°","@","|","`","´","<",">","none","keiner","niemand","niemandem","scheiss","adolf","hitler","server","german","roleplay","vio","ekonomie","eko","sunrise","coa","deltroyz","exo","ultimate","vnx","venox","neon","nova","touch","reallife","matrix","astro","gur","sex"}

-- Serverseitiger Timer für alle Spieler
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        if MtxGetElementData(player, "loggedin") == 1 then
            local dataList = {"coins", "money", "bankmoney", "drugs", "bonuspoints", "exp", "level"}
            for _, stat in ipairs(dataList) do
                local value = tonumber(MtxGetElementData(player, stat))
                if value and value >= 100000000 then
                    MtxSetElementData(player, stat, 0)
                    return banVioShieldPlayer(player, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen ("..stat..")")
                end
            end
        end
    end
end, 5000, 0)

-- Waffen-Sicherheitsschutz
local NotAllowedWeapons = {[38] = true, [37] = true, [18] = true, [39] = true}

addEventHandler("onPlayerWeaponFire", getRootElement(), function(weaponID)
    if NotAllowedWeapons[weaponID] then
        local adminLevel = tonumber(MtxGetElementData(source, "adminlvl")) or 0
        if adminLevel == 0 then
            takeAllWeapons(source)
            kickPlayer(source, "Anticheat", "Waffen-Betrug ist nicht erlaubt!")
        end
    end
end)

-- Cooldown-Tabelle gegen Spam
local playerCooldown = {}

addEvent("waffenkick", true)
addEventHandler("waffenkick", root, function(typ)
    local currentTime = getTickCount()
    
    -- Überprüfen, ob der Spieler innerhalb der letzten 5 Sekunden dieses Event gefeuert hat
    if playerCooldown[client] and currentTime - playerCooldown[client] < 5000 then
        return -- Spam-Versuch abbrechen
    end
    
    playerCooldown[client] = currentTime
    
    outputChatBox(getPlayerName(client).." wurde wegen "..typ.." cheating gekickt!", root, 255, 0, 0)
    takeAllWeapons(client)
    kickPlayer(client, "Anticheat", typ.." Betrug ist nicht erlaubt!")
end)

-- Sicherheitssystem bei der Verbindung
addEventHandler("onPlayerConnect", getRootElement(), function(ni, ip, uni, se, ver)
    for _, v in ipairs(notallowedcharacter) do
        if string.find(string.lower(ni), v) then
            cancelEvent(true, "Es sind keine Sonderzeichen, Farbcodes, Clantags oder Servernamen erlaubt!")
        end
    end
end)

-- Jetpack-Waffen-Sicherheit
addEventHandler("onResourceStart", resourceRoot, function()
    for _, v in ipairs(Jetpack) do
        setJetpackWeaponEnabled(v, false)
        setJetpackMaxHeight(5000)
    end
end)