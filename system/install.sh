#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Error: May not work properly unless run as root! [sudo $0]"
fi
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
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl

echo "Please enter your preferred web directory [/var/www/html/youtube-dl]"
read web_directory
if [ -z "$web_directory" ]
	then
		web_directory="/var/www/html/youtube-dl"
fi

echo "Please verify which user owns your web directory [www-data]"
read web_user
if [ -z "$web_user" ]
	then
		web_user="www-data"
fi

mkdir -p "$web_directory"
curl https://gitlab.ssblur.com/api/v4/projects/10/jobs/artifacts/master/raw/web.tar.gz?job=build_web -o ./web.tar.gz
tar xvzf web.tar.gz -C $web_directory
chmod 755 $web_directory -R
chown $web_user: $web_directory -R