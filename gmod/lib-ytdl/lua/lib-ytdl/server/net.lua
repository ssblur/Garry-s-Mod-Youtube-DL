	--[[
	Youtube DL Server Networking
	For receiving cache requests and sending music URLs back to users.
	Exposes no public functions.
]]

util.AddNetworkString("LibYTDLRequest")
util.AddNetworkString("LibYTDLResponse")

net.Receive("LibYTDLRequest", function(length, ply)
	local interface = net.ReadString()
	local url = net.ReadString()
	lib_ytdl.queueAccess( url, ply, interface )
end)