<?php
$host = 'dxen.myd.infomaniak.com';
$db   = 'dxen_rockdance_db';
$user = 'dxen_dbrockdance';
$pass = 'RockDance@2024';
$charset = "utf8mb4"; 

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
  PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",

];

try {
  $pdo = new PDO($dsn, $user, $pass, $options);
} catch (Throwable $e) {
  throw $e;
}