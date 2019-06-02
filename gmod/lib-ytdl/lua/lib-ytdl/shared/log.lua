--[[
	Youtube DL Logger
	For logging information appropriately.
]]

if SERVER then
	CreateConVar("lib_ytdl_debug", 0)
elseif CLIENT then
	CreateClientConVar("lib_ytdl_debug", 0)
end

lib_ytdl = lib_ytdl or {}
lib_ytdl.log = {}

function lib_ytdl.log( message, priority )
	if priority or GetConVar("lib_ytdl_debug"):GetBool() then
		print("[lib-ytdl] "..(message or ""))
	end
end