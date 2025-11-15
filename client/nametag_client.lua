--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

nameTagRange = 20
nameSphere = createColSphere ( 0, 0, 0, nameTagRange )
nameTagPlayers = {}
nameTagVisible = {}
nameTagHP = {}
nameTagImages = {}
nameTagAimTarget = localPlayer

local play = dxCreateFont('fonts/segoeui.ttf', 20)

local players = getElementsByType ( "player" )
for key, index in pairs ( players ) do
	setPlayerNametagShowing ( index, false )
end

addEventHandler ( "onClientPlayerJoin", getRootElement(),
	function ()
		setPlayerNametagShowing ( source, false )
	end
)

function nameTagSpawn ()
	detachElements ( nameSphere )
	if isElement ( localPlayer ) then
		attachElements ( nameSphere, localPlayer )
	end
end
setTimer ( nameTagSpawn, 500, 0 )

function nameTagSphereHit ( element, dim )
	if getElementType ( element ) == "player" and not ( element == localPlayer ) then
		nameTagPlayers[element] = true
		nameTagImages[element] = {}
		nameTagCheckPlayerSight ( element )
	end
end
addEventHandler ( "onClientColShapeHit", nameSphere, nameTagSphereHit )

function nameTagCheckPlayerSight ( player )

	if isElement ( player ) then
		local x1, y1, z1 = getPedBonePosition ( player, 8 )
		local x2, y2, z2 = getPedBonePosition ( localPlayer, 8 )
		local hit = processLineOfSight ( x1, y1, z1, x2, y2, z2, true, false, false, true, false )
		nameTagVisible[player] = not hit
		if nameTagVisible[player] then
			nameTagHP[player] = getElementHealth ( localPlayer )
		end
		
		faction = getElementData ( player, "fraktion" )
		
		if not nameTagImages[player] then
			nameTagImages[player] = {}
		end
		nameTagImages[player]["armor.png"] = false
		nameTagImages[player]["police.png"] = false
		nameTagImages[player]["married.png"] = false
		nameTagImages[player]["armed.png"] = false
		nameTagImages[player]["WTD1.png"] = false
		nameTagImages[player]["WTD2.png"] = false
		nameTagImages[player]["WTD3.png"] = false
		nameTagImages[player]["WTD4.png"] = false
		nameTagImages[player]["WTD5.png"] = false
		nameTagImages[player]["WTD6.png"] = false
		nameTagImages[player]["smode.png"] = false
		nameTagImages[player]["mafia.png"] = false
		nameTagImages[player]["aod.png"] = false
		nameTagImages[player]["medic.png"] = false
		nameTagImages[player]["fbi.png"] = false
		nameTagImages[player]["atzen.png"] = false
		nameTagImages[player]["reporter.png"] = false
		nameTagImages[player]["triaden.png"] = false
		nameTagImages[player]["aduty.png"]= false
		
		if getElementData ( player, "wanteds" ) == 1 then
			nameTagImages[player]["WTD1.png"] = true
		elseif getElementData ( player, "wanteds" ) == 2 then
			nameTagImages[player]["WTD2.png"] = true
		elseif getElementData ( player, "wanteds" ) == 3 then
			nameTagImages[player]["WTD3.png"] = true
		elseif getElementData ( player, "wanteds" ) == 4 then
			nameTagImages[player]["WTD4.png"] = true
		elseif getElementData ( player, "wanteds" ) == 5 then
			nameTagImages[player]["WTD5.png"] = true
		elseif getElementData ( player, "wanteds" ) == 6 then
			nameTagImages[player]["WTD6.png"] = true
		else
		
		if getElementData(player,"adminduty") == true then
				nameTagImages[player]["aduty.png"] = true
			end
		end
		
		local r, g, b = getPlayerNametagColor ( player )
		if r == 200 and g == 0 and b == 0 then
			nameTagImages[player]["armed.png"] = true
		end
		
		if getElementData ( player, "married") == 1 then
			nameTagImages[player]["married.png"] = true
		end
		
		if getElementData ( player, "playingtime" ) then
			if getElementData ( player, "playingtime" ) <= 59 then
			end
		end
	else
		nameTagPlayers[player] = nil
		nameTagVisible[player] = nil
		nameTagHP[player] = nil
	end
end

function nameTagSphereLeave ( element )
	nameTagPlayers[element] = nil
	nameTagVisible[element] = nil
	nameTagHP[element] = nil
end
addEventHandler ( "onClientColShapeLeave", nameSphere, nameTagSphereLeave )

