--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //


addEvent("set:task",true)
addEventHandler("set:task",root,function(client,typ)
	if MtxGetElementData ( client, "loggedin" ) == 1 then
		if(tonumber(MtxGetElementData(client,"Introtask"))==1)then
			if(typ=="give:Roller")then
				MtxSetElementData(client,"Introtask",2)
				MtxSetElementData(client,"money",tonumber(MtxGetElementData(client,"money")) + 1500)
				outputChatBox("Herzlichen Glückwunsch, Sie haben eine Aufgabe erledigt! Du erhältst €1500",client,255,255,255)
			end
		elseif(tonumber(MtxGetElementData(client,"Introtask"))==2)then
			if(typ=="give:rathaus")then
			    MtxSetElementData(client,"Introtask",3)
				MtxSetElementData(client,"money",tonumber(MtxGetElementData(client,"money")) + 2500)
				outputChatBox("Herzlichen Glückwunsch, Sie haben eine Aufgabe erledigt! Du erhältst €2500",client,255,255,255)
			end
		elseif(tonumber(MtxGetElementData(client,"Introtask"))==3)then
			if(typ=="give:helpmenue")then
				MtxSetElementData(client,"Introtask",4)
				MtxSetElementData(client,"money",tonumber(MtxGetElementData(client,"money")) + 2000)
				outputChatBox("Herzlichen Glückwunsch, Sie haben eine Aufgabe erledigt! Du erhältst €2000",client,255,255,255)
			end	
		elseif(tonumber(MtxGetElementData(client,"Introtask"))==4)then
			if(typ=="give:führerschein")then
				MtxSetElementData(client,"Introtask",5)
				MtxSetElementData(client,"money",tonumber(MtxGetElementData(client,"money")) + 4000)
				outputChatBox("Herzlichen Glückwunsch, Sie haben eine Aufgabe erledigt! Du erhältst €4000",client,255,255,255)
			end
		 elseif(tonumber(MtxGetElementData(client,"Introtask"))== 5)then
			if(typ=="give:lkwschein")then
				MtxSetElementData(client,"Introtask",6)
				MtxSetElementData(client,"money",tonumber(MtxGetElementData(client,"money")) + 4500)
				outputChatBox("Herzlichen Glückwunsch, Sie haben eine Aufgabe erledigt! Du erhältst €4500",client,255,255,255)
			end
		 elseif(tonumber(MtxGetElementData(client,"Introtask"))==6)then
			if(typ=="give:Bus")then
				MtxSetElementData(client,"Introtask",7)
				MtxSetElementData(client,"money",tonumber(MtxGetElementData(client,"money")) + 4000)
				outputChatBox("Herzlichen Glückwunsch, Sie haben eine Aufgabe erledigt! Du erhältst €4000",client,255,255,255)
				datasave_remote(client)
			end
		end	
	end
end)