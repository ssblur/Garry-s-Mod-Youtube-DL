<?php
	## Helper function for checking whether an IP is in the whitelist.
	function in($entry, $array) {
		foreach ($array as $compare) {
			if (ip2long($compare)==ip2long($entry)) {
				return true;
			}
		}
		return false;
	}
	$json = json_decode(file_get_contents('whitelist.json'), true);
	$config = json_decode(file_get_contents('config.json'), true);
	
	$ip = $_SERVER['REMOTE_ADDR'];
	if( !empty($ip) and in($ip, $json)==$config["whitelist"] ){
		$id = $_GET["id"];
		if( file_exists(getcwd()."/music/{$id}.ogg") ){
			echo "OK:".$id;
			exit;
		} else {
			mkdir("music", 755);
			shell_exec("youtube-dl -xw --no-part --audio-format vorbis -o ".getcwd()."/music/{$id}.ogg https:\/\/youtube.com\/watch?v={$id}");
			if( file_exists(getcwd()."/music/{$id}.ogg") ){
				echo "OK:".$id;
				exit;
			} else {
				echo "NO:Failed to load Youtube video.";
				exit;
			}
		}
	}
	echo "NO:$ip Not whitelisted.";
?>