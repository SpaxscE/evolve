/*-------------------------------------------------------------------------------------------------------------------------
	Kick a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Dislike"
PLUGIN.Description = "Dislike a player."
PLUGIN.Author = "Luna"
PLUGIN.ChatCommand = "dislike"
PLUGIN.Usage = "<player>"
PLUGIN.Privileges = { "Dislike" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Dislike" ) ) then
		local pl = evolve:FindPlayer( args[1] )
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
			
		elseif ( #pl == 1 ) then
			if ( ply:EV_BetterThan( pl[1] ) ) then
				for _, v in ipairs( ents.GetAll() ) do
					if ( v:EV_GetOwner() == pl[1]:UniqueID() ) then v:Remove() end
				end
				
				pl[1]:StripWeapons()
				pl[1]:EV_SetRank( "bannedplayers" )
				pl[1]:SetMoveType( MOVETYPE_WALK )
				pl[1]:Spawn()
				
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has disliked ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, "." )
			else
				evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers2 )
			end
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "dislike", players[1] )
	else
		return "Dislike", evolve.category.administration
	end
end

evolve:RegisterPlugin( PLUGIN )