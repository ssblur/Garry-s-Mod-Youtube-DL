<?php
	## Basic function for extracting ID from URLs.
	## Will be phased out in the future.
	function getID( $url ) {
		$re = '/(?:(?:https?)(?::?\/{0,2}))?(?:www\.)?(?:youtube\.com|youtu\.be)(?:\/?)(?:(?:watch)?[?\/](?:v=)?)([a-zA-Z0-9]+(?=[&\/?]?))/m';
		preg_match_all($re, $url, $matches, PREG_SET_ORDER, 0);
		
		return $matches[0];
	}
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
		$id = getID(base64_decode($_GET["id"]));
		if(empty($id)){
			$id = $_GET["id"];
		}
		if( file_exists(getcwd()."/music/{$id}.mp3") ){
			echo "OK:".$id;
			exit;
		} else {
			mkdir("music", 755);
			shell_exec("youtube-dl -xw --no-part --audio-format mp3 -o ".getcwd()."/music/{$id}.mp3 https:\/\/youtube.com\/watch?v={$id}");
			if( file_exists(getcwd()."/music/{$id}.mp3") ){
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