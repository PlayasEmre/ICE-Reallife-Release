--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

function setPlayerLoggedIn ( name )
	dbExecAsync ( handler, "UPDATE loggedin SET ?? = ? WHERE UID=?", "Loggedin", "1", playerUID[name] )
end

function removePlayerFromLoggedIn ( name )
	dbExecAsync ( handler, "DELETE FROM loggedin WHERE UID=?", playerUID[name] )
end

function deleteAllFromLoggedIn ()
	dbExecAsync ( handler, "TRUNCATE TABLE loggedin" )
end
deleteAllFromLoggedIn ()