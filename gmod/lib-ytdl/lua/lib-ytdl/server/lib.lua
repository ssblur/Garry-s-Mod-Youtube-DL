--[[
	Youtube DL Library Server API
	Public functions for YTDL on the serverside.
]]

-- Console Variables.
-- So that the workshop version of this addon will work properly.
CreateConVar("lib_ytdl_address_verification", "http://127.0.0.1/youtube-dl", FCVAR_ARCHIVE)
CreateConVar("lib_ytdl_address_information", "http://127.0.0.1/youtube-dl/info.php", FCVAR_ARCHIVE)

lib_ytdl = lib_ytdl or {}
lib_ytdl.cached = lib_ytdl.cached or {}

local log = lib_ytdl.log

local function add_url( id, ply, interface )
	if type(interface)=="string" then
		lib_ytdl.call( interface, true, id, ply )
		if ply then
			net.Start("LibYTDLResponse")
				net.WriteString( interface )
				net.WriteBool( true )
				net.WriteString( id )
			net.Send(ply)
		end
	elseif type(interface)=="function" then
		log( "Interface is function: executing with success flag set to true." )
		interface( id, ply, true )
	end
end

local function fail( id, ply, interface, message )
	if type(interface)=="string" then
		lib_ytdl.call( interface, false, url, ply )
		if ply then
			net.Start("LibYTDLResponse")
				net.WriteString( interface )
				net.WriteBool( false )
				net.WriteString( url )
				net.WriteString( message )
			net.Send(ply)
		end
	elseif type(interface)=="function" then
		log( "Interface is function: executing with success flag set to false." )
		interface( id, ply, false, message )
	end
end

--[[
	lib_ytdl.queue_access
	Arguments:
		id - String. The id to attempt to queue.
		ply - Player / userdata. The player who is trying to queue this item.
		interface -	String. The id of the implementing interface. 
					Used for identifying and hooking into requests made on the interface.
					Function. A function to call on success, if not hooking in.
	Queues access to a url, then, if associated with a player, sends them the URL to stream from.
]]
function lib_ytdl.queue_access( id, ply, interface )
	local id = string.Trim(id)
	if lib_ytdl.cached[id] then 
		add_url(lib_ytdl.cached[id], ply) return
		add_url(id, ply, interface)
	end
	if ply then
		log("Received a request from "..ply:Name().." for "..id)
	end
	log("Posting request to "..GetConVar("lib_ytdl_address_verification"):GetString().."?id="..id)
	http.Fetch( GetConVar("lib_ytdl_address_verification"):GetString().."?id="..id , function( body )
		local trimmed = string.Trim(string.Trim(body, '\n'))
		log("Response received from server for "..id)
		log(body)
		if string.sub(trimmed, 0, 2)=="OK" then
			lib_ytdl.cached[id] = string.sub(trimmed, 4)
			add_url(string.sub(trimmed, 4), ply, interface)
		else
			fail(id, ply, interface, string.sub(trimmed, 4))
		end
	end, function(error) log("Failed to fetch song data:") log(error) end)
end

lib_ytdl.cached_info = lib_ytdl.cached_info or {}

local function get_info( data, ply, interface )
	local data = util.JSONToTable(data)
	local out = {}
	
	out.title = data[0].snippet.title
	out.channel = data[0].snippet.channelTitle
	out.thumbnail = data[0].snippet.thumbnails[0]
	
	lib_ytdl.info_call( interface, true, data, ply )
	net.Start("LibYTDLInfoResponse")
		net.WriteString( interface )
		net.WriteBool( true )
		net.WriteTable( out )
	net.Send(ply)
end

local function fail_info( url, ply, interface )
	lib_ytdl.info_call( interface, false, url, ply )
	net.Start("LibYTDLInfoResponse")
		net.WriteString( interface )
		net.WriteBool( false )
		net.WriteTable( url )
	net.Send(ply)
end

--[[
	lib_ytdl.get_information
	Arguments:
		url - String. The url to get information for.
		ply - Player / userdata. The player who is trying to get this information.
		interface -	Number, Optional. The numerical id for the requesting interface.
					Used for identifying and hooking into requests made on the interface.
	
]]
function lib_ytdl.get_information( url, ply, interface )

end