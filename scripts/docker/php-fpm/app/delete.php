<?php
require('init.php');

$mysqli->query('DELETE FROM cats');

$redis->flushDb();

$memcached->flush();

unlink('/var/www/html/sites/file.txt');
