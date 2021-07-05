/*-------------------------------------------------------------------------------------------------------------------------
	Gimp a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Gimp"
PLUGIN.Description = "Gimp a player."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "gimp"
PLUGIN.Usage = "[players]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			pl.EV_Gimped = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has gimped ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has ungimped ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "gimp", unpack( players ) )
	else
		return "Gimp", evolve.category.punishment, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

-- The messages
PLUGIN.GimpMessages = {
	"How do you fly?",
	"CAPS LOCK IS CRUISE CONTROL FOR COOL",
	"Wut",
	"What",
	"Wat",
	"Whut",
	"Lol",
	"Lolz",
	"Lul",
	"Lulz",
	"Blah, blah, blah...",
	"Words, words, words...",
	"The cake is a LIE!",
	"GIMME CAKE!",
	"Admunz r teh pwn!",
	"I love carpet",
	"I love desk",
	"I love lamp",
	"I love cieling",
	"Are you garry?",
	"Mmmmmkay",
	"I dun da sumz, we can haz nuder cheezburgah",
	"I love it when teh admun physgunz meh!",
	"I love bein gimped by teh admun!",
	"MAI BOI",
	"ACTAUL",
}

function PLUGIN:PlayerSay( ply, Msg )
	if (ply.EV_Gimped) then
		local Msg = table.Random(self.GimpMessages) -- Get a random message
		return Msg -- Change the message
	end
end	

evolve:RegisterPlugin( PLUGIN )

