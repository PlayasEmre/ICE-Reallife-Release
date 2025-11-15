--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local modsTable={
{txdpfad="texturensystem/BLITZER.txd",dffpfad="texturensystem/BLITZER.dff",colpfad="texturensystem/BLITZER.col",modelid=3890},
{txdpfad="texturensystem/sfsroads.txd",modelid=10983},
{txdpfad="texturensystem/silenced.txd",dffpfad="texturensystem/silenced.dff",modelid=347},
};

addEventHandler("onClientResourceStart",resourceRoot,function()
	for i=1,#modsTable do
		modelid=modsTable[i].modelid
		if modsTable[i].txdpfad~=nil then
			txd=engineLoadTXD(modsTable[i].txdpfad)
			engineImportTXD(txd,modelid)
		end
		if modsTable[i].dffpfad~=nil then
			dff=engineLoadDFF(modsTable[i].dffpfad,modelid)
			engineReplaceModel(dff,modelid)
		end
		if modsTable[i].colpfad~=nil then
			col=engineLoadCOL(modsTable[i].colpfad,modelid)
			engineReplaceCOL(col,modelid)
		end
	end
end)



--//Renderdistance\\--
local loadDistanceTable={
{3890,450}--Blitzer
}

addEventHandler("onClientResourceStart",resourceRoot,function()
	for _,v in pairs(loadDistanceTable)do
		engineSetModelLODDistance(v[1],v[2])
	end
end)