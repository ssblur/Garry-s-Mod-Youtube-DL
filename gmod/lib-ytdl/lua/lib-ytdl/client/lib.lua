--[[
	Youtube DL Library Client API
	Public functions for YTDL on the clientside.
]]

lib_ytdl = lib_ytdl or {}
lib_ytdl.cached = lib_ytdl.cached or {}

--[[
	lib_ytdl.queueAccess
	Arguments:
		url - 			String. The url to request access to.
		interface - 	Number. The numerical identifier for the calling interface.
		forced - 		Boolean, Optional. If true, this will be sent to the server regardless of local cache.
	Gets a URL for streaming this video as MP3.
	If the information is already cached, does not contact the server.
	If it is not, requests that information from the server.
]]
function lib_ytdl.queueAccess(url, interface, forced)
	local url = string.Trim(url)
	if lib_ytdl.cached[url] and not forced then
		lib_ytdl.call( interface, true, lib_ytdl.cached[url], LocalPlayer() )]
	else
		net.Start("LibYTDLRequest")
			net.WriteInt( interface, 32 )
			net.WriteString( url )
		net.SendToServer()
	end
end

--[[
	lib_ytdl.getInformation
	Arguments:
		url - 			String. The url to request information for.
		interface - 	Number. The numerical identifier for the calling interface.
		forced - 		Boolean, Optional. If true, this will be sent to the server regardless of local cache.
	Gets video information for the associated URL.
	If the information is already cached, does not contact the server.
	If it is not, requests that information from the server.
]]
function lib_ytdl.getInformation( url, interface, forced )

end