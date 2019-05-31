# Youtube-DL Server and Addon for Garry's Mod

*A simple implementation of youtube-dl for Garry's Mod and the companion, for use on webservers*

## Issues

Having an issue with the library? Use the attached issue tracker and I will try to sort it out ASAP!

## Setup Assistance

If, for any reason you are unable to set up this addon, feel free to contact [gmod@pemery.co](mailto:gmod@pemery.co). Any issues caused by deficiencies in the library will be resolved free of charge, and I'm happy to set this up on other servers or with custom features!

## Setup Instructions (Linux):

1. Add gmod/lib-ytdl folder to Garry's Mod addons folder or the steam workshop at [WIP]().
	* If not running a machine with Aptitude as the package manager, install the following packages:
		* curl
		* python3.5 (preferred, any Python 3.2+ install works)
		* libavtools OR ffmpeg and ffprobe (Depending on system and package availability.)
		* openssl
2. Download and run install.sh on your machine.
	* If you cannot or do not wish to run this on your machine, do the following:
		1. Install all packages noted above.
		2. Download the binary at https://yt-dl.org/downloads/latest/youtube-dl to /usr/bin or /usr/local/bin
			* curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
		3. Modify permissions on the binary to allow reading and execution.
			* chmod a+rx /usr/local/bin/youtube-dl
		4. Download the system/web folder into a directory on your webserver.
			* Alternatively, download the file at https://pemery.co/youtube-dl.tar.gz and extract it into the web directory.
		5. Modify permissions and ownership on this directory to allow reading, writing, and execution by your web user (usually www-data).
			* chmod 755 /var/www/html/yt -R
			* chown www-data: /var/www/html/yt -R
3. Modify the Garry's Mod config file in youtube-dl/lua/config/youtube-dl to point to your webserver.
	* Set lib_ytdl_config.address_verification to the root directory or index.php.
		* e.g. lib_ytdl_config.address_verification = "http://127.0.0.1/yt"
	* Set lib_ytdl_config.address_information to info.php.
		* e.g. lib_ytdl_config.address_information = "http://127.0.0.1/yt/info.php"
	* Set lib_ytdl_config.music_directory to /music, or, if using the alternate version, your music php. If using the public release, only use the first version.
		* e.g. lib_ytdl_config.music_directory = "http://127.0.0.1/yt/music"
		* Alternate: lib_ytdl_config.music_directory = "http://127.0.0.1/yt/music.php?id="
4. Enjoy! Now addons can happily stream music from YouTube without ads!