--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local Duty={Window={},Button={},Gridlist={},Label={},Edit={},Image={},}

function sapdDuty_GUI()
	if not isPedInVehicle(lp)then
		if getElementData(lp,"fraktion") == 1 then
			if(getElementData(lp,"ElementClicked")==false)then
				showCursor(true)
				setElementData(lp,"ElementClicked",true)
				Duty.Window[1]=dgsCreateWindow(GLOBALscreenX/2-250/2,GLOBALscreenY/2-300/2,250,300,"Duty GUI",false, tocolor(255,255,255),nil,nil,guimaincolor,nil,nil,nil,true)
				dgsWindowSetSizable(Duty.Window[1],false)
				dgsWindowSetMovable(Duty.Window[1],false)
				Duty.Button[1]=dgsCreateButton(224,-25,26,25,"×",false,Duty.Window[1],_,_,_,_,_,_,tocolor(200,50,50,255),tocolor(250,20,20,255),tocolor(150,50,50,255),true)
				Duty.Button[2]=dgsCreateButton(40,30,165,45,"Dienst antreten",false,Duty.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(10,10,10,255),true)
				Duty.Button[3]=dgsCreateButton(40,110,165,45,"Dienst verlassen",false,Duty.Window[1],_,_,_,_,_,_,tocolor(50,50,50,255),tocolor(90,90,90,255),tocolor(10,10,10,255),true)
				dgsSetProperty(Duty.Button[1],"textSize",{1.6,1.6})
				
				addEventHandler("onDgsMouseClick",Duty.Button[2],
					function(btn,state)
						if btn=="left" and state=="up" then
							triggerServerEvent("go:sapd_duty",lp,lp)
						end
					end,
				false)
				
				addEventHandler("onDgsMouseClick",Duty.Button[3],
					function(btn,state)
						if btn=="left" and state=="up" then
							triggerServerEvent("gooff:sapd_duty",lp,lp)
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
addEvent("open:sapd_duty_gui",true)
addEventHandler("open:sapd_duty_gui",getRootElement(),sapdDuty_GUI)



--//Dutyicons
--SAPD
addEventHandler("onClientRender",root,function()
	local x,y,z=getElementPosition(lp)
	local px,py,pz=-1611.5,679.3,-5.3
	if(getDistanceBetweenPoints3D(x,y,z,px,py,pz)<=12)and(isLineOfSightClear(x,y,z,px,py,pz,true,true,true,true,true))and getElementInterior(lp)==0 then
		local sx,sy=guiGetScreenSize()
		x,y=getScreenFromWorldPosition(px,py,pz)
		if(x)and(y)then
			local dis=getDistanceBetweenPoints3D(x,y,z,px,py,pz)
			x=x-20
			dxDrawText("Dienst",x,y,x,y,tocolor(0,0,0,200),1.5)
			dxDrawText("Dienst",x+1,y+1,x,y,tocolor(255,255,255,200),1.5)
		end
	end
end)
--SAPD2
addEventHandler("onClientRender",root,function()
	local x,y,z=getElementPosition(lp)
	local px,py,pz=259.6,110.6,1003
	if(getDistanceBetweenPoints3D(x,y,z,px,py,pz)<=12)and(isLineOfSightClear(x,y,z,px,py,pz,true,true,true,true,true))and getElementInterior(lp)==10 then
		local sx,sy=guiGetScreenSize()
		x,y=getScreenFromWorldPosition(px,py,pz)
		if(x)and(y)then
			local dis=getDistanceBetweenPoints3D(x,y,z,px,py,pz)
			x=x-20
			dxDrawText("Dienst",x,y,x,y,tocolor(0,0,0,200),1.5)
			dxDrawText("Dienst",x+1,y+1,x,y,tocolor(255,255,255,200),1.5)
		end
	end
end)
--FBI
addEventHandler("onClientRender",root,function()
	local x,y,z=getElementPosition(lp)
	local px,py,pz=325.2,305.2,999.1
	if(getDistanceBetweenPoints3D(x,y,z,px,py,pz)<=12)and(isLineOfSightClear(x,y,z,px,py,pz,true,true,true,true,true))and getElementInterior(lp)==5 then
		local sx,sy=guiGetScreenSize()
		x,y=getScreenFromWorldPosition(px,py,pz)
		if(x)and(y)then
			local dis=getDistanceBetweenPoints3D(x,y,z,px,py,pz)
			x=x-20
			dxDrawText("Dienst",x,y,x,y,tocolor(0,0,0,200),1.5)
			dxDrawText("Dienst",x+1,y+1,x,y,tocolor(255,255,255,200),1.5)
		end
	end
end)