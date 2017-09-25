<?php
$mysqlUser = getenv('MYSQL_USER');
$mysqlPass = getenv('MYSQL_PASS');
$mysqlHost = getenv('MYSQL_HOST');
$mysqlPort = getenv('MYSQL_PORT');
$mysqlName = getenv('MYSQL_NAME');
$mysqli = new mysqli($mysqlHost, $mysqlUser, $mysqlPass, $mysqlName, $mysqlPort);
if ($mysqli->connect_error) {
  die('MySQL connection failure (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error . '<br />');
} else {
	echo 'MySQL connection success... <br />';
}

$redisUser = getenv('REDIS_USER');
$redisPass = getenv('REDIS_PASS');
$redisHost = getenv('REDIS_HOST');
$redisPort = getenv('REDIS_PORT');
$redis = new Redis();
if ($redis->connect($redisHost, $redisPort)) {
  $redis->auth($redisPass);
  echo 'Redis connection success... <br />';
} else {
	echo 'Redis connection failure... <br />';
}

$memcachedUser = getenv('MEMCACHED_USER');
$memcachedPass = getenv('MEMCACHED_PASS');
$memcachedHost = getenv('MEMCACHED_HOST');
$memcachedPort = getenv('MEMCACHED_PORT');
$memcached = new Memcached();
$memcached->setOption(Memcached::OPT_BINARY_PROTOCOL, true);
$memcached->setSaslAuthData($memcachedUser, $memcachedPass);
$memcached->resetServerList();
$memcached->addServer($memcachedHost, $memcachedPort);
if ($memcached->set('Test', 'Test')) {
  echo 'Memcached connection success... <br />';
} else {
  echo 'Memcached connection success... <br />';
}