function nameTagRender ()
	setElementData(localPlayer, "isChatBoxInputActive", tostring(isChatBoxInputActive()))
	local x, y, z, sx, sy
	local name, social
	local r, g, b, armor
	local images, drawn
	for key, index in pairs ( nameTagVisible ) do
		if isElement ( key ) then
			if nameTagVisible[key] then
				x, y, z = getElementPosition ( key )
				if x and y and z then
					sx, sy = getScreenFromWorldPosition ( x, y, z + 1.1, 1000, true )
					if sx and sy then
						r, g, b = calcRGBByHP ( key )
						r1, g1, b1 = 0, 185, 255
						name = getPlayerName ( key )
						social = "Spieler"
						if getElementData ( key, "socialState" ) then
							social = getElementData ( key, "socialState" )
						end
						if isChatBoxInputActive() then
							setElementData(localPlayer, "isChatBoxInputActive", true)
						else
							setElementData(localPlayer, "isChatBoxInputActive", false)
						end
						if getElementData( key, "isChatBoxInputActive") == true then 
							social = "schreibt..."
						end
						if (getElementData(key,"adminduty") == true) then
							social = "Supportmodus"
							r1, g1, b1 = 255, 78, 0
						end
					
						
						if getElementData ( key, "adminlvl" ) == 0 then
							if getElementData ( key, "nachname" ) then
								dxDrawText ("["..getElementData ( key, "nachname" ).."]" ..name, sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
							else
								dxDrawText ( name, sx, sy, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
							end
						elseif getElementData ( key, "adminlvl" ) == 2 then
							dxDrawText ( "[Ticketsupporter]"..name , sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
						elseif getElementData ( key, "adminlvl" ) == 3 then
							dxDrawText ( "[Supporter]"..name , sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
						elseif getElementData ( key, "adminlvl" ) == 4 then
							dxDrawText ( "[Moderator]"..name , sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
						elseif getElementData ( key, "adminlvl" ) == 5 then
							dxDrawText ( "[Adminstrator]"..name , sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
						elseif getElementData ( key, "adminlvl" ) == 9 then
							dxDrawText ( "[Stellv. Projektleiter]"..name , sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
						elseif getElementData ( key, "adminlvl" ) == 10 then
							dxDrawText ( "[Projektleiter]"..name , sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
						elseif getElementData ( key, "adminlvl" ) == 11 then
							dxDrawText ( "[Entwickler]"..name , sx - 2, sy - 2, sx, sy, tocolor ( r, g, b, 255 ), 1.4, "default-bold", "center", "center" )
						end	
					
						dxDrawText ( social, sx, sy + 30, sx, sy, tocolor ( 0, 0, 0, 255 ), .9, "default-bold", "center", "center" )
						dxDrawText ( social, sx - 2, sy - 1 + 30, sx, sy, tocolor ( r1, g1, b1, 255 ), .9, "default-bold", "center", "center" )
						
						images, drawn = 0, 0
						for img, bool in pairs ( nameTagImages[key] ) do
							if bool then
								images = images + 1
							end
						end
						for img, bool in pairs ( nameTagImages[key] ) do
							if bool then
								if images / 2 == math.floor ( images / 2 ) then
									dxDrawImage ( sx + 24 * ( drawn ) - images * 24 + 24, sy + 25, 24, 24, "/images/nametag/"..img )
									drawn = drawn + 1
								else
									dxDrawImage ( sx + 24 * ( drawn ) - images * 24 / 2, sy + 25, 24, 24, "/images/nametag/"..img )
									drawn = drawn + 1
								end
							end
						end
					end
				end
			end
		else
			nameTagCheckPlayerSight ( key )
		end
	end
end
addEventHandler ( "onClientRender", getRootElement(), nameTagRender )

function calcRGBByHP ( player )

	local hp = getElementHealth ( player )
	local armor = getPedArmor ( player )
	if hp <= 0 then
		return 0, 0, 0
	else
		if armor > 0 then
			armor = math.abs ( armor - 0.01 )
			return 0 + (2.55*armor), (255), 0 + (2.55*armor)
		else
		hp = math.abs ( hp - 0.01 )
		return ( 100 - hp ) * 2.55 / 2, ( hp * 2.55 ), 0
		end
	end
end


function reCheckNameTag ()

	if ( isElement ( getCameraTarget () ) ) then
		detachElements ( nameSphere )
		attachElements ( nameSphere, getCameraTarget () )
	end
	setElementInterior ( nameSphere, getElementInterior ( localPlayer ) )
	setElementDimension ( nameSphere, getElementDimension ( localPlayer ) )
	if isPedAiming ( localPlayer ) and ( pedSlot == 6 ) then
		local x1, y1, z1 = getPedTargetStart ( localPlayer )
		local x2, y2, z2 = getPedTargetEnd ( localPlayer )
		local pedSlot = getPedWeaponSlot ( localPlayer )
		local boolean, x, y, z, hit = processLineOfSight ( x1, y1, z1, x2, y2, z2 )
		if boolean then
			if isElement ( hit ) then
				if getElementType ( hit ) == "player" then
					nameTagAimTarget = hit
					nameTagPlayers[nameTagAimTarget] = nameTagAimTarget
				end
			end
		end
	end
	for key, index in pairs ( nameTagPlayers ) do
		nameTagCheckPlayerSight ( key )
	end
end
setTimer ( reCheckNameTag, 500, 0 )