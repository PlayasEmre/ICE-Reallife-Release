--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local x,y = guiGetScreenSize()
local AchievmentText = nil

function renderAchievment()
	if(getElementData(lp,"ElementClicked")==false)then
		dxDrawImage(0*(x/1440),0*(y/900),1440*(x/1440),900*(y/900),":"..getResourceName(getThisResource()).."/achievments/AchievBG.png",0,0,0,tocolor(255,255,255,255),false)
        dxDrawText("Achievment erreicht\n"..AchievmentText.."", 0*(x/1440), -9*(y/900), 1440*(x/1440), 891*(y/900), tocolor(0, 200, 0, 255), 1.50, "pricedown", "center", "center", false, false, false, false, false)
	end
end

addEvent("showAchievmentBox",true)
addEventHandler("showAchievmentBox",root,function(text)
	AchievmentText=text
	
	if(fileExists(":"..getResourceName(getThisResource()).."/achievments/AchievBG.png"))then
		if(getElementData(lp,"ElementClicked")==false)then
		achievsound_func ()
		addEventHandler("onClientRender",root,renderAchievment)
			setTimer(function()
				removeEventHandler("onClientRender",root,renderAchievment)
			end,10000,1)
		else
			outputChatBox("Achievment erreicht: "..text.." - Du bekommst $.",255,255,255,true)
		end
	else
		outputChatBox("Achievment erreicht: "..text.." - Du bekommst $.",255,255,255,true)
	end
end)