if CLIENT then
	hook.Add( "ChatText", "hide_joinleave", function( index, name, text, typ )
		if ( typ == "joinleave" ) then return true end
	end )

	net.Receive( "join_n_leave_msg", function( length )
		local name = net.ReadString()
		local mode = net.ReadString()
		
		surface.PlaySound("garrysmod/ui_hover.wav")
		
		if mode == "join" then
			chat.AddText(Color(98,176,255),"",Color(98,176,255),name,Color(255, 255, 255)," is",Color(255,62,62,255)," joining ",Color(255, 255, 255),"the server!")
			
		elseif mode == "disconnect" then
		
			chat.AddText(Color(98,176,255),"",Color(98,176,255),name,Color(255, 255, 255)," has",Color(255,62,62,255)," left ",Color(255, 255, 255),"the server!")
		end
	end )
end

if SERVER then
	util.AddNetworkString( "join_n_leave_msg" )

	local function PlyConnectMSG( name )
		net.Start( "join_n_leave_msg" )
			net.WriteString( name )
			net.WriteString( "join" )
		net.Broadcast()
	end
	hook.Add( "PlayerConnect", "PlyConnectMSG", PlyConnectMSG )

	local function PlyDisconnectMSG( ply )
		net.Start( "join_n_leave_msg" )
			net.WriteString( ply:GetName() )
			net.WriteString( "disconnect" )
		net.Broadcast()
	end
	hook.Add( "PlayerDisconnected", "PlyDisconnectMSG", PlyDisconnectMSG )
end