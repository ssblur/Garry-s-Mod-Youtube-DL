--[[
	Youtube DL Server Networking
	For receiving cache requests and sending music URLs back to users.
	Exposes no public functions.
]]

util.AddNetworkString("LibYTDLRequest")
util.AddNetworkString("LibYTDLResponse")

util.AddNetworkString("LibYTDLInfoRequest")
util.AddNetworkString("LibYTDLInfoResponse")

net.Receive("LibYTDLRequest", function(length, ply)
	local interface = net.ReadString()
	local url = net.ReadString()
	lib_ytdl.queue_access( url, ply, interface )
end)