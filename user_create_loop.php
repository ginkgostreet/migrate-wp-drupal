#!/usr/bin/php
<?php

function read_file_and_callback_per_line($filename, $callback) {
	$fd = fopen($filename, "r");

	while (!feof($fd) ) {
		$line = fgets($fd);
		//var_dump($line);
		$callback($line);
	}
	fclose($fd);
}

read_file_and_callback_per_line(__DIR__ . '/wp_users.csv', 'create_drupal_user');

function create_drupal_user($line) {

	$row = explode("\t", $line);
 	if ($row[0] !== "user_login") {
		system("drush user-create {$row[0]} --mail={$row[2]} --pass={$row[1]}");

	}
}
