<?php
require('init.php');

$mysqli->query('DELETE FROM cats');

$redis->flushDb();

$memcached->flush();

unlink('/content/uploads/file.txt');
