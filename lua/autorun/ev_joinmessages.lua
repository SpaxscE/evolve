if CLIENT then
	hook.Add( "ChatText", "hide_joinleave", function( index, name, text, typ )
		if ( typ == "joinleave" ) then return true end
	end )

	net.Receive( "join_n_leave_msg", function( length )
		local name = net.ReadString()

		surface.PlaySound("garrysmod/ui_hover.wav")

		chat.AddText(Color(98,176,255),"",Color(98,176,255),name,Color(255, 255, 255)," is",Color(255,62,62,255)," joining ",Color(255, 255, 255),"the server!")
	end )

	gameevent.Listen( "player_disconnect" )
	hook.Add( "player_disconnect", "player_disconnect_example", function( data )
		local name = data.name
		local steamid = data.networkid
		local id = data.userid
		local bot = data.bot
		local reason = data.reason

		surface.PlaySound("garrysmod/ui_hover.wav")

		chat.AddText(Color(98,176,255),"",Color(98,176,255),name,Color(255, 255, 255)," has",Color(255,62,62,255)," left ",Color(255, 255, 255),"the server! ("..reason..")")
	end )
end

if SERVER then
	util.AddNetworkString( "join_n_leave_msg" )

	local function PlyConnectMSG( name, ip )
		net.Start( "join_n_leave_msg" )
			net.WriteString( name )
		net.Broadcast()
	end
	hook.Add( "PlayerConnect", "PlyConnectMSG", PlyConnectMSG )
end