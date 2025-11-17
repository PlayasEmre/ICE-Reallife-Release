--//                                                               \\
--||  Project: MTA - German ICE Reallife Gamemode    ||
--||  Developers: PlayasEmre                         ||
--||  Version: 5.0                                   ||
--\\                                                               //

function drawSpeedo()
	if isPedInVehicle(localPlayer) then
		local veh = getPedOccupiedVehicle(localPlayer)
		local vehfuel = getElementData(veh, "fuelstate")
		local vehfuell = vehfuel
		local vehfuel = 180 / 100 * vehfuel
        
        -- NUTZT NATIVE MTA-FUNKTION: getElementSpeed(element, "km/h")
        -- Dadurch wird die Geschwindigkeitsberechnung korrekt und effizient durchgeführt.
		local vehspeed = getElementSpeed(veh, "km/h") 
        
		local lights = getVehicleOverrideLights(veh)
		local engine = getVehicleEngineState(veh)
		
        -- Zeichnen des Tacho-Hintergrunds und der Nadeln 
		dxDrawImage(1550 * Gsx, 700 * Gsy, 400 * Gsx, 400 * Gsy, "carsys/tacho/img/Background.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		
		dxDrawImage(1620 * Gsx, 780 * Gsy, 280 * Gsx, 280 * Gsy, "carsys/tacho/img/Needle.png", vehspeed, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawImage(1535 * Gsx, 720 * Gsy, 240 * Gsx, 240 * Gsy, "carsys/tacho/img/TankNeedle.png", vehfuel, 0, 0, tocolor(255, 255, 255, 255), true)
		
		if vehfuell <= 15 then
			dxDrawImage(1620 * Gsx, 805 * Gsy, 25 * Gsx, 25 * Gsy, "carsys/tacho/img/TankWarning.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		end
			
        -- Anzeigen von Status-Icons
		if isVehicleLocked(veh) == true then
			dxDrawImage(1750 * Gsx, 970 * Gsy, 35 * Gsx, 35 * Gsy, "carsys/tacho/img/State.png", 0, 0, 0, tocolor(0, 150, 0, 255), false)
		elseif isVehicleLocked(veh) == false then
			dxDrawImage(1750 * Gsx, 970 * Gsy, 35 * Gsx, 35 * Gsy, "carsys/tacho/img/State.png", 0, 0, 0, tocolor(150, 0, 0, 255), false)
		end
		
		if(lights)then
			if lights == 2 then
				dxDrawImage(1705 * Gsx, 922 * Gsy, 35 * Gsx, 35 * Gsy, "carsys/tacho/img/Light.png", 0, 0, 0, tocolor(0, 85, 200, 255), false)
			else
				dxDrawImage(1705 * Gsx, 922 * Gsy, 35 * Gsx, 35 * Gsy, "carsys/tacho/img/Light.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			end
		end
		
		if getElementData(veh, "totalschaden") == 1 then
			dxDrawImage(1785 * Gsx, 922 * Gsy, 35 * Gsx, 35 * Gsy, "carsys/tacho/img/Engine.png", 0, 0, 0, tocolor(200, 0, 0, 255), false)
		elseif engine == true then
			dxDrawImage(1785 * Gsx, 922 * Gsy, 35 * Gsx, 35 * Gsy, "carsys/tacho/img/Engine.png", 0, 0, 0, tocolor(200, 85, 0, 255), false)
		elseif engine == false then
			dxDrawImage(1785 * Gsx, 922 * Gsy, 35 * Gsx, 35 * Gsy, "carsys/tacho/img/Engine.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		end
	else
        -- Stoppt das Zeichnen beim Aussteigen oder wenn die Bedingung nicht erfüllt ist
		removeEventHandler("onClientRender", root, drawSpeedo)
	end
end

addEventHandler("onClientVehicleEnter", root, function(player)
	if player == localPlayer then
		removeEventHandler("onClientRender", root, drawSpeedo) 
		addEventHandler("onClientRender", root, drawSpeedo)
	end
end)
addEventHandler("onClientVehicleExit", root, function(player)
	if player == localPlayer then
		removeEventHandler("onClientRender", root, drawSpeedo)
	end
end)


function getElementSpeed(element, unit)
    -- Definiert 'unit' standardmäßig auf 0 (m/s) oder den übergebenen Wert
    if (unit == nil) then unit = 0 end 
    
    if (isElement(element)) then
        local x, y, z = getElementVelocity(element)
        -- Berechnung der Gesamtgeschwindigkeit (Betrag des Geschwindigkeitsvektors)
        local actualSpeed = (x^2 + y^2 + z^2)^0.5 

        if (unit == "km/h" or unit == 1 or unit == '1') then
            -- KORREKTUR: Multiplikator 180 für km/h (anstelle des falschen 100)
            return actualSpeed * 180 
        elseif (unit == "mph" or unit == 2 or unit == '2') then
            -- ZUSÄTZLICHE KORREKTUR: Korrekter Multiplikator für mph (Miles per Hour)
            -- 180 / 1.60934 = 111.847...
            return actualSpeed * 111.85
        else
            -- m/s (GTA-Einheiten * 50)
            return actualSpeed * 50
        end
    else
        outputDebugString("Kein Element. Ich kann keine Geschwindigkeit bekommen")
        return false
    end
end