--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local atman = true
local atman2 = true
local atman3 = true
local atman4 = true

function atmhack (player)

	if not Aktiondeaktivieren then
		infobox ( player, "Gerade ist es nicht möglich einen Geldautomaten zu starten", 5000, 150, 0, 0 )
		return
	end

    if isAnonymus(player) then
	    if getElementType(player) == "player" and  getPedOccupiedVehicle ( player ) == false and getDistanceBetweenPoints3D ( -1981.2060546875, 145.07421875, 27.6875, getElementPosition (player) ) < 5 then
		    if not atman then
			    outputChatBox("Der Geldautomat wurde vor kurzem berreits gehackt !", player, 200, 0, 0)
				outputChatBox("Anonymus versuchten einen Geldautomaten zu hacken (Bahnhof)!", getRootElement(), 200, 0, 0)
				return
		    end
			
			
			atman = false	
			
		    setTimer(function ()
			    atman = true
		    end, 10*60*1000, 1)	
			setElementFrozen(player,true)
			setPedAnimation(player, "bomber", "BOM_Plant_Loop", -1, true, false, false)			
            outputChatBox("Anonymus haben zugeschlagen und versuchen den Geldautomaten(Bahnhof) zu hacken!", getRootElement(), 200, 0, 0)	
            outputChatBox("In 1 Minuten hast du es geschafft !", player, 200, 0, 0)	
            setPlayerWantedLevel(player, 2)	
            MtxSetElementData(player, "wanteds", 2)				
		    totimer1 = setTimer(function ()			
				local geldm = math.random(500, 3000)
				setPedAnimation(player)
				setElementFrozen(player,false)
				local money = MtxGetElementData (player, "money")
				MtxSetElementData (player, "money", money + geldm)
            	outputChatBox("Du hast den Geldautomaten erfolgreich gehackt und erhälst "..geldm..""..Tables.waehrung.."!", player, 200, 0, 0)
		    end,1*60*1000,1)			
        
		end	
    else
        outputChatBox("Du bist kein Mitglied der Anonymus!", player, 255, 0, 0)	
	end
end
addCommandHandler("hackbhf", atmhack)

function atmnoob (player)

	if not Aktiondeaktivieren then
		infobox ( player, "Gerade ist es nicht möglich einen Geldautomaten zu starten", 5000, 150, 0, 0 )
		return
	end

    if isAnonymus(player) then
	    if getElementType(player) == "player" and getPedOccupiedVehicle ( player ) == false and getDistanceBetweenPoints3D ( -2453.7058105469,754.22961425781,35.171875, getElementPosition (player) ) < 5 then
		    if not atman2 then
			    outputChatBox("Der Geldautomat wurde vor kurzem berreits gehackt !", player, 200, 0, 0)
				outputChatBox("Anonymus versuchten einen Geldautomaten zu hacken (Noobspawn)!", getRootElement(), 200, 0, 0)
				return
		    end
			
			atman2 = false	
			
		    setTimer(function ()
			    atman2 = true
		    end, 10*60*1000, 1)	
			setElementFrozen(player,true)
			setPedAnimation(player, "bomber", "BOM_Plant_Loop", -1, true, false, false)			
            outputChatBox("Anonymus haben zugeschlagen und versuchen den Geldautomaten(Noobspawn) zu hacken!", getRootElement(), 200, 0, 0)	
            outputChatBox("In 1 Minute hast du es geschafft !", player, 200, 0, 0)	
            setPlayerWantedLevel(player, 2)	
            MtxSetElementData(player, "wanteds", 2)				
		    totimer2 = setTimer(function ()			
				local geldh = math.random(500, 3000)
				setPedAnimation(player)
				setElementFrozen(player,false)
				local money = MtxGetElementData (player, "money")
				MtxSetElementData (player, "money", money + geldh)
            	outputChatBox("Du hast den Geldautomaten erfolgreich gehackt und erhälst "..geldh.."$!", player, 200, 0, 0)
		    end, 1*60*1000,1)			
        
		end	
    else
        outputChatBox("Du bist kein Mitglied der Anonymus!", player, 255, 0, 0)	
	end
end
addCommandHandler("hacknoob", atmnoob)

function atmstadt (player)

	if not Aktiondeaktivieren then
		infobox ( player, "Gerade ist es nicht möglich einen Geldautomaten zu starten", 5000, 150, 0, 0 )
		return
	end

    if isAnonymus(player) then
	    if getElementType(player) == "player" and getPedOccupiedVehicle ( player ) == false and getDistanceBetweenPoints3D ( -2037.6707763672,451.59509277344,35.172294616699, getElementPosition (player) ) < 5 then
		    if not atman3 then
			    outputChatBox("Der Geldautomat wurde vor kurzem berreits gehackt !", player, 200, 0, 0)
				outputChatBox("Anonymus versuchten einen Geldautomaten zu hacken (Stadthalle)!", getRootElement(), 200, 0, 0)
				return
		    end
			
			atman3 = false	
			
		    setTimer(function ()
			    atman3 = true
		    end, 10*60*1000, 1)	
			setElementFrozen(player,true)
			setPedAnimation(player, "bomber", "BOM_Plant_Loop", -1, true, false, false)			
            outputChatBox("Anonymus haben zugeschlagen und versuchen den Geldautomaten(Stadthalle) zu hacken!", getRootElement(), 200, 0, 0)	
            outputChatBox("In 1 Minute hast du es geschafft !", player, 200, 0, 0)	
            setPlayerWantedLevel(player, 2)	
            MtxSetElementData(player, "wanteds", 2)			
		    totimer3 = setTimer(function ()			
				local geldg = math.random(500, 3000)
				setPedAnimation(player)
				setElementFrozen(player,false)
				local money = MtxGetElementData (player, "money")
				MtxSetElementData (player, "money", money + geldg)	
            	outputChatBox("Du hast den Geldautomaten erfolgreich gehackt und erhälst "..geldg..""..Tables.waehrung.."!", player, 200, 0, 0)
		    end, 1*60*1000,1)			
        
		end	
    else
        outputChatBox("Du bist kein Mitglied der Anonymus!", player, 255, 0, 0)	
	end
