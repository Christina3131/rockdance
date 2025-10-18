<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once __DIR__ . '/config/db_maniak.php';

try {
    // Try a few safe variants
    $sql = "SELECT NOW() AS ts";            // simplest
    // $sql = "SELECT CURRENT_TIMESTAMP() AS ts"; // alternative

    $stmt = $pdo->query($sql);
    $row  = $stmt->fetch(PDO::FETCH_ASSOC);

    header('Content-Type: text/plain; charset=utf-8');
    echo "SQL OK\n";
    echo "Time: " . $row['ts'] . "\n";
} catch (Throwable $e) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "SQL FAILED\n";
    echo "Query: $sql\n";
    echo "Error: " . $e->getMessage() . "\n";
}
