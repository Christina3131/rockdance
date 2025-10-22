<?php
require_once __DIR__ . '/../config/db_maniak.php';
header('Content-Type: text/plain');
echo 'DB: '.$pdo->query('SELECT DATABASE()')->fetchColumn();
