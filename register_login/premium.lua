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

vipPackageSocialTime= {
    [1] = (604800*4),
    [2] = (604800*2),
    [3] = (604800*1),
    [4] = 86400,
    [5] = 60
}

vipPackageTeleTime= {
    [1] = (604800*4),
    [2] = (604800*2),
    [3] = (604800*1),
    [4] = 86400,
    [5] = 60
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
    if PremiumData ~= 0 then
        if PremiumData >= timesamp then
            if paket > 0  then
                outputChatBox ( "Premium: Aktiv. Bis zum "..getData (PremiumData), player, 0, 125, 0,true )
                outputChatBox ( "Paket: "..vipPackageName[paket], player, 0, 125, 0,true )
				outputChatBox ( "Gib /premium ein um dein Premium Panel zu oeffnen.", player, 0, 125, 0, true)
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
        outputChatBox("/premstatus - Ändert deinen Status - Alle "..math.floor(vipPackageSocialTime[paket]/86400).." Tag(e) möglich.", player, 0, 125, 0)
        outputChatBox("/tele - Ändert deine Nummer - Alle "..math.floor(vipPackageTeleTime[paket]/86400).." Tag(e) möglich.", player, 0, 125, 0)
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

function changeSocial ( player, cmd , ... )
    local paket = tonumber(MtxGetElementData ( player, "Paket" ))
    local parametersTable = {...}
    local rt = table.concat( parametersTable, " " )
    local words = string.len(rt)
    if MtxGetElementData ( player, "premium" ) == true then
        if MtxGetElementData ( player, "lastSocialChange") < timesamp then
            if words >= 1 then
                if words <= 16 then
                    MtxSetElementData ( player, "socialState", rt )
                    outputChatBox ( "Status zu "..rt.." geändert.", player, 0, 125, 0 )
                    MtxSetElementData ( player, "lastSocialChange", timesamp + (vipPackageSocialTime[paket]) )
                    outputChatBox ( "Du kannst deinen Status am "..getData(timesamp + (vipPackageSocialTime[paket])).." wieder ändern.", player, 0, 125, 0 )
                else
                    outputChatBox("Zuviele Zeichen, es sind maximal 16 erlaubt. (Leerzeichen zählen mit)", player, 255, 155, 0 )
                end
            else
                outputChatBox("Zuwenig Zeichen, es ist minimal eins erlaubt. (Leerzeichen zählen mit)", player, 255, 155, 0 )

            end
        else
            outputChatBox ( "Du kannst deinen Status am "..getData(timesamp + (vipPackageSocialTime[paket])).." wieder ändern.", player, 0, 125, 0 )
        end
    else
        outputChatBox("Du bist kein Premium User." , player, 0, 200, 0 )
    end
end
addCommandHandler("premstatus", changeSocial )


function changeNumber ( player, cmd, number )
    local paket = tonumber(MtxGetElementData ( player, "Paket" ))
    if MtxGetElementData ( player, "premium" ) == true then
        if MtxGetElementData ( player, "lastNumberChange") < timesamp then
            if tonumber(number) then
                if tonumber(number) >= 100 then
                    if tonumber(number) <= 9999999 then
                        if tonumber ( number ) ~= 911 and tonumber ( number ) ~= 333 and tonumber ( number ) ~= 400 and tonumber (number ) ~= 666666 then
                            if not dbExist ( "userdata", "Telefonnr LIKE '"..number.."'") then
                                dbExec ( handler, "UPDATE ?? SET ??=? WHERE ??=?", "userdata", "Telefonnr", number, "UID", playerUID[getPlayerName(player)] )
                                MtxSetElementData ( player, "telenr", number )
                                outputChatBox ( "Nummer zu "..number.." geändert.", player, 0, 125, 0 )
                                MtxSetElementData ( player, "lastNumberChange", timesamp + (vipPackageTeleTime[paket]) )
                                outputChatBox ( "Du kannst deine Nummer am "..getData(timesamp + (vipPackageTeleTime[paket])).." wieder ändern.", player, 0, 125, 0 )
                            else
                                outputChatBox("Ungültige Nummer." , player, 255, 155, 0 )
                            end
                        else
                            outputChatBox("Diese Nummer gibt es bereits." , player, 255, 155, 0 )
                        end
                    else
                        outputChatBox("Deine Nummer ist zu groß." , player, 255, 155, 0 )
                    end
                else
                    outputChatBox("Deine Nummer muss über 99 sein." , player, 255, 155, 0 )
                end

            else
                outputChatBox("/tele [deine gewünschte Nummer]" , player, 255, 155, 0 )
            end
        else
            outputChatBox ( "Du kannst deine Nummer am "..getData(timesamp + (vipPackageTeleTime[paket])).." wieder ändern.", player, 255, 155, 0 )
        end
    else
        outputChatBox("Du bist kein Premium User." , player, 255, 155, 0 )
    end
end
addCommandHandler("tele", changeNumber )


function changeCar ( player, cmd, slot, id)
    local pname = getPlayerName(player)
    if MtxGetElementData ( player, "PremiumCars" ) >= 1 then
        if not changeCarLockedIDs[id] then
            if getVehicleNameFromModel(id) then
                local result = dbPoll ( dbQuery ( handler, "SELECT  ?? FROM ?? WHERE ??=? AND ??=?? ", "Typ", "vehicles", "Slot", slot, "UID", playerUID[pname] ), -1 )
                if result and result[1] then
                    dbExec ( handler, "UPDATE ?? SET ??=? WHERE ??=? AND ??=??", "vehicles", "Typ", id, "Slot", slot, "UID", playerUID[pname] )
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
addCommandHandler("pcar", changeCar )

function giveFreePremiumCar ( player )
    local paket = tonumber(MtxGetElementData ( player, "Paket" ))
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