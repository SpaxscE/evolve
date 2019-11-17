local PLUGIN = {}
PLUGIN.Title = "Build-mode"
PLUGIN.Description = "!pvp alias for dumb people"
PLUGIN.Author = "Luna"
PLUGIN.ChatCommand = "build"

function PLUGIN:Call( ply, args )
	if ply:EV_HasPrivilege( "PVP" ) then
		if ply:GetNWBool( "EV_PVPMode", false ) then
			ply:ConCommand( "ev pvp "..ply:GetName().." 0" )
		end
	end
end

evolve:RegisterPlugin( PLUGIN )