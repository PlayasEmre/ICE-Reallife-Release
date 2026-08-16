--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

vipPackageName= {
    [1] = "Bronze",
    [2] = "Silber",
    [3] = "Gold",
    [4] = "Platin",
    [5] = "TOP DONATOR"
}

vipPackagePremCarGive= {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = true,
    [5] = true
}

vipPackagePremCarGiveTime= {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 604800,
    [5] = 604800/2
}

vipPayDayExtra= {
    [0] = 0,
    [1] = 50,
    [2] = 100,
    [3] = 150,
    [4] = 200,
    [5] = 300
}

changeCarLockedIDs = {
	["432"] = true,
	["476"] = true,
	["447"] = true,
	["464"] = true,
	["425"] = true,
	["520"] = true
}

local rt = getRealTime()
local timesamp = rt.timestamp


function checkPremium ( player )
    local PremiumData = MtxGetElementData ( player, "PremiumData" )
    local paket = MtxGetElementData ( player, "Paket" )
    local pname = getPlayerName(player)
    local realtimeNow = getRealTime()
    local timesamp = realtimeNow.timestamp
    if PremiumData ~= 0 then
        if PremiumData >= timesamp then
            if paket > 0  then
                outputChatBox ( "Premium: Aktiv. Bis zum "..getData (PremiumData), player, 0, 125, 0,true )
                outputChatBox ( "Paket: "..vipPackageName[paket], player, 0, 125, 0,true )
				outputChatBox ( "Gib /premium ein um dein Premium Panel zu oeffnen.", player, 0, 125, 0, true)
				outputChatBox ("Gib /phelp ein, um deine weiteren Optionen zu sehen.", player, 0, 125, 0, true)
                MtxSetElementData ( player, "premium", true )
            else
                outputChatBox("Premium-Status: Paket nicht gefunden, bitte Projektleiter kontaktieren.", player, 125, 0, 0)
                MtxSetElementData ( player, "premium", false )
            end

        else
            outputChatBox("Premium-Status: Abgelaufen.", player, 125, 0, 0)
            dbExec ( handler, "UPDATE ?? SET ??=?, ??=? WHERE ??=?", "userdata", "PremiumPaket", 0, "PremiumData", 0,  "UID", playerUID[pname] )
            MtxSetElementData ( player, "PremiumData", 0 )
            MtxSetElementData ( player, "Paket", 0 )
            MtxSetElementData ( player, "premium", false )
        end
    else
        outputChatBox("Premium-Status: Nicht Aktiv.", player, 125, 0, 0)
        dbExec ( handler, "UPDATE ?? SET ??=?, ??=? WHERE ??=?", "userdata", "PremiumPaket", 0, "PremiumData", 0,  "UID", playerUID[pname] )
        MtxSetElementData ( player, "PremiumData", 0 )
        MtxSetElementData ( player, "Paket", 0 )
        MtxSetElementData ( player, "premium", false )
    end
end

function showPremiumFunctions (player)
    if MtxGetElementData ( player, "premium" ) == true then
        local paket = MtxGetElementData ( player, "Paket" )
        outputChatBox("Status und Telefonnummer aenderst du im Webpanel (Reiter 'Coins').", player, 0, 125, 0)
        outputChatBox("/pcar [SLOT] [ID] - Setzt dir ein Premium Fahrzeug. (Verfügbar:  "..MtxGetElementData(player,"PremiumCars")..")", player, 0, 125, 0)
        outputChatBox("Sonstige Features:", player, 0, 125, 0)
        if vipPackagePremCarGive[paket] == true then
            outputChatBox("Alle "..math.floor(vipPackagePremCarGiveTime[paket]/86400).."  Tag(e) ein gratis Premium Fahrzeug.", player, 0, 125, 0)
        end
        if vipPayDayExtra[paket] > 0 then
            outputChatBox(vipPayDayExtra[paket].."% mehr unversteurte Einnahmen beim Payday.", player, 0, 125, 0)
        end
    else
        triggerClientEvent ( player, "infobox_start", getRootElement(), "\nDu bist\nnicht befugt!", 7500, 125, 0, 0 )
    end
end
addCommandHandler("phelp", showPremiumFunctions )


