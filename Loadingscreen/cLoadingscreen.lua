--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local sx,sy = guiGetScreenSize()
loadingScreenShown = false
local ladezeit=3000
local start = nil
local bild = nil
local sound = nil
local Loading = {
	[1] = Tables.servername.."-Reallife wird regelmäßig\nweiter entwickelt!",
    [2] = "Changelog: Was gibt es Neues bei uns ?\nEs gibt nun eine neue Fahrschule",
	[3] = "Neuigkeiten: Wir besitzen auch eine Tactic Arena",
	[4] = "Neuigkeiten: Um das Grafik-Panel zu öffnen, \n drücken Sie einfach die F6-Taste",
}

function blendLoadingScreen_func()
	if not loadingScreenShown then
		loadingScreenShown = true
		showChat(false)
		showCursor(false)
		start = getTickCount()
		bild = math.random(1,2)
		number = math.random(1,#Loading)
		r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
		addEventHandler("onClientRender",getRootElement(),drawBlendingScreen)
		sound = playSound("Loadingscreen/song.mp3",false)
		setSoundVolume(sound, 0.6)
		setTimer(blendOutLoadingScreen_func,10000,1)
	end
end
addEvent("blendLoadingScreen",true)
addEventHandler("blendLoadingScreen",getRootElement(),blendLoadingScreen_func)

function blendOutLoadingScreen_func()
	if loadingScreenShown and isElement(sound) then
		destroyElement(sound)
		sound = nil
		loadingScreenShown = false
		showChat(true)
		removeEventHandler("onClientRender",getRootElement(),drawBlendingScreen)
	end	
end

function drawBlendingScreen()
	dxDrawImage(0,0,1920,1274,'Loadingscreen/'..bild..'.jpg',0,0,0, tocolor ( 255, 255, 255, 255 ))
	roundedRectangle(539, 255, 978, 560,tocolor(0, 0, 0, 185))
	roundedRectangle(539, 254, 978, 42,tocolor(0, 0, 1, 0))
	dxDrawText("Update und Neuigkeiten", 539, 265, 1517, 307, tocolor(255, 255, 255,255), 2.00, "default", "center", "center", false, false, true, false, false)
	roundedRectangle(1653, 999, 57, 0, tocolor(255, 255, 255, 255))
	roundedRectangle(1621, 971, 262, 69, tocolor(1, 0, 0, 113))
	dxDrawImage(1820, 973, 63, 67,"Loadingscreen/Loading.png",0-100*((start-getTickCount()-ladezeit)/1000),0,0,tocolor(255,255,255,255))
	dxDrawText("Deine Weit wird geladen", 1622, 972, 1817, 1037, tocolor(255, 255, 255, 255), 1.30, "default", "center", "center", false, false, false, false, false)
	roundedRectangle(539, 313, 978, 5, tocolor(r, g, b, 170))
	roundedRectangle(539, 255, 978, 5, tocolor(r, g, b, 170))
	dxDrawText(tostring(Loading[number]), 180, -300, sx, sy, tocolor(0,255,255,255), 3, "arial", "center", "center",false,false,true)
end