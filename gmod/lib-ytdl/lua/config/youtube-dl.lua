--[[
	Youtube DL Config
	Allows static configuration of the youtube-dl lua library.
]]

lib_ytdl_config = {}

-- The page to begin downloads for or check presence of cached mp3s.
lib_ytdl_config.address_verification = "http://127.0.0.1/yt"
-- The page to get video information from.
lib_ytdl_config.address_information = "http://127.0.0.1/yt/info.php"
-- The directory or prefix to access cached mp3s.
lib_ytdl_config.music_directory = "http://127.0.0.1/yt/music"