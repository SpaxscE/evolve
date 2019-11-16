local PLUGIN = {}
PLUGIN.Title = "Show Content"
PLUGIN.Description = "show workshop collection"
PLUGIN.Author = "Luna"
PLUGIN.ChatCommand = "content"

function PLUGIN:Call( ply, args )
	ply:SendLua( "gui.OpenURL( 'https://steamcommunity.com/sharedfiles/filedetails/?id=1905778871' )" )
end

evolve:RegisterPlugin( PLUGIN )