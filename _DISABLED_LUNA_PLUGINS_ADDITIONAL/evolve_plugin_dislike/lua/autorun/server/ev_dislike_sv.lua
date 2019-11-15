hook.Add( "PlayerSpawnProp", "ev_spawnban", function( ply, mdl )
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )

hook.Add( "PlayerSpawnEffect", "ev_spawnban", function( ply, mdl )
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )

hook.Add( "PlayerSpawnNPC", "ev_spawnban", function( ply, npc_type, weapon )
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )

hook.Add( "PlayerSpawnObject", "ev_spawnban", function( ply, mdl, skin )
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )

hook.Add( "PlayerSpawnRagdoll", "ev_spawnban", function( ply, mdl )
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )

hook.Add( "PlayerSpawnSENT", "ev_spawnban", function( ply, class )
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )

hook.Add( "PlayerSpawnSWEP", "ev_spawnban", function( ply, weapon, swep ) 
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )

hook.Add( "PlayerSpawnVehicle", "ev_spawnban", function( ply, mdl, name, vtable ) 
	if ply:EV_GetRank():lower() == "bannedplayers" then
		return false
	end
end )
