/*-------------------------------------------------------------------------------------------------------------------------
	Reload the map
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Reload"
PLUGIN.Description = "Reload the map."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "reload"
PLUGIN.Privileges = { "Map reload" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Map reload" ) ) then
		if not ev_reloadShed then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has scheduled a map reload in 120 seconds." )
			
			ev_reloadShed = true
			
			net.Start("GetServerDeadTime")
				net.WriteFloat( CurTime() + 120 )
			net.Broadcast()
			
			timer.Simple( 120, function() 
				local saveRequired = false
				for _, pl in ipairs( player.GetAll() ) do
					pl:SetProperty( "LastJoin", os.time() )
					saveRequired = true
				end
				if ( saveRequired ) then evolve:CommitProperties() end
				
				RunConsoleCommand( "changelevel", game.GetMap() )
			end)
		else
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has reloaded the map." )
			
			local saveRequired = false
			for _, pl in ipairs( player.GetAll() ) do
				pl:SetProperty( "LastJoin", os.time() )
				saveRequired = true
			end
			if ( saveRequired ) then evolve:CommitProperties() end
			
			RunConsoleCommand( "changelevel", game.GetMap() )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )