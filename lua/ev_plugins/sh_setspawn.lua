local PLUGIN = {}
PLUGIN.Title = "Set spawnpoint"
PLUGIN.Description = "Sets a spawnpoint"
PLUGIN.Author = "Luna"
PLUGIN.ChatCommand = "setspawn"
PLUGIN.Privileges = { "Set Spawn" }

function PLUGIN:Call( ply, args )
	if ply:EV_HasPrivilege( "Set Spawn" ) then
		
		if not ply.EV_SpawnPos then
			ply.EV_SpawnPos = ply:GetPos()
			
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has ", evolve.colors.red, "set", evolve.colors.white, " a new ", evolve.colors.red,"spawnpoint" )
		else
			ply.EV_SpawnPos = nil
			
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has ", evolve.colors.red, "disabled", evolve.colors.white, " his/her ", evolve.colors.red,"spawnpoint" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerSpawn( ply )
	if isvector( ply.EV_SpawnPos ) then
		ply:SetPos( ply.EV_SpawnPos )
	end
end

evolve:RegisterPlugin( PLUGIN )