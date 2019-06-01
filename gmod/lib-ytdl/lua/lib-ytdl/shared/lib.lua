--[[
	Youtube DL Library Shared API
	Public functions for YTDL on both sides.
]]

lib_ytdl = lib_ytdl or {}
CreateConVar("lib_ytdl_music_directory", "http://127.0.0.1/youtube-dl/music/", FCVAR_ARCHIVE+FCVAR_REPLICATED)

local interface_hooks = {}
interface_hooks[0] = {}
--[[
	lib_ytdl.hook
	Arguments:
		interface -	String. The interface this is hooking onto.
					If this is 0, this will run on ALL interfaces.
		callback -	Function. A callback, run on the requesting client and on the server.
					Arguments:
						url - String. The url of the mp3 to stream.
						ply - Player / userdata. The player who queued this song.
		failure -	Function. A callback, run on failure on the requesting client and the server.
					Arguments:
						url - String. The url which failed to load.
						ply - Player / userdata. The player who queued the song.
	Hooks a function onto an interface.
]]
function lib_ytdl.hook( interface, callback, failure )
	interface_hooks[interface] = interface_hooks[interface] or {}
	interface_hooks[interface][#interface_hooks[interface]+1] = {callback = callback, failure = failure}
end

--[[
	lib_ytdl.call
	Arguments:
		interface -	String. The interface to call functions for.
		success -	Boolean. Whether the operation succeeded.
		url -		String. The url to stream if succeeded, or the attempted url if failed.
		ply - 		Player / userdata. The Player who queued the song.
	Calls hooked functions on one interface.
]]
function lib_ytdl.call( interface, success, url, ply )
	if success then
		if interface_hooks[interface] then
			for k,v in pairs(interface_hooks[interface]) do
				if v.callback and v.callback( url, ply ) then return end
			end
		end
		for k,v in pairs(interface_hooks[0]) do
			if v.callback and v.callback( url, ply ) then return end
		end
	else
		if interface_hooks[interface] then
			for k,v in pairs(interface_hooks[interface]) do
				if v.failure and v.failure( url, ply ) then return end
			end
		end
		for k,v in pairs(interface_hooks[0]) do
			if v.failure and v.failure( url, ply ) then return end
		end
	end
end

local interface_info_hooks = {}
interface_info_hooks[0] = {}
--[[
	lib_ytdl.hook
	Arguments:
		interface -	String. The interface this is hooking onto.
					If this is 0, this will run on ALL interfaces.
		callback -	Function. A callback, run on the requesting client and on the server.
					Arguments:
						info - Object. A JSON-like object which contains certain info about the video.
						ply - Player / userdata. The player who requested this info, if any.
		failure -	Function. A callback, run on failure on the requesting client and the server.
					Arguments:
						url - String. The url which failed to load.
						ply - Player / userdata. The player who queued the song.
	Hooks a function onto an interface for video information.
]]
function lib_ytdl.info_hook( interface, callback, failure )
	interface_info_hooks[interface] = interface_info_hooks[interface] or {}
	interface_info_hooks[interface][#interface_info_hooks[interface]+1] = {callback = callback, failure = failure}
end

--[[
	lib_ytdl.call
	Arguments:
		interface -	Number. The interface to call functions for.
		success -	Boolean. Whether the operation succeeded.
		data -		String / Object. The video info if succeeded, or the attempted url if failed.
		ply - 		Player / userdata. The Player who queued the song.
	Calls hooked functions on one interface for video information.
]]
function lib_ytdl.info_call( interface, success, data, ply )
	if success then
		if interface_info_hooks[interface] then
			for k,v in pairs(interface_info_hooks[interface]) do
				if v.callback and v.callback( data, ply ) then return end
			end
		end
		for k,v in pairs(interface_info_hooks[0]) do
			if v.callback and v.callback( data, ply ) then return end
		end
	else
		if interface_info_hooks[interface] then
			for k,v in pairs(interface_info_hooks[interface]) do
				if v.failure and v.failure( data, ply ) then return end
			end
		end
		for k,v in pairs(interface_info_hooks[0]) do
			if v.failure and v.failure( data, ply ) then return end
		end
	end
end

--[[
	lib_ytdl.get_url
	Arguments:
		id - String. The video ID to construct a URL for.
	Returns:
		String. A URL, generated from the music directory.
]]
function lib_ytdl.get_url( id )
	return GetConVar("lib_ytdl_music_directory"):GetString()..id..".ogg"
end