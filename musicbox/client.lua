--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

PremiumBlaster={
["StreamNames"]={"I Love Radio","I Love Dance","I Love The Battle","I Love Mashup","I Love Bravo Charts","Big FM","Dubstep FM"},
["StreamLinks"]=
{
["I Love Radio"]="http://stream01.iloveradio.de/iloveradio1.mp3",
["I Love Dance"]="http://www.iloveradio.de/ilove2dance.m3u",
["I Love The Battle"]="http://www.iloveradio.de/ilovethebattle.m3u",
["I Love Mashup"]="http://www.iloveradio.de/ilovemashup.m3u",
["I Love Bravo Charts"]="http://stream01.iloveradio.de/iloveradio9.mp3",
["Big FM"]="http://srv04.bigstreams.de/bigfm-mp3-96",
["Dubstep FM"]="https://www.dubstep.fm/listen.m3u",
},
}

local PremiumBOX={Window={},Button={},Gridlist={},Label={},Edit={},Image={},}


bindKey("f10","down",function()
	if getElementData(lp,"ElementClicked") == false then
			if getElementData(lp,"premium") == true then
				showCursor(true)
				setElementData(lp,"ElementClicked",true)
				PremiumBOX.Window[1]=dgsCreateWindow(GLOBALscreenX/2-475/2,GLOBALscreenY/2-400/2,475,400,"Ghettoblaster",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
				dgsWindowSetSizable(PremiumBOX.Window[1],false)
				dgsWindowSetMovable(PremiumBOX.Window[1],false)
				PremiumBOX.Gridlist[1]=dgsCreateGridList(15,20,250,340,false,PremiumBOX.Window[1])
				streamName=dgsGridListAddColumn(PremiumBOX.Gridlist[1],"example streamlist",0.9)
				PremiumBOX.Button[1]=dgsCreateButton(280,200,180,40,"Starten",false,PremiumBOX.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(10,10,10,255),true)
				PremiumBOX.Button[2]=dgsCreateButton(280,260,180,40,"Stoppen",false,PremiumBOX.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(10,10,10,255),true)
				PremiumBOX.Button[3]=dgsCreateButton(280,320,180,40,"Schliessen",false,PremiumBOX.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(10,10,10,255),true)
				PremiumBOX.Label[1]=dgsCreateLabel(300,80,100,20,"Stream URL:",false,PremiumBOX.Window[1])
				PremiumBOX.Label[2]=dgsCreateLabel(300,10,100,60,"Musik converter Links:\n- convert2mp3.net\n- kiwi6.com",false,PremiumBOX.Window[1])
				PremiumBOX.Edit[1]=dgsCreateEdit(280,120,180,40,"",false,PremiumBOX.Window[1]) 
				
				for key,_ in pairs(PremiumBlaster["StreamNames"])do
					row = dgsGridListAddRow(PremiumBOX.Gridlist[1])
					dgsGridListSetItemText(PremiumBOX.Gridlist[1],row,streamName,PremiumBlaster["StreamNames"][key],false,false)
				end
				
				addEventHandler("onDgsMouseClick",PremiumBOX.Button[1],
				function(btn,state)
					if btn=="left" and state=="down" then
						local edit = dgsGetText(PremiumBOX.Edit[1])
						local stream = dgsGridListGetItemText(PremiumBOX.Gridlist[1],dgsGridListGetSelectedItem(PremiumBOX.Gridlist[1]),1)
						if(#edit > 0)then
							triggerServerEvent("newPlaySound",lp,lp,edit)
						else
							if(not(stream == ""))then
								triggerServerEvent("newPlaySound",lp,lp,PremiumBlaster["StreamLinks"][stream])
							else infobox_start_func("Wähl einen Stream aus oder trag einen Link ein!",7500,255,0,0)end
						end
					end
				end,
				false)
				
				addEventHandler("onDgsMouseClick",PremiumBOX.Button[2],
				function(btn,state)
					if btn=="left" and state=="down" then
						triggerServerEvent("deleteBlaster",lp,lp)
					end
				end,
				false)
				
				addEventHandler("onDgsMouseClick",PremiumBOX.Button[3],
				function()
					dgsCloseWindow(PremiumBOX.Window[1])
					showCursor(false)
					setElementData(lp,"ElementClicked",false)
				end,
				false)
			end
		
	end
end)
	
addEvent("deleteMusic",true)
addEventHandler("deleteMusic",root,function(player)
	if(isElement(PremiumBlaster[player]))then
		destroyElement(PremiumBlaster[player])
	end
end)

addEvent("createNewMusik",true)
addEventHandler("createNewMusik",root,function(player,link)
	local x,y,z = getElementPosition(player)
	if(isElement(PremiumBlaster[player]))then
		destroyElement(PremiumBlaster[player])
	end
	PremiumBlaster[player] = playSound3D(link,x,y,z)
	attachElements(PremiumBlaster[player],player)
end)