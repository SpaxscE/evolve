hook.Add( "SpawnMenuOpen", "ev_spawnmenuban", function()
	local ply = LocalPlayer()
	
	if ply:EV_GetRank():lower() == "bannedplayers" then
		ply:PrintMessage( HUD_PRINTTALK, "Q-Menu is not available for disrespected players." )
		
		return false
	end
end )

hook.Add( "ContextMenuOpen", "ev_contextmenuban", function()
	local ply = LocalPlayer()
	
	if ply:EV_GetRank():lower() == "bannedplayers" then
		ply:PrintMessage( HUD_PRINTTALK, "C-Menu is not available for disrespected players." )
		
		return false
	end
end )