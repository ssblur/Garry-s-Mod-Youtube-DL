--[[
	Youtube DL Library Server API
	Public functions for YTDL on the serverside.
]]
include("/config/youtube-dl.lua")

lib_ytdl = lib_ytdl or {}
lib_ytdl.cached = lib_ytdl.cached or {}

local function add_url( id, ply, interface )
	lib_ytdl.call( interface, true, id, ply )]
	net.Start("LibYTDLResponse")
		net.WriteInt( interface, 32 )
		net.WriteBool( true )
		net.WriteString( id )
	net.Send(ply)
end

local function fail( url, ply, interface )
	lib_ytdl.call( interface, false, url, ply )
	net.Start("LibYTDLResponse")
		net.WriteInt( interface, 32 )
		net.WriteBool( false )
		net.WriteString( url )
	net.Send(ply)
end

--[[
	lib_ytdl.queueAccess
	Arguments:
		url - String. The url to attempt to queue.
		ply - Player / userdata. The player who is trying to queue this item.
		interface -	Number, Optional. The numerical id for the requesting interface. 
					Used for identifying and hooking into requests made on the interface.
	Queues access to a url, then, if associated with a player, sends them the URL to stream from.
]]
function lib_ytdl.queueAccess( url, ply, interface )
	local url = string.Trim(url)
	if lib_ytdl.cached[url] then add_url(lib_ytdl.cached[url], ply) return end
	http.Fetch( lib_ytdl_config.address_verification.."?url="..util.Base64Encode(url) , function( body )
		local trimmed = string.Trim(string.Trim(body, '\n'))
		if string.StartsWith(trimmed, "OK") then
		lib_ytdl.cached[url] = string.sub(trimmed, 4)
			add_url(string.sub(trimmed, 4), ply, interface)
		else
			fail(url, ply, interface)
		end
	end)
end

lib_ytdl.cached_info = lib_ytdl.cached_info or {}

local function get_info( data, ply, interface )

end

local function fail_info( url, ply, interface )

end

--[[
	lib_ytdl.getInformation
	Arguments:
		url - String. The url to get information for.
		ply - Player / userdata. The player who is trying to get this information.
		interface -	Number, Optional. The numerical id for the requesting interface.
					Used for identifying and hooking into requests made on the interface.
	
]]
function lib_ytdl.getInformation( url, ply, interface )

end