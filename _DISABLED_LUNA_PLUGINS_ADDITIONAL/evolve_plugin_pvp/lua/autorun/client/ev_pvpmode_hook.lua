local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add( "HUDShouldDraw", "ev_pvpmode_HideHUD", function( name )
	local ply = LocalPlayer()
	
	local PVP = ply:GetNWBool( "EV_PVPMode", false ) 
	
	if not PVP then return end
	
	if hide[ name ] then return false end
end )
