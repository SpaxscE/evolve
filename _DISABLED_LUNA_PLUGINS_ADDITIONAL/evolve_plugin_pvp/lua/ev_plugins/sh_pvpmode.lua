/*-------------------------------------------------------------------------------------------------------------------------
	Enable godmode for a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "PVP-mode"
PLUGIN.Description = "Enable pvp-mode for a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "pvp"
PLUGIN.Usage = "[players] [1/0]"
PLUGIN.Privileges = { "PVP" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "PVP" ) ) then
		local players = {}
		local enabled = ( tonumber( args[ #args ] ) or 1 ) > 0
		
		for _, pl in ipairs( evolve:FindPlayer( args, ply, true ) ) do
			if ply:EV_IsAdmin() or ply:EV_GetRank() ~= pl:EV_GetRank() or ply == pl then
				players[#players+1] = pl
				
				if enabled then pl:GodDisable() else pl:GodEnable() end
				pl:SetNWBool( "EV_GodMode", not enabled ) 
				pl:SetNWBool( "EV_PVPMode", enabled ) 
			end
		end
				
		if ( #players > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has enabled pvp-mode for ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has disabled pvp-mode for ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerInitialSpawn(ply)
	ply:SetNWBool( "EV_GodMode", true ) 
	ply:GodEnable()
end

function PLUGIN:PlayerSpawn( ply )
	if ply:GetNWBool( "EV_PVPMode", false ) then
		ply:GodDisable()
		pl:SetNWBool( "EV_GodMode", false ) 
	end
end

function PLUGIN:PlayerNoClip( ply, desiredNoClipState )
	if desiredNoClipState then
	
		local PVP = ply:GetNWBool( "EV_PVPMode", false ) 

		if PVP then 
			if SERVER then
				ply:PrintMessage( HUD_PRINTTALK, "Noclip is restricted in PVP-Mode. Join Buildmode by using !pvp "..ply:GetName().." 0")
			end
			return false
		end
	end
end

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

function PLUGIN:HUDShouldDraw( name )
	local ply = LocalPlayer()
	
	if ply:GetNWBool( "EV_PVPMode", false )  then return end
	if not ply:GetNWBool( "EV_GodMode", false ) then return end
	
	if hide[ name ] then return false end
end


function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "pvp", unpack( players ) )
	else
		return "pvpmode", evolve.category.actions, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:RegisterPlugin( PLUGIN )