if SERVER then 
	util.AddNetworkString("GetServerDeadTime")
	
	local TimeDead = 18000
	
	net.Receive( "GetServerDeadTime", function( len, ply )
		local Time = os.time()
		local TimeSeconds = os.date( "%H", Time ) * 3600 + os.date( "%M", Time ) * 60 + os.date( "%S", Time )
		local ServerDeadTime = CurTime() + (TimeDead - TimeSeconds)
		
		if TimeSeconds > TimeDead then
			ServerDeadTime = CurTime() + (86400 - TimeSeconds) + TimeDead
		end
		
		net.Start("GetServerDeadTime")
			net.WriteFloat( ServerDeadTime )
		net.Send( ply )
	end)
	
	local SavedDeadTime
	hook.Add("Think","sheduled_restart", 
		function()
			if not SavedDeadTime then
				local Time = os.time()
				local TimeSeconds = os.date( "%H", Time ) * 3600 + os.date( "%M", Time ) * 60 + os.date( "%S", Time )
				SavedDeadTime = CurTime() + (TimeDead - TimeSeconds)
				
			else
				local DTime = SavedDeadTime - CurTime()

				if DTime <= 0 and DTime > -60 then
					RunConsoleCommand("_restart","")
				end
			end
		end
	)

	return
end

local zoom_mat = Material( "vgui/zoom" )

surface.CreateFont( "RESTARTER", {
	font = "Verdana",
	extended = false,
	size = 40,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

surface.CreateFont( "RESTARTER_TIME", {
	font = "Verdana",
	extended = false,
	size = 30,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

surface.CreateFont( "RESTARTER_TIME_SMALL", {
	font = "Verdana",
	extended = false,
	size = 15,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

local dramatic = {
	[1] = { Sound = "vo/npc/male01/gethellout.wav", Text = "SERVER RESTARTING!"},
	[2] = { Sound = "vo/npc/female01/gethellout.wav", Text = "SERVER RESTARTING!"},
	[3] = { Sound = "vo/ravenholm/exit_hurry.wav", Text = "HURRY WHILE I HOLD THE GATE!"},
	[4] = { Sound = "vo/npc/female01/runforyourlife01.wav", Text = "SAVE YOUR SHIT!"},
	[5] = { Sound = "vo/npc/female01/runforyourlife02.wav", Text = "DO PANIC! SERVER IS RESTARTING!"},
	[6] = { Sound = "vo/npc/male01/runforyourlife01.wav", Text = "SAVE YOUR SHIT!"},
	[7] = { Sound = "vo/npc/male01/runforyourlife02.wav", Text = "SAVE YOUR SHIT!"},
	[8] = { Sound = "vo/npc/male01/runforyourlife03.wav", Text = "DO PANIC! SERVER IS RESTARTING!"},
	[9] = { Sound = "vo/npc/female01/uhoh.wav", Text = "SERVER RESTART INCOMING!"},
	[10] = { Sound = "vo/npc/male01/uhoh.wav", Text = "SERVER RESTART INCOMING!"},
	[11] = { Sound = "vo/ravenholm/exit_hurry.wav", Text = "HURRY WHILE I HOLD THE GATE!"},
	[12] = { Sound = "scientist/c1a3_sci_silo1a.wav", Text = "SERVER RESTART INCOMING!"},
	[13] = { Sound = "scientist/c1a3_sci_silo2a.wav", Text = "SAVE YOUR SHIT!"},
	[14] = { Sound = "scientist/c3a2_sci_fool.wav", Text = "DO PANIC! SERVER IS RESTARTING!"},
}

local ServerDeadTime 

net.Receive( "GetServerDeadTime", function( len, ply )
	ServerDeadTime = net.ReadFloat()
end)

local PanicText = {}
local NextPanic = 0
local OnFirst = false
hook.Add("HUDPaint", "restart_message", function()
	local CTime = CurTime()
	
	if not ServerDeadTime then 
		if NextPanic < CTime then
			NextPanic = CTime + 0.2
			
			net.Start("GetServerDeadTime")
			net.SendToServer()
		end
		
		return
	end
	
	local DTime = ServerDeadTime - CTime
	
	local srcW = ScrW()
	local srcH = ScrH()

	if DTime > 121 or DTime < -60 then 
		local hours = string.format("%02.f", math.floor(DTime/3600))
		local mins = string.format("%02.f", math.floor(DTime/60 - (hours*60)))
		local secs = string.format("%02.f", math.floor(DTime - hours*3600 - mins *60))
		
		local n_min =  tonumber(mins)
		if n_min then
			local Col = n_min <= 5 and Color(255,255,0,255) or Color(255,255,255,255)
			
			draw.SimpleText( hours..":"..mins..":"..secs, "RESTARTER_TIME_SMALL", srcW - 2, 0, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		end
		
		if OnFirst then
			OnFirst = false
		end
		
		return
	end
	
	if not OnFirst then
		OnFirst = true
		
		surface.PlaySound( "rastasafari_countdown.mp3" ) 
		
		timer.Simple( 118, function() 
			surface.PlaySound( "vo/citadel/gman_exit10.wav" ) 
		end )
	end
	
	surface.SetDrawColor( math.abs( math.cos( CurTime() * 3 ) * 100 ),0,0,150 - (DTime / 120) * 130 )
	surface.DrawRect(0, 0, srcW, srcH)
	
	local X = srcW * 0.5
	local Y = srcH * 0.5
	
	if DTime >= 0 then
		draw.SimpleText( "SERVER RESTART IN:", "RESTARTER", X, Y, Color(255,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		
		local Sec = math.floor( DTime )
		local MSec = math.floor( (DTime - Sec) * 1000 )
		
		draw.SimpleText( Sec, "RESTARTER_TIME", X, Y, Color(255,0,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		draw.SimpleText( "."..MSec, "RESTARTER_TIME", X, Y, Color(255,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	else
		draw.SimpleText( "SERVER IS RESTARTING. PLEASE REJOIN IN A FEW MINUTES", "RESTARTER", X, Y, Color(255,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	end
	
	if DTime > 5 then
		if NextPanic < CTime then
			NextPanic = CTime + 0.2 + (DTime / 120)
			
			local message = dramatic[ math.random(1,table.Count( dramatic ) ) ]
			surface.PlaySound( message.Sound ) 
			
			local Dir = VectorRand()
			Dir.z = 0
			Dir = Dir:GetNormalized()
			
			local posX = X + Dir.x * (X * 0.5 + math.Rand(0,srcW * 0.2))
			local posY = Y + Dir.y * (Y * 0.5 + math.Rand(0,srcH * 0.2))
			
			table.insert( PanicText, {Time = (CTime + 6),Text = message.Text,X = posX, Y = posY} )
		end
	end


	for k, v in pairs( PanicText ) do
		local Alpha = (v.Time - CTime) * 255
		if Alpha >= 1 then
			draw.SimpleText( v.Text, "RESTARTER_TIME", v.X, v.Y, Color(255,0,0,Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			PanicText[k] = nil
		end
	end
	
	surface.SetDrawColor( Color(255,255,255,255) )
	surface.SetMaterial(zoom_mat ) 
	surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
	surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
	surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
	surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
end )
