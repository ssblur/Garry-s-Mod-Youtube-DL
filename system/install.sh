#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Error: May not work properly unless run as root! [sudo $0]"
fi
add-apt-repository -y ppa:mc3man/trusty-media
apt-get upgrade
apt-get -y install curl python3.5 libav-tools openssl
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


curl https://pemery.co/youtube-dl.tar.gz -o ./web.tar.gz
tar xvzf web.tar.gz -C $web_directory
chmod 