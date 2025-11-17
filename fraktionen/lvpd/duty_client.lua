--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local Duty={Window={},Button={},Gridlist={},Label={},Edit={},Image={},}

function sapdDuty_GUI4()
	if not isPedInVehicle(lp)then
		if getElementData(lp,"fraktion")==1 then
			if(getElementData(lp,"ElementClicked")==false)then
				showCursor(true)
				setElementData(lp,"ElementClicked",true)
				Duty.Window[1]=dgsCreateWindow(GLOBALscreenX/2-250/2,GLOBALscreenY/2-300/2,250,300,"Duty GUI",false,tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
				dgsWindowSetSizable(Duty.Window[1],false)
				dgsWindowSetMovable(Duty.Window[1],false)
				Duty.Button[1]=dgsCreateButton(224,-25,26,25,"×",false,Duty.Window[1],_,_,_,_,_,_,tocolor(200,50,50,255),tocolor(250,20,20,255),tocolor(150,50,50,255),true)
				Duty.Button[2]=dgsCreateButton(40,30,165,45,"Dienst antreten",false,Duty.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(10,10,10,255),true)
				Duty.Button[3]=dgsCreateButton(40,110,165,45,"Dienst verlassen",false,Duty.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(10,10,10,255),true)
				dgsSetProperty(Duty.Button[1],"textSize",{1.6,1.6})
				
				addEventHandler("onDgsMouseClick",Duty.Button[2],
					function(btn,state)
						if btn=="left" and state=="up" then
							triggerServerEvent("go:sapd_duty4",lp,lp)
						end
					end,
				false)
				
				addEventHandler("onDgsMouseClick",Duty.Button[3],
					function(btn,state)
						if btn=="left" and state=="up" then
							triggerServerEvent("gooff:sapd_duty4",lp,lp)
						end
					end,
				false)
				
				addEventHandler("onDgsMouseClick",Duty.Button[1],
					function(btn,state)
						if btn=="left" and state=="up" then
							dgsCloseWindow(Duty.Window[1])
							showCursor(false)
							setElementData(lp,"ElementClicked",false)
						end
					end,
				false)
				
			end
		end
	end
end
addEvent("open:sapd_duty_gui4",true)
addEventHandler("open:sapd_duty_gui4",getRootElement(),sapdDuty_GUI4)



copskins={
[288]=true,[283]=true,[280]=true,[281]=true,[266]=true,[284]=true
}
fbiskins={
[285]=true,[286]=true,[165]=true,[164]=true,[163]=true
}



function isOnStateDuty(player)
	local model = getElementModel(lp) 
	if copskins[model] or fbiskins[model] then return true else return false end
end