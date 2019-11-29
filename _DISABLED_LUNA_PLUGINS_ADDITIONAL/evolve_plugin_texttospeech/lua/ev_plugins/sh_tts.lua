local PLUGIN = {}
PLUGIN.Title = "TTS"
PLUGIN.Description = "Text To Speech."
PLUGIN.Author = "Luna / Blu"
PLUGIN.ChatCommand = "tts"
PLUGIN.Usage = "<text>"
PLUGIN.Privileges = { "Text to Speech" }

function PLUGIN:Call( ply, args )
	if ply:EV_HasPrivilege( "Text to Speech" ) then
		local text = table.concat( args, " " )
		
		if #text > 0 then
			if ( ply.EV_NextTTS or 0 ) < CurTime() then
				ply.EV_NextTTS = CurTime() + 1
				
				net.Start("ev_plugin_tts")
					net.WriteEntity( ply )
					net.WriteString( text )
				net.Broadcast()
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )

if SERVER then
	util.AddNetworkString( "ev_plugin_tts" )
end

if CLIENT then
	net.Receive( "ev_plugin_tts", function( len )
		local ply = net.ReadEntity()
		local text = net.ReadString()
		
		if not IsValid( ply ) then return end
		
		sound.PlayURL("http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=" .. text .. "&tl=en", "3d", 
			function(chan, num, str)
				if IsValid( chan ) then
					chan:SetPos( ply:GetShootPos() )
					chan:Play()
				end
			end
		)
	end )
end