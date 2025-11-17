--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //


local Jetpack = {"brassknuckle","golfclub","nightstick","knife","bat","shovel","poolstick","katana","chainsaw","dildo","vibrator","flower","cane","grenade","teargas","molotov","colt 45","silenced","deagle","shotgun","sawed-off","combat shotgun","uzi","mp5","ak-47","m4","tec-9","rifle","sniper","rocket launcher","rocket launcher hs","flamethrower","minigun","satchel","bomb","spraycan","fire extinguisher","camera","nightvision","infrared"}
local notallowedcharacter={" ","ä","ü","ö",",","#","'","+","*","~",":",";","=","}","?","\\","{","&","/","§","\"","!","°","@","|","`","´","<",">","none","keiner","niemand","niemandem","scheiss","adolf","hitler","server","german","roleplay","vio","ekonomie","eko","sunrise","coa","deltroyz","exo","ultimate","vnx","venox","neon","nova","touch","reallife","matrix","astro","gur","sex"}

local function anitcheat()

  --//Hier wird Abgefragt wenn es nicht der Client ist dann wird die Funktion gestoppt
  if not client and not isElement(client) then return false end
  
  --// Hier wird abgefragt ist der Spieler eingeloggt
  if MtxGetElementData(client,"loggedin") and MtxGetElementData(client,"loggedin") == 1 then

	-- Anticheat Coins
		   if MtxGetElementData(client, "coins") and tonumber(MtxGetElementData(client, "coins")) >= 100000000 then
				MtxSetElementData(client, "coins",0)
				return banVioShieldPlayer(client, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen Coins")
		   end
	 
	-- Anticheat Money(Bar)
		   if MtxGetElementData(client, "money") and tonumber(MtxGetElementData(client, "money")) >= 100000000 then
				MtxSetElementData(client, "money",0)
				return banVioShieldPlayer(client, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen Geld(Hand)")
		   end
		
	-- Anticheat Money(Bank)
			if MtxGetElementData(client, "bankmoney") and tonumber(MtxGetElementData(client, "bankmoney")) >= 100000000 then
				MtxSetElementData(client, "bankmoney",0)
				return banVioShieldPlayer(client, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen Geld(Bank)")
			end
				
	-- Anticheat Drug
			if MtxGetElementData(client, "drugs") and tonumber(MtxGetElementData(client, "drugs")) >= 100000000 then
				MtxSetElementData(client, "drugs",0)
				return banVioShieldPlayer(client, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen (Drogen)")
			end	
				
	-- Anticheat Bonuspoint
			if MtxGetElementData(client, "bonuspoints") and tonumber(MtxGetElementData(client, "bonuspoints")) >= 100000000 then
				MtxSetElementData(client, "bonuspoints",0)
				return banVioShieldPlayer(client, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen (Bonuspoints)")
			end
		
	-- Anticheat exp
			if MtxGetElementData(client, "exp") and tonumber(MtxGetElementData(client, "exp")) >= 100000000 then
				MtxSetElementData(client, "exp",0)
				return banVioShieldPlayer(client, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen (Exp)")
			end	
		
	-- Anticheat level
			if MtxGetElementData(client, "level") and tonumber(MtxGetElementData(client, "level")) >= 100000000 then
				MtxSetElementData(client, "level",0)
				return banVioShieldPlayer(client, "Du wurdest vom Anti Cheat System vom Server ausgeschlossen (Level)")
			end
	end
end
addEvent ( "anitcheatServer", true )
addEventHandler ("anitcheatServer", root, anitcheat )

addEvent("waffenkick",true)
addEventHandler("waffenkick",root,function(typ)
	outputChatBox(getPlayerName(client).." wurde wegen "..typ.." cheating gekickt!",root,255,0,0)
	takeAllWeapons(client)
	kickPlayer(client,""..Tables.servername.." Anticheat",typ.." Betrug ist nicht erlaubt!")
end)

--//Sicherheitssystem
addEventHandler("onPlayerConnect",getRootElement(),function(ni,ip,uni,se,ver)
	for _,v in ipairs(notallowedcharacter)do
		if(string.find(string.lower(ni),v))then
			cancelEvent(true,"Es sind keine Sonderzeichen, Farbcodes, Clantags oder Servernamen erlaubt!")
		end
	end
end)

addEventHandler("onResourceStart",resourceRoot,function()
	for i,v in ipairs(Jetpack) do
	   setJetpackWeaponEnabled(v,false)
	   setJetpackMaxHeight(5000)
	end
end)