function setPremiumData (player, tage,package)
    local pname = getPlayerName(player)
    local PremiumData = tonumber(MtxGetElementData ( player, "PremiumData" ))
    local rt = getRealTime()
    local timesamp = rt.timestamp
    MtxSetElementData ( player, "Paket", tonumber(package) )
    MtxSetElementData ( player, "PremiumData", timesamp+86400*tage )
    dbExec ( handler, "UPDATE ?? SET ??=?, ??=? WHERE ??=?", "userdata", "PremiumPaket", package, "PremiumData", timesamp+86400*tage,  "UID", playerUID[pname] )
    checkPremium ( player )
end

-- /premstatus aendert nichts mehr direkt - Status kann nur noch im
-- Webpanel (Coins-Bereich) geaendert werden, damit es dort Coins kostet.
function changeSocial ( player, cmd , ... )
    outputChatBox("Deinen Status aenderst du jetzt im Webpanel (Reiter 'Coins').", player, 255, 155, 0 )
end
addCommandHandler("premstatus", changeSocial )


-- /tele aendert nichts mehr direkt - Telefonnummer kann nur noch im
-- Webpanel (Coins-Bereich) geaendert werden, damit es dort Coins kostet.
function changeNumber ( player, cmd, number )
    outputChatBox("Deine Telefonnummer aenderst du jetzt im Webpanel (Reiter 'Coins').", player, 255, 155, 0 )
end
addCommandHandler("tele", changeNumber )


function changeCar ( player, cmd, slot, id)
    local pname = getPlayerName(player)
    if MtxGetElementData ( player, "PremiumCars" ) >= 1 then
        if not changeCarLockedIDs[id] then
            if getVehicleNameFromModel(id) then
                local result = dbQueryCoro ( "SELECT  ?? FROM ?? WHERE ??=? AND ??=? ", "Typ", "vehicles", "Slot", slot, "UID", playerUID[pname] )
                if result and result[1] then
                    dbExec ( handler, "UPDATE ?? SET ??=? WHERE ??=? AND ??=?", "vehicles", "Typ", id, "Slot", slot, "UID", playerUID[pname] )
                    outputChatBox ( "Slot "..slot.." zum ID: "..id.." geändert.", player, 0, 125, 0 )
                    MtxSetElementData ( player, "PremiumCars", MtxGetElementData ( player, "PremiumCars" ) - 1 )
                else
                    outputChatBox("Du besitzt kein Fahrzeug in diesem Slot." , player, 255, 155, 0 )
                end
            else
                outputChatBox("Ungültiges Fahrzeug Slot zum ID" , player, 255, 155, 0 )
            end
        else
            outputChatBox("Du darfst dir kein "..getVehicleNameFromModel(id).." geben." , player, 255, 155, 0 )
        end
    else
        outputChatBox("Du kannst momentan keine Premium Fahrzeuge setzen." , player, 255, 155, 0 )
    end
end
addCommandHandler("pcar", function ( player, cmd, slot, id ) runAsync ( changeCar, player, cmd, slot, id ) end )

function giveFreePremiumCar ( player )
    local paket = tonumber(MtxGetElementData ( player, "Paket" ))
    local realtimeNow = getRealTime()
    local timesamp = realtimeNow.timestamp
    if MtxGetElementData ( player, "premium" ) == true then
        if vipPackagePremCarGive[paket] == true then
            if MtxGetElementData ( player, "lastPremCarGive" ) < timesamp then
                MtxSetElementData ( player, "PremiumCars", MtxGetElementData ( player, "PremiumCars" ) + 1 )
                MtxSetElementData ( player, "lastPremCarGive", timesamp + (vipPackagePremCarGiveTime[paket]) )
                outputChatBox ( "Aufgrund deines Premium Paketes hast du ein gratis Premium Fahrzeug erhalten.", player, 0, 125, 0 )
                outputChatBox ( "Das nächste Premium Fahrzeug bekommst du, wenn dein Premium aktiv ist, am ", player, 0, 125, 0 )
                outputChatBox ( getData(timesamp + (vipPackagePremCarGiveTime[paket])), player, 0, 125, 0 )
            end
        end
    end
end