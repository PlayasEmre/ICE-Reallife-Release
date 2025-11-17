--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local sx,sy=guiGetScreenSize()
local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted" }
local HUD1 = { width = 300, height = 25}
local State = false
local progress = 0
local nRotation = 0
local money = 0
local Health = 0
local Armor = 0
local Hunger = 0

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function ()
	for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, false )
	end
end)

function HUD()
	local name = getPlayerName(localPlayer)
	local armor = getPedArmor(localPlayer)
	local health = getElementHealth(localPlayer)
	local hunger = getElementHunger(localPlayer,"hunger")
	local currentMoney = tonumber(getPlayerMoney(localPlayer))
	local weaponslot = getPedWeaponSlot(localPlayer)
	local jailtime = tonumber(getElementData(localPlayer, "jailtime"))
	local oxygen = getPedOxygenLevel(localPlayer)
	local currentTick = getTickCount()/1500
	local Ping = getPlayerPing(localPlayer)

	local time = getRealTime()
	local hour = time.hour
	local minute = time.minute
	local second = time.second
	local day = time.monthday
	local year = time.year + 1900
	local month = time.month + 1

    if State == false then
 
        local width, height = HUD1.width, HUD1.height
        nRotation = nRotation + 0.6
        if nRotation > 360 then nRotation = 0 end
 
        if progress < 1 then
            progress = progress + 0.04
        end
		
         local posX, moveY, moveZ = interpolateBetween(sx , 0, 225, sx - 350, 255, 487.5, progress, "Linear")
             roundedRectangle(posX + 2*Gsx, 44*Gsy, 275*Gsx,  170*Gsy, tocolor(1, 0, 0, 185))
             dxDrawText(""..name.."", posX + 30*Gsx, 80*Gsy, 100*Gsx, 70*Gsy, tocolor(255, 255, 255, 255), 1.0, "arial", "left", "center", false, false, false, false, false)
             dxDrawText("PING: "..tonumber(Ping),posX + 110*Gsx,50*Gsy,100*Gsx,100*Gsy,tocolor(255,255,255,255), 1.0, "arial", "left", "center", false, false, false, false, false)
			 
            if Armor > armor then
				Armor = Armor - 1
			end
			if Armor < armor then
				Armor = Armor + 1
			end
            --> Schutzweste Anzeige	
			if (armor) >= 25 or (armor) == 0 then
				roundedRectangle(posX + 25*Gsx, 88*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))	
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205/100*Gsx*Armor,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			elseif (armor) <= 25 then				
				roundedRectangle(posX + 25*Gsx, 88*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, math.abs(math.sin(currentTick)*255)))
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourBG.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205/100*Gsx*Armor,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourbar.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
			end					

			if Health > health then
				Health = Health - 1
			end
			if Health < health then
				Health = Health + 1
			end
            --> Lebenbar Anzeige		
			if (health) >= 25 then
				roundedRectangle(posX + 25*Gsx, 114*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/healthBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205/100*Gsx*Health,Gsy*16, ":"..getResourceName(getThisResource()).."/images/hud/healthbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			elseif (health) <= 25 then
				roundedRectangle(posX + 25*Gsx, 114*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, math.abs(math.sin(currentTick)*255)))
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/healthBG.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205/100*Gsx*Health,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/healthbar.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
			end	
		

            if Hunger > hunger then
				Hunger = Hunger - 1
			end
			if Hunger < hunger then
				Hunger = Hunger + 1
			end
            --> Hungerbar Anzeige			
			if (hunger) >= 25 then
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205/100*Gsx*Hunger,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			elseif (hunger) <= 25 then				
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, math.abs(math.sin(currentTick)*255)))
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerBG.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205/100*Gsx*Hunger,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerbar.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
			end	
			
			
			
			if currentMoney  ~= money then
				if currentMoney < money then -- Geld wird weniger
					local moneydiff = money-currentMoney
					local abzug = math.ceil(moneydiff/100)
					money = money-abzug
				else -- Geld wird mehr
					local moneydiff = currentMoney-money
					local abzug = math.ceil(moneydiff/100)
					money = money+abzug
				end
			end
			dxDrawText(formatNumber(money)..""..Tables.waehrung.."", posX + 30*Gsx, 160*Gsy, 1884*Gsx, 206*Gsy, tocolor(228, 227, 227, 254), 1.50, "pricedown", "left", "top", false, false, false, false, false)
			dxDrawText(hour..":"..minute, posX + 200*Gsx, 59+5*Gsy, 1802*Gsx, 69*Gsy, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			
			
			--//Wanteds
			local wanted = getElementData(localPlayer, "wanteds")
			if(wanted and wanted > 0)then
                local wantedY=0
                for i=1,wanted do
                    dxDrawImage(posX+wantedY + 20*Gsx,219*Gsy,30*Gsx,30*Gsy,":"..getResourceName(getThisResource()).."/images/hud/wanted_active.png",0,0,0,tocolor(240,240,0,255),false)
                    wantedY=wantedY+37
                end
            end
			
			
			--/images/Weapon
			local weaponID = getPedWeapon(localPlayer)
			dxDrawImage(posX - 100*Gsx, 50*Gsy, 82*Gsx, 87*Gsy, tostring(":"..getResourceName(getThisResource()).."/images/weapons/".. weaponID ..".png"), 0, 0, 0, tocolor(255, 255, 255, 255), false)
			
			--/images/Ammo
			if weaponslot >= 2 and weaponslot <= 9 then
			local clip = getPedAmmoInClip (localPlayer, weaponslot )
			local clip1 = getPedTotalAmmo (localPlayer, weaponslot )
				dxDrawText(clip.."|"..clip1, posX - 80*Gsx, 121*Gsy, 1564*Gsx, 165*Gsy, tocolor(228, 227, 227, 254), 1, "default-bold", "left", "center", false, false, false, false, false)
			end
			
            dxDrawImage(posX + 243*Gsx,  89*Gsy,     16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armour.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawImage(posX + 243*Gsx,  115*Gsy,    16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/health.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawImage(posX + 243*Gsx,  59+5*Gsy,   16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/time.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawImage(posX + 243*Gsx,  172.5+5*Gsy,14*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/money.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			
			if(jailtime and jailtime > 0)then
				dxDrawRectangle(1630*Gsx,325*Gsy,280*Gsx,25*Gsy,guimaincolor,false)
				dxDrawRectangle(1630*Gsx,350*Gsy,280*Gsx,100*Gsy,tocolor(0,0,0,160),false)
				dxDrawText("KNAST",1740*Gsx,325*Gsy,200*Gsx,22*Gsy,tocolor(255,255,255,255),1.00*Gsx,dxFONT,_,_,_,_,false,_,_)
				dxDrawText("Du bist noch für "..math.floor(getElementData(localPlayer,"jailtime")).." Minuten im Knast",1660*Gsx,385*Gsy,200*Gsx,22*Gsy,tocolor(255,255,255,255),1.00,dxFONT2,_,_,_,_,false,_,_)
			end
			
			
				--/images/Armor-Percent
				dxDrawText(""..math.floor(tonumber(Armor)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 83*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
				
				--/images/Health-Percent
				dxDrawText(""..math.floor(tonumber(Health)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 135*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
				
				--/images/hunger-Percent
				dxDrawText(""..math.floor(tonumber(Hunger)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 187*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
			
			if(isElementInWater(localPlayer))then
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 243*Gsx, 141*Gsy, 16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/oxygen.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 191/1000*Gsx*oxygen,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourbar.png", 0, 0, 0, tocolor(0, 0, 255, 255), false)
				dxDrawText(""..math.floor(tonumber(oxygen/10.7)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 187*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
			else
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 243*Gsx, 141*Gsy, 16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/air.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205/100*Gsx*Hunger,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawText(""..math.floor(tonumber(Hunger)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 187*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
			end
					
			dxDrawImage(820*Gsx,0*Gsy,280*Gsx,30*Gsy,":"..getResourceName(getThisResource()).."/images/hud/Time2.png",0,0,0,tocolor(150,0,0,200),false)
			dxDrawText(hour..":"..minute..":"..second.." : "..day.."."..month.."."..year,1725*Gsx,0*Gsy,200*Gsx,20*Gsy,tocolor(255,255,255,255),1.0,dxFONT,"center",nil,nil,false,nil,nil)
 
    elseif State == true then
        local width, height = HUD1.width, HUD1.height
       
        if progress > 0 then
            progress = progress - 0.02
        end
       
		  local posX, moveY, moveZ = interpolateBetween(sx , 0, 225, sx - 350, 255, 487.5, progress, "Linear")
             roundedRectangle(posX + 2*Gsx, 44*Gsy, 275*Gsx,  170*Gsy, tocolor(1, 0, 0, 185))
             dxDrawText(""..name.."", posX + 30*Gsx, 80*Gsy, 100*Gsx, 70*Gsy, tocolor(255, 255, 255, 255), 1.0, "arial", "left", "center", false, false, false, false, false)
             dxDrawText("PING: "..tonumber(Ping),posX + 110*Gsx,50*Gsy,100*Gsx,100*Gsy,tocolor(255,255,255,255), 1.0, "arial", "left", "center", false, false, false, false, false)
			 
            if Armor > armor then
				Armor = Armor - 1
			end
			if Armor < armor then
				Armor = Armor + 1
			end
            --> Schutzweste Anzeige	
			if (armor) >= 25 or (armor) == 0 then
				roundedRectangle(posX + 25*Gsx, 88*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))	
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205/100*Gsx*Armor,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			elseif (armor) <= 25 then				
				roundedRectangle(posX + 25*Gsx, 88*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, math.abs(math.sin(currentTick)*255)))
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourBG.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
				dxDrawImage(posX + 28*Gsx, 91*Gsy, 205/100*Gsx*Armor,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourbar.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
			end					

			if Health > health then
				Health = Health - 1
			end
			if Health < health then
				Health = Health + 1
			end
            --> Lebenbar Anzeige		
			if (health) >= 25 then
				roundedRectangle(posX + 25*Gsx, 114*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/healthBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205/100*Gsx*Health,Gsy*16, ":"..getResourceName(getThisResource()).."/images/hud/healthbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			elseif (health) <= 25 then
				roundedRectangle(posX + 25*Gsx, 114*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, math.abs(math.sin(currentTick)*255)))
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/healthBG.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
				dxDrawImage(posX + 28*Gsx, 117*Gsy, 205/100*Gsx*Health,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/healthbar.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
			end	
		

            if Hunger > hunger then
				Hunger = Hunger - 1
			end
			if Hunger < hunger then
				Hunger = Hunger + 1
			end
            --> Hungerbar Anzeige			
			if (hunger) >= 25 then
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205/100*Gsx*Hunger,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			elseif (hunger) <= 25 then				
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, math.abs(math.sin(currentTick)*255)))
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerBG.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205/100*Gsx*Hunger,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerbar.png", 0, 0, 0, tocolor(255, 255, 255, math.abs(math.sin(currentTick)*255)), false)
			end	
			
			
			
			if currentMoney  ~= money then
				if currentMoney < money then -- Geld wird weniger
					local moneydiff = money-currentMoney
					local abzug = math.ceil(moneydiff/100)
					money = money-abzug
				else -- Geld wird mehr
					local moneydiff = currentMoney-money
					local abzug = math.ceil(moneydiff/100)
					money = money+abzug
				end
			end
			dxDrawText(formatNumber(money)..""..Tables.waehrung.."", posX + 30*Gsx, 160*Gsy, 1884*Gsx, 206*Gsy, tocolor(228, 227, 227, 254), 1.50, "pricedown", "left", "top", false, false, false, false, false)
			dxDrawText(hour..":"..minute, posX + 200*Gsx, 59+5*Gsy, 1802*Gsx, 69*Gsy, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			
			
			--//Wanteds
			local wanted = getElementData(localPlayer, "wanteds")
			if(wanted and wanted > 0)then
                local wantedY=0
                for i=1,wanted do
                    dxDrawImage(posX+wantedY + 20*Gsx,219*Gsy,30*Gsx,30*Gsy,":"..getResourceName(getThisResource()).."/images/hud/wanted_active.png",0,0,0,tocolor(240,240,0,255),false)
                    wantedY=wantedY+37
                end
            end
			
			
			--/images/Weapon
			local weaponID = getPedWeapon(localPlayer)
			dxDrawImage(posX - 100*Gsx, 50*Gsy, 82*Gsx, 87*Gsy, tostring(":"..getResourceName(getThisResource()).."/images/weapons/".. weaponID ..".png"), 0, 0, 0, tocolor(255, 255, 255, 255), false)
			
			--/images/Ammo
			if weaponslot >= 2 and weaponslot <= 9 then
			local clip = getPedAmmoInClip (localPlayer, weaponslot )
			local clip1 = getPedTotalAmmo (localPlayer, weaponslot )
				dxDrawText(clip.."|"..clip1, posX - 80*Gsx, 121*Gsy, 1564*Gsx, 165*Gsy, tocolor(228, 227, 227, 254), 1, "default-bold", "left", "center", false, false, false, false, false)
			end
                        
            dxDrawImage(posX + 243*Gsx,  89*Gsy,     16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armour.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawImage(posX + 243*Gsx,  115*Gsy,    16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/health.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawImage(posX + 243*Gsx,  59+5*Gsy,   16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/time.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawImage(posX + 243*Gsx,  172.5+5*Gsy,14*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/money.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			
			if(jailtime and jailtime > 0) then
				dxDrawRectangle(1630*Gsx,325*Gsy,280*Gsx,25*Gsy,guimaincolor,false)
				dxDrawRectangle(1630*Gsx,350*Gsy,280*Gsx,100*Gsy,tocolor(0,0,0,160),false)
				dxDrawText("Du bist noch für "..math.floor(getElementData(localPlayer,"jailtime")).." Minuten im Knast",1660*Gsx,385*Gsy,200*Gsx,22*Gsy,tocolor(255,255,255,255),1.00,dxFONT2,_,_,_,_,false,_,_)
				dxDrawText("KNAST",1740*Gsx,325*Gsy,200*Gsx,22*Gsy,tocolor(255,255,255,255),1.00*Gsx,dxFONT,_,_,_,_,false,_,_)
			end
			
			
				--/images/Armor-Percent
				dxDrawText(""..math.floor(tonumber(Armor)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 83*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
				
				--/images/Health-Percent
				dxDrawText(""..math.floor(tonumber(Health)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 135*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
				
				--/images/hunger-Percent
				dxDrawText(""..math.floor(tonumber(Hunger)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 187*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
			
			if(isElementInWater(localPlayer))then
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 243*Gsx, 141*Gsy, 16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/oxygen.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 191/1000*Gsx*oxygen,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/armourbar.png", 0, 0, 0, tocolor(0, 0, 255, 255), false)
				dxDrawText(""..math.floor(tonumber(oxygen/10.7)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 187*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
			else
				roundedRectangle(posX + 25*Gsx, 140*Gsy, 212*Gsx, 22*Gsy, tocolor(0, 0, 0, 255))
				dxDrawImage(posX + 243*Gsx, 141*Gsy, 16*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/air.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205*Gsx, 16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerBG.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(posX + 28*Gsx, 143*Gsy, 205/100*Gsx*Hunger,16*Gsy, ":"..getResourceName(getThisResource()).."/images/hud/hungerbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawText(""..math.floor(tonumber(Hunger)).."%", posX + 130*Gsx, 115*Gsy, 206*Gsx, 187*Gsy, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, false)
			end
					
			dxDrawImage(820*Gsx,0*Gsy,280*Gsx,30*Gsy,":"..getResourceName(getThisResource()).."/images/hud/Time2.png",0,0,0,tocolor(150,0,0,200),false)
			dxDrawText(hour..":"..minute..":"..second.." : "..day.."."..month.."."..year,1725*Gsx,0*Gsy,200*Gsx,20*Gsy,tocolor(255,255,255,255),1.0,dxFONT,"center",nil,nil,false,nil,nil)
	 end
end
addEvent("ShowHud", true)
addEventHandler("ShowHud", getRootElement(), function() State = true end)
addEvent("HideHud", true)
addEventHandler("HideHud", getRootElement(), function() State = false end)


--  ╔══════════════════════════════╗
--  ║ » Head up Display Script     ║
--  ║ » ICE Realife - made for Emre║
--  ║ » Author: iLimix             ║
--  ║ » Copyright © 2020           ║
--  ║ » In Order from ICE Reallife ║
--  ╚══════════════════════════════╝

--// Resolution
local screenX, screenY = guiGetScreenSize()
local standartX, standartY = 1920, 1080
local sx, sy = screenX / standartX, screenY / standartY

local noreloadweapons = { 
    [16] = true, [17] = true, [18] = true, 
    [19] = true, [25] = true, [33] = true, 
    [34] = true, [35] = true, [36] = true, 
    [37] = true, [38] = true, [39] = true, 
    [41] = true, [42] = true, [43] = true 
}

local meleespecialweapons = { 
    [0] = true, [1] = true, [2] = true, 
    [3] = true, [4] = true, [5] = true, 
    [6] = true, [7] = true, [8] = true, 
    [9] = true, [10] = true, [11] = true, 
    [12] = true, [13] = true, [14] = true, 
    [15] = true, [40] = true, [44] = true, 
    [45] = true, [46] = true 
}

local hudTable = { "ammo", "armour", "clock", "health", "money", "weapon", "wanted", "area_name", "vehicle_name", "breath", "clock" }
--// Disable Standart HUD
for i = 1, #hudTable do
    setPlayerHudComponentVisible(hudTable[i], false)
end

--// Iconpath for Weapon Icons
local iconpath = { weapon = { ":"..getResourceName(getThisResource()).."/images/hud2/", ".png" } }
local textsize = { 1, 1.3, 0.8 } --// 1. Zeit, 2. Money
local textfont = { "default", "pricedown", "default-bold"} -- 1. Zeit, 2.Money, Leben-/Armor-/Foodanzeige  - statt string kann auch dxCreateFont benutzt werden
local Servername = ""..Tables.servername.." Reallife"

local function getTime()
    local realtime = getRealTime()
    local hour = realtime.hour
    local minute = realtime.minute
    return (hour > 9 and hour or "0" .. hour) .. ":" .. (minute > 9 and minute or "0" .. minute)
end

function convertMoney(cash)
    local format = cash
    while true do
        format, k = string.gsub(format, "^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then break end
    end
    format = tostring(format)
    return format
end

function formatNumber(n) 
    if (not n) then return "Error catching data" end 
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$') 
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right 
end


local progress = 0
local HUDstate = true
local smoothMoveHealth = 0
local smoothMoveArmor = 0
local smoothMoveFood = 0
local coins = 0
local currentMoney = 0
local bar_width = 282
local bar_height = 20

function HUD2()

    if HUDstate == false then
        if progress < 1 then
            progress = progress + 0.04
        end
    elseif HUDstate == true then
        if progress > 0 then
            progress = progress - 0.04
        end
    end

    local posX, moveY, moveZ = interpolateBetween(screenX - 360 * sx, 0, 0, screenX + 10 * sx, 255, 0, progress, "Linear")
    roundedRectangle(posX, 10 * sy, 350 * sx, 180 * sy, tocolor(0, 0, 0, 120))
    roundedRectangle(posX, 10 * sy, 350 * sx, 25 * sy, tocolor(0, 0, 0, 180))
    dxDrawText(Servername .." - ".. getTime(), posX + 135, 10 * sy, screenX - 360 * sx + 350 * sx, 10 * sy + 25 * sy, tocolor(255, 255, 255, 200), textsize[1], textfont[1], "left", "center")

    --// Health, Armor, Hunger \\--
    local healthX, healthY, healthWidth, healthHeight = posX + 20, 50, 304, 22
    dxDrawImage(healthX, healthY, healthWidth, healthHeight, ":"..getResourceName(getThisResource()).."/images/hud2/health.png")
    local health = getElementHealth(localPlayer)
    if smoothMoveHealth > health then
        smoothMoveHealth = smoothMoveHealth - 1
    end
    if smoothMoveHealth < health then
        smoothMoveHealth = smoothMoveHealth + 1
    end
    local progress = (smoothMoveHealth/100)*bar_width
    dxDrawImageSection(healthX + 22, healthY + 1, progress, bar_height, 0, 0, progress, bar_height, "images/hud2/health1.png", 0, 0, 0, tocolor(255,255,255), false)
    dxDrawText(smoothMoveHealth.." %", healthX, healthY, healthWidth + healthX, healthHeight + healthY, tocolor(255, 255, 255, 255), 1, textfont[3], "center", "center")

    --//Armor
    armorX, armorY, armorWidth, armorHeight = posX + 20, 80, 304, 22
    dxDrawImage(armorX, armorY, armorWidth, armorHeight, ":"..getResourceName(getThisResource()).."/images/hud2/armor.png")
    local armor = getPedArmor(localPlayer)
    if smoothMoveArmor > armor then
        smoothMoveArmor = smoothMoveArmor - 1
    end
    if smoothMoveArmor < armor then
        smoothMoveArmor = smoothMoveArmor + 1
    end
    local progress = (smoothMoveArmor/100)*bar_width
    dxDrawImageSection(armorX + 22, armorY + 1, progress, bar_height, 0, 0, progress, bar_height, ":"..getResourceName(getThisResource()).."/images/hud2/armor1.png", 0, 0, 0, tocolor(255,255,255), false)
    dxDrawText(smoothMoveArmor.." %", armorX, armorY, armorWidth + armorX, armorHeight + armorY, tocolor(255, 255, 255, 255), 1, textfont[3], "center", "center")

    --//Hunger
    hungerX, hungerY, hungerWidth, hungerHeight = posX + 20, 110, 304, 22
    dxDrawImage(hungerX, hungerY, hungerWidth, hungerHeight, ":"..getResourceName(getThisResource()).."/images/hud2/food.png")
    local food = getElementHunger(localPlayer)
    if smoothMoveFood > food then
        smoothMoveFood = smoothMoveFood - 1
    end
    if smoothMoveFood < food then
        smoothMoveFood = smoothMoveFood + 1
    end
    local progress = (smoothMoveFood/100)*bar_width
    dxDrawImageSection(hungerX + 22, hungerY + 1, progress, bar_height, 0, 0, progress, bar_height, ":"..getResourceName(getThisResource()).."/images/hud2/food1.png", 0, 0, 0, tocolor(255,255,255), false)
    dxDrawText(smoothMoveFood.." %", hungerX, hungerY, hungerWidth + hungerX, hungerHeight + hungerY, tocolor(255, 255, 255, 255), 1, textfont[3], "center", "center")
	
	local currentMoney = tonumber(getPlayerMoney(localPlayer))
	if currentMoney  ~= money then
		if currentMoney < money then -- Geld wird weniger
			local moneydiff = money-currentMoney
			local abzug = math.ceil(moneydiff/100)
			money = money-abzug
		else -- Geld wird mehr
			local moneydiff = currentMoney-money
			local abzug = math.ceil(moneydiff/100)
			money = money+abzug
		end
	end
    --// Money \\--
    dxDrawText("€ "..money, posX + 15, 290 * sy, screenX - 360 * sx + 45 * sx, 10 * sy + 25 * sy, tocolor(255, 255, 255, 200), textsize[2], textfont[2], "left", "center")
    
	local coin = tonumber(vioClientGetElementData("coins"))
	if coin ~= coins then
		if coin < coins then -- Geld wird weniger
			local moneydiff = coins-coin
			local abzug = math.ceil(moneydiff/100)
			coins = coins-abzug
		else -- Geld wird mehr
			local moneydiff = coin-coins
			local abzug = math.ceil(moneydiff/100)
			coins = coins+abzug
		end
	end
    --// Coins \\--
    dxDrawText("¢ "..coins, posX + 190, 290 * sy, screenX - 360 * sx + 190 * sx, 10 * sy + 25 * sy, tocolor(255, 255, 255, 200), textsize[2], textfont[2], "left", "center")
	
	local time = getRealTime()
	local hour = time.hour
	local minute = time.minute
	local second = time.second
	local day = time.monthday
	local year = time.year + 1900
	local month = time.month + 1
	
	dxDrawImage(820*sx,0*sy,280*sx,30*sy,":"..getResourceName(getThisResource()).."/images/hud/Time2.png",0,0,0,tocolor(150,0,0,200),false)
	dxDrawText(hour..":"..minute..":"..second.." : "..day.."."..month.."."..year,1725*Gsx,0*Gsy,200*Gsx,20*Gsy,tocolor(255,255,255,255),1.0,dxFONT,"center",nil,nil,false,nil,nil)

    local weapon = getPedWeapon(localPlayer)
    dxDrawImage(posX - 80 , 20 * sy, 70 * sx, 70 * sy, iconpath.weapon[1] .. weapon .. iconpath.weapon[2])
    if noreloadweapons[weapon] then
        local totalammo = getPedTotalAmmo(localPlayer)
        dxDrawText(totalammo, posX - 70, 170 * sy, screenX - 500 * sx + 50 * sx, 50 * sy, tocolor(255, 255, 255), textsize[4], textfont[2], "left", "center")
    elseif not meleespecialweapons[weapon] then
        local ammoinclip = getPedAmmoInClip(localPlayer)
        local totalammo = getPedTotalAmmo(localPlayer)
        dxDrawText(ammoinclip .. " / " .. (totalammo - ammoinclip), posX - 75, 170 * sy, screenX - 500 * sx + 50 * sx, 50 * sy, tocolor(255, 255, 255), textsize[3], textfont[2], "left", "center")
    elseif weapon == 0 then
        dxDrawText("Faust", posX - 69, 170 * sy, screenX - 500 * sx + 50 * sx, 50 * sy, tocolor(255, 255, 255), textsize[2], textfont[3], "left", "center")
    elseif weapon == 46 then
        dxDrawText("Fallschirm", posX  - 70, 170 * sy, screenX - 500 * sx + 50 * sx, 50 * sy, tocolor(255, 255, 255), textsize[1], textfont[3], "left", "center")
    end
	
    local wanted = getElementData(localPlayer,"wanteds")
    if wanted >= 1 then
        local wantedX = 20
		for i=1,wanted do
            dxDrawImage((posX + wantedX), 200 * sy, 30 * sx, 30 * sy, ":"..getResourceName(getThisResource()).."/images/hud2/Wanted.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
            wantedX = wantedX + 50
        end
    end
end

function animateHUD()
    if HUDstate == false then
        HUDstate = true
    elseif HUDstate == true then
        HUDstate = false
    end
end
bindKey("b", "down", animateHUD)
 
 
function drawHuDD()
    if State == false then
        triggerEvent("ShowHud", root)
    elseif State == true then
	    triggerEvent("HideHud", root)
    end
end
bindKey( "b", "down", drawHuDD )

addEvent("showhudclient", true)
addEventHandler("showhudclient", localPlayer, function( hud )
	local current_hud = tonumber(getElementData( localPlayer, "hud"))

    -- 1. Zuerst alle möglichen HUD-Handler entfernen, um Warnungen und Doppel-Rendern zu vermeiden
    removeEventHandler("onClientRender", root, HUD)
    removeEventHandler("onClientRender", root, HUD2)
    
    -- 2. Dann den korrekten Handler basierend auf dem aktuellen Wert hinzufügen
    if current_hud == 1 then
        addEventHandler("onClientRender", root, HUD)
    elseif current_hud == 2 then
        addEventHandler("onClientRender", root, HUD2) 
    end
end)