end
addCommandHandler("hackstadt", atmstadt)

function atmpay (player)

	if not Aktiondeaktivieren then
		infobox ( player, "Gerade ist es nicht möglich einen Geldautomaten zu starten", 5000, 150, 0, 0 )
		return
	end

    if isAnonymus(player) then
	    if getElementType(player) == "player" and getPedOccupiedVehicle ( player ) == false and getDistanceBetweenPoints3D ( -1967.7807617188,296.15774536133,35.171875, getElementPosition (player) ) < 5 then
		    if not atman4 then
			    outputChatBox("Der Geldautomat wurde vor kurzem berreits gehackt !", player, 200, 0, 0)
				outputChatBox("Anonymus versuchten einen Geldautomaten zu hacken (wangcars)!", getRootElement(), 200, 0, 0)
				return
		    end
			
			atman4 = false	
			
		    setTimer(function ()
			    atman4 = true
		    end, 10*60*1000, 1)	
			setElementFrozen(player,true)
			setPedAnimation(player, "bomber", "BOM_Plant_Loop", -1, true, false, false)			
            outputChatBox("Anonymus haben zugeschlagen und versuchen den Geldautomaten(wangcars) zu hacken!", getRootElement(), 200, 0, 0)	
            outputChatBox("In 1 Minute hast du es geschafft !", player, 200, 0, 0)	
            setPlayerWantedLevel(player, 2)	
            MtxSetElementData(player, "wanteds", 2)				
		    totimer4 = setTimer(function ()			
				local geldf = math.random(500, 3000)
				setPedAnimation(player)
				setElementFrozen(player,false)
				local money = MtxGetElementData (player, "money")
				MtxSetElementData (player, "money", money + geldf)
            	outputChatBox("Du hast den Geldautomaten erfolgreich gehackt und erhälst "..geldf..""..Tables.waehrung.."!", player, 200, 0, 0)
		    end, 1*60*1000,1)			
        
		end	
    else
        outputChatBox("Du bist kein Mitglied der Anonymus!", player, 255, 0, 0)	
	end
end
addCommandHandler("hackwangcars", atmpay)


addEventHandler("onPlayerWasted", getRootElement(), function()
    if isTimer ( totimer1 ) then
		killTimer ( totimer1 )
	end
end)

addEventHandler("onPlayerWasted", getRootElement(), function()
    if isTimer ( totimer2 ) then
		killTimer ( totimer2 )
	end
end)

addEventHandler("onPlayerWasted", getRootElement(), function()
    if isTimer ( totimer3 ) then
		killTimer ( totimer3 )
	end
end)

addEventHandler("onPlayerWasted", getRootElement(), function()
    if isTimer ( totimer4 ) then
		killTimer ( totimer4 )
	end
end)

function handy_hack(player, cmd, pplayer)
    if isAnonymus(player) then
	    local target = getPlayerFromName(pplayer)
	    if isElement ( target ) then
		    local target = getPlayerFromName(pplayer)
			if MtxGetElementData ( target, "handystate" ) == "on" then
			    MtxSetElementData ( target, "handystate", "off" )
				outputChatBox ( "Du hast das Handy des Spielers gehackt und ausgeschaltet!", player, 125, 0, 0 )
			else
			    MtxSetElementData ( target, "handystate", "on" )
				outputChatBox ( "Du hast das Handy des Spielers gehackt und angeschaltet!!", player, 125, 0, 0 )
			end
		else
		    outputChatBox ( "Ungültiger Spieler!", player, 125, 0, 0 )
		end
	else
	    outputChatBox ( "Du bist kein Mitglied der Anonymus!", player, 125, 0, 0 )
	end
end
addCommandHandler("hackhandy", handy_hack)

function clear_ghost ( player, cmd, target )
	if player == client or not client then
		if isAnonymus(player) then
		if timeStadt == nil or timeStadt ~= nil and getTickCount() - timeStadt >= 600000  then
			local target = getPlayerFromName( target )
			if getElementType ( target ) == "player" and MtxGetElementData ( target, "loggedin" ) == 1 then
			    timeStadt = getTickCount()
				MtxSetElementData ( target, "wanteds", 0 )
				setPlayerWantedLevel ( target, 0 )
				outputChatBox ( "Du hast "..getPlayerName(target).." eine neue Identität verschafft!", player,255, 255, 0 )
				outputChatBox ( "Anonymus "..getPlayerName(player).." hat dir eine neue Identität verschafft, du wirst nun nicht mehr gesucht! ", target, 255, 255, 0 )			
			else
				triggerClientEvent ( player, "infobox_start", getRootElement(), "\nUngueltiger\nSpieler!", 5000, 125, 0, 0 )
			end
			else
			   outputChatBox("Du musst noch " .. 10 - math.ceil((getTickCount() - timeStadt) / 600000 ) .. " Minuten warten!", player, 125, 0, 0)
		   end
	   end
	end
end
addCommandHandler("hackwanteds", clear_ghost)