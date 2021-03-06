--[[
	Youtube DL Library
	Garry's Mod module for playing youtube videos as mp3s.
]]
AddCSLuaFile()
print("Loading Youtube Download Library.")


AddCSLuaFile("lib-ytdl/shared/lib.lua")
AddCSLuaFile("lib-ytdl/shared/log.lua")

include("lib-ytdl/shared/lib.lua")
include("lib-ytdl/shared/log.lua")

if SERVER then
	include("lib-ytdl/server/lib.lua")
	include("lib-ytdl/server/net.lua")

	AddCSLuaFile("lib-ytdl/client/lib.lua")
	AddCSLuaFile("lib-ytdl/client/net.lua")
elseif CLIENT then
	include("lib-ytdl/client/lib.lua")
	include("lib-ytdl/client/net.lua")
end