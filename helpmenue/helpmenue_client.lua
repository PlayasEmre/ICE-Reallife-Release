--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local ICE = {Window={},Button={},Gridlist={},GridlistColumn={},Label={},Edit={},Image={},Tabpanel={},Tab={},Music={},Memo={},Combo={},ComboItem={},CPicker={},ScrollBar={},Radio={},Blurbox={},Probar={},Browser={}}

local helpmenue = false

local helpmenueText=
{
	["Willkommen"] = "Willkommen auf "..Tables.servername.."-Reallife\n\n"..Tables.servername.."-Reallife bietet dir ein einmaliges Spielerlebnis. Zusammen mit der Community\nwirst du sicher viel Spaß haben. Solltest du Fragen oder Probleme haben, kannst du\ndich gerne an das Admin-Team wenden. Nutze dazu einfach den Befehl /report und\nstelle deine Anfrage.\n\nWir freuen uns auf dich!",
	["Binds/Commands"] = "Hier kannst du einige Befehle sehen \n /commands\n /admincommands",
	["Daten"] = "Hier kannst du paar Informationen vom Server sehen\nUnsere Teamspeak IP: "..Tables.tsip.."\nUnser Forum:"..Tables.forumURL.." ",
}

local standartHelpmenuTXT = ""

local function deleteAllUIItems()
	if isElement(ICE.Button[2]) then
		destroyElement(ICE.Button[2])
	end
	if isElement(ICE.Button[3])then
		destroyElement(ICE.Button[3])
	end
	if isElement(ICE.Button[4]) then
		destroyElement(ICE.Button[4])
	end
end

bindKey("f1", "down", function()
if getElementData ( localPlayer, "loggedin" ) == 1 then
	if helpmenue == false then
		if not isPedDead(localPlayer) then
			if getElementData(localPlayer,"ElementClicked") == false then
				triggerServerEvent("set:task",localPlayer,localPlayer,"give:helpmenue")
			    showCursor(true)
				helpmenue = true
				ICE.Window[1] = dgsCreateWindow(GLOBALscreenX/2-700/2,GLOBALscreenY/2-450/2,700,450,"Hilfe-Panel",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
				dgsWindowSetSizable(ICE.Window[1],false)
				dgsWindowSetMovable(ICE.Window[1],false)
				ICE.Button[1] = dgsCreateButton(674,-25,26,25,"×",false,ICE.Window[1],_,_,_,_,_,_,tocolor(200,50,50,255),tocolor(250,20,20,255),tocolor(150,50,50,255),true)
				dgsSetProperty(ICE.Button[1],"textSize",{1.6,1.6})
				ICE.Gridlist[1] = dgsCreateGridList(5,7,205,400,false,ICE.Window[1],_,tocolor(50,50,50,255),tocolor(255,255,255,255),tocolor(30,30,30,255),tocolor(65,65,65,255))
				local Kategorie = dgsGridListAddColumn(ICE.Gridlist[1],"Kategorie",0.9)
				local grid1 = dgsGridListAddRow(ICE.Gridlist[1],"Willkommen")
				local grid2 = dgsGridListAddRow(ICE.Gridlist[1],"Binds/Commands")
				local grid3 = dgsGridListAddRow(ICE.Gridlist[1],"Daten")
				
				ICE.Label[1] = dgsCreateLabel(220,15,160,200,standartHelpmenuTXT,false,ICE.Window[1])
				
				
				dgsGridListSetItemText(ICE.Gridlist[1],grid1,Kategorie,"Willkommen")
				dgsGridListSetItemText(ICE.Gridlist[1],grid2,Kategorie,"Binds/Commands")
				dgsGridListSetItemText(ICE.Gridlist[1],grid3,Kategorie,"Daten")
				
				dgsGridListSetSortEnabled(ICE.Gridlist[1],false)
				
				addEventHandler("onDgsMouseClick",ICE.Gridlist[1],
					function(btn,state)
						if btn == "left" and state == "up" then
							local item=dgsGridListGetSelectedItem(ICE.Gridlist[1])
							if item > 0 then
								local clicked = dgsGridListGetItemText(ICE.Gridlist[1],dgsGridListGetSelectedItem(ICE.Gridlist[1]),1)
								if helpmenueText[clicked] then
									dgsSetText(ICE.Label[1],helpmenueText[clicked])
									if item == grid3 then
										deleteAllUIItems()
									else
										deleteAllUIItems()
									end
								end
							else
								dgsSetText(ICE.Label[1],standartHelpmenuTXT)
							end
						end
					end,
				false)
				
				addEventHandler("onDgsMouseClick",ICE.Button[1],
					function(btn,state)
						if btn == "left" and state == "up" then
							dgsCloseWindow(ICE.Window[1])
							showCursor(false)
							helpmenue = false
						end
					end,
				false)
					
				end
			end
		end
	end
end)