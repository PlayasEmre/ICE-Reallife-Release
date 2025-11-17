--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local dutyPickup = createPickup(-2211.7697753906,1056.8997802734,80.013061523438,3,1239,0)

function armsAnonymus_func ( player )
    if getElementType ( player ) == "player" and getPedOccupiedVehicle ( player ) == false then
	local x, y, z = getElementPosition ( player )
	if getDistanceBetweenPoints3D ( x, y, z,  -2211.7697753906,1056.8997802734,80.013061523438 ) <= 15 then
		if isAnonymus( player ) then
		
					playSoundFrontEnd ( player, 101 )
					
					if MtxGetElementData(player, "money") >= 200 then
						takePlayerSaveMoney(player, 200)
									
					local weapon = 29 -- MP5
					local ammo = 120
					giveWeapon ( player, weapon, ammo, true )
						
					local weapon = 24 -- dgl
					local ammo = 230
					giveWeapon ( player, weapon, ammo, true )
						
					local weapon = 31 -- m4
					local ammo = 650
					giveWeapon ( player, weapon, ammo, true )
					
					local weapon = 35
					local ammo = 5 -- rpg
					giveWeapon ( player, weapon, ammo, true )
					
					local weapon = 34 -- sniper
					local ammo = 32
					giveWeapon ( player, weapon, ammo, true )
				
					-- Weste Hunger Amor
					setElementHunger ( player, 100 )
					setElementHealth ( player, 100 )
					setPedArmor ( player, 100 )
					triggerClientEvent ( player, "infobox_start", getRootElement(), "Du hast dich gerade eben ausgerüstet", 7500, 125, 125, 0 )
				end
			end
		end
	end
end
addEventHandler( "onPickupHit", dutyPickup, armsAnonymus_func )