#!/bin/bash
echo "----------------------------------------------------------"
echo "|  _______  __   __  __   __  _______  ______   ___      |"
echo "| |       ||  |_|  ||  | |  ||       ||      | |   |     |"
echo "| |    ___||       ||  |_|  ||_     _||  _    ||   |     |"
echo "| |   | __ |       ||       |  |   |  | | |   ||   |     |"
echo "| |   ||  ||       ||_     _|  |   |  | |_|   ||   |___  |"
echo "| |   |_| || ||_|| |  |   |    |   |  |       ||       | |"
echo "| |_______||_|   |_|  |___|    |___|  |______| |_______| |"
echo "----------------------------------------------------------"
echo "- The web half of the Garry's Mod youtube-dl             -"
echo "- compatibility module.                                  -"
echo "----------------------------------------------------------"

# Check if this is being run as root or with sudo. If not, print a warning and offer to restart with permissions.
if [ "$EUID" -ne 0 ]; then 
	echo "Error: May not work properly unless run as root! [sudo $0]"
	echo "Would you like to continue without permissions? [Y/n]"
	read response
	
	if [ "$response" -eq "n" ]; then
		echo "Restarting with permissions..."
		sudo $0
		exit
	fi
	
	while [ "$response" -ne "Y" ]; do
		echo "Sorry, that response is not valid."
		echo "Error: May not work properly unless run as root! [sudo $0]"
		echo "Would you like to continue without permissions? [Y/n]"
		read response
		
		if [ "$response" -eq "n" ]; then
			echo "Restarting with permissions..."
			sudo $0
			exit
		fi
	done
fi

# Install or update required packages with Aptitude, if it exists.
if hash apt 2>/dev/null; then
	add-apt-repository -y ppa:mc3man/trusty-media
	apt-get upgrade
	apt-get -y install curl python3.5 libav-tools openssl
else
	echo "Aptitude not installed; likely not on Ubuntu or Debian."
	echo "To proceed, you must have Curl, Python 3.2+, openssl, and either libav-tools or ffmpeg and ffprobe."
	if ! hash curl 2>/dev/null; then echo "curl not installed, install the curl package with your package manager."; exit; fi
	if ! hash python 2>/dev/null; then echo "Python not installed, install the python3.5 package with your package manager."; exit; fi
	if ! hash openssl 2>/dev/null; then echo "OpenSSL not installed, install the openssl package with your package manager."; exit; fi
fi

# Install or update youtube-dl.
echo "Installing / updating youtube-dl..."
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl
echo "youtube-dl installed."

# Read or import the web directory to install to.
if [ -e /usr/share/gmod-youtube-dl/web_directory ]; then
	web_user=$(</usr/share/gmod-youtube-dl/web_directory)
	echo "Imported web directory from previous install."
else
	echo "Please enter your preferred web directory [/var/www/html/youtube-dl]"
	read web_directory
	if [ -z "$web_user" ]; then
			web_directory="www-data"
	fi
fi

# Read or import the web user to give permissions to.
if [ -e /usr/share/gmod-youtube-dl/web_user ]; then
	web_user=$(</usr/share/gmod-youtube-dl/web_user)
	echo "Imported web user from previous install."
else
	echo "Please verify which user owns your web directory [www-data]"
	read web_user
	if [ -z "$web_user" ]; then
			web_user="www-data"
	fi
fi

# Save preferences for later.
mkdir /usr/share/gmod-youtube-dl -p
echo $web_user>/usr/share/gmod-youtube-dl/web_user
echo $web_directory>/usr/share/gmod-youtube-dl/web_directory

# Make the directory for the website, if it doesn't exist.
mkdir -p "$web_directory"
curl https://gitlab.ssblur.com/api/v4/projects/10/jobs/artifacts/master/raw/web.tar.gz?job=build_web -o /var/tmp/web.tar.gz

# Back up the whitelist, if it already exists.
if [ -e "$web_directory/config.json" ]; then
	cp "$web_directory/config.json" "/var/tmp/gmytdl_config.json"
fi

tar xvzf /var/tmp/web.tar.gz -C $web_directory
chmod 755 $web_directory -R
chown $web_user: $web_directory -R
rm /var/tmp/web.tar.gz

# Restore the whitelist backup, if we made one.
if [ -e "/var/tmp/gmytdl_config.json" ]; then
	cp "/var/tmp/gmytdl_config.json" "$web_directory/config.json"
	rm "/var/tmp/gmytdl_config.json"
fi
