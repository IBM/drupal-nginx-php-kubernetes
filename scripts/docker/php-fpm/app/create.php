<?php
require('init.php');

$mysqli->query('CREATE TABLE IF NOT EXISTS `cats` (`id` INT AUTO_INCREMENT PRIMARY KEY, `name` VARCHAR(256) NOT NULL, `color` VARCHAR(256) NOT NULL)');
$mysqli->query('INSERT INTO cats (name, color) VALUES(`Tarball`, `Black`)');

$redis->set('Cat', 'Tarball!');

$memcached->set('Cat', 'Tarball!');

date_default_timezone_set('UTC');
file_put_contents('/content/uploads/file.txt', 'Wrote some text about Tarball the cat on ' . date('l jS \of F Y h:i:s A'));
