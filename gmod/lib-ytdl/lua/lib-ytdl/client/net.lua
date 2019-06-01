--[[
	Youtube DL Client Networking
	For receiving requested URLs and sending requests to the server.
]]

net.Receive("LibYTDLResponse", function(length, ply)
	local interface = net.ReadString()
	local success = net.ReadBool()
	local id = net.ReadString()
	lib_ytdl.call( interface, success, id, ply )
end)