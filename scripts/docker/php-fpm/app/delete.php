<?php
require('init.php');

$mysqli->query('DELETE FROM cats');

$redis->flushDb();

$memcached->flush();

unlink('/content/uploads/data/file.txt');
