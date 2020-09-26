# NOTA BENE
This module is poorly implemented an dbased heavily on specific client specifications. Source is available for educational reasons, this should generally not be used, especially in production.

# Youtube-DL Server and Addon for Garry's Mod

*A simple implementation of youtube-dl for Garry's Mod and the companion, for use on webservers*

## Disclaimer

This is a work in progress, but maintains basic function. Full documentation is not finished, and some advanced features may not perform as expected.

## Issues

Having an issue with the library? Use the attached issue tracker and I will try to sort it out ASAP!

## Setup Assistance

If, for any reason you are unable to set up this addon, feel free to contact [info@pemery.co](mailto:info@pemery.co). Any issues caused by deficiencies in the library will be resolved free of charge, and I'm happy to set this up on other servers or with custom features!

## Setup Instructions (Linux):

1. Add gmod/lib-ytdl folder to Garry's Mod addons folder.
	* If not running a machine with Aptitude as the package manager, install the following packages:
		* curl
		* python3.5 (preferred, any Python 3.2+ install works)
		* libavtools OR ffmpeg and ffprobe (Depending on system and package availability.)
		* openssl
		* php5
2. Download and run install.sh on your machine.
	* If you cannot or do not wish to run this on your machine, do the following:
		1. Install all packages noted above.
		2. Download the binary at https://yt-dl.org/downloads/latest/youtube-dl to /usr/bin or /usr/local/bin
			* curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
		3. Modify permissions on the binary to allow reading and execution.
			* chmod a+rx /usr/local/bin/youtube-dl
		4. Download the system/web folder into a directory on your webserver.
		5. Modify permissions and ownership on this directory to allow reading, writing, and execution by your web user (usually www-data).
			* chmod 755 /var/www/html/yt -R
			* chown www-data: /var/www/html/yt -R
3. Set ConVars to point to your webserver. These will be automatically archived if set in-game.
	* Set lib_ytdl_address_verification to the root directory or index.php.
		* e.g. lib_ytdl_address_verification = "http://127.0.0.1/youtube-dl"
	* Set lib_ytdl_address_information to info.php.
		* e.g. lib_ytdl_address_information = "http://127.0.0.1/youtube-dl/info.php"
	* Set lib_ytdl_music_directory to /music, or, if using the alternate version, your music php. If using the public release, only use the first version.
		* e.g. lib_ytdl_music_directory = "http://127.0.0.1/youtube-dl/music"
		* Alternate: lib_ytdl_music_directory = "http://127.0.0.1/youtube-dl/music.php?id="
4. Add your Garry's Mod server to whitelist.json in the web directory.
	* Not necessary if they are on the same machine.
5. Enjoy! Now addons can happily stream music from YouTube without ads!
