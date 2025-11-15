--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

local function gang_func ( player, _, cmd, ... )

	executeCommandHandler ( gang..cmd, player, ... )
end
addCommandHandler ( "gang", gang_func )