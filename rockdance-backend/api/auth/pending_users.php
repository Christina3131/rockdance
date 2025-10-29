<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();

$stmt = $pdo->query("SELECT id, name, email, is_admin, is_active FROM users WHERE is_active = 0 ORDER BY id DESC");
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode(['ok' => true, 'items' => $rows]);
