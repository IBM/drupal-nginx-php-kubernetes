<h1>This is a dynamic page served with PHP-FPM.</h1>

<h2>MySQL test</h2>
<?php
$mysqlUser = getenv('MYSQL_USER');
$mysqlPass = getenv('MYSQL_PASS');
$mysqlHost = getenv('MYSQL_HOST');
$mysqlPort = getenv('MYSQL_PORT');
$mysqlName = getenv('MYSQL_NAME');

$mysqli = new mysqli($mysqlHost, $mysqlUser, $mysqlPass, $mysqlName, $mysqlPort);

if ($mysqli->connect_error) {
  die('MySQL connection failure (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
} else {
	echo 'MySQL connection success... ';
	$mysqli->close();
}
?>

<h2>Redis test</h2>
<?php
$redisUser = getenv('REDIS_USER');
$redisPass = getenv('REDIS_PASS');
$redisHost = getenv('REDIS_HOST');
$redisPort = getenv('REDIS_PORT');

$redis = new Redis();

if ($redis->connect($redisHost, $redisPort)) {
  $redis->auth($redisPass);
  $redis->set('foo', 'Hello!');
  if ($redis->get('foo') == 'Hello!') {
    echo 'Redis connection success... ';
  }
} else {
	echo 'Redis connection failure... ';
}
?>

<h2>memcached test</h2>
<?php
$memcachedUser = getenv('REDIS_USER');
$memcachedPass = getenv('REDIS_PASS');
$memcachedHost = getenv('MEMCACHED_HOST');
$memcachedPort = getenv('MEMCACHED_PORT');

$memcached = new Memcached();
$memcached->setOption(Memcached::OPT_BINARY_PROTOCOL, true);
$memcached->setSaslAuthData($memcachedUser, $memcachedPass);

$memcached->resetServerList();
$memcached->addServer($memcachedHost, $memcachedPort);

$memcached->set('foo', 'Hello!');
$memcached->set('bar', 'Memcached...');

$arr = array(
  $memcached->get('foo'),
  $memcached->get('bar')
);

if ($arr[0] == 'Hello!') {
	echo 'memcached connection success... ';
  $keys = $memcached->getAllKeys();
  foreach($keys as $item) {
    echo $item;
  }
} else {
	echo 'memcached connection failure... ';
}
?>

<?php phpinfo(); ?>
