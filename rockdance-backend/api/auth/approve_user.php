<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin(); // make sure only admins can do this

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$id = isset($in['id']) ? (int)$in['id'] : 0;

if ($id <= 0) {
  json_error(400, 'invalid_input', 'Valid user id required.');
}

$stmt = $pdo->prepare("UPDATE users SET is_active = 1 WHERE id = ?");
$stmt->execute([$id]);

echo json_encode(['ok' => true, 'id' => $id, 'is_active' => 1]);
