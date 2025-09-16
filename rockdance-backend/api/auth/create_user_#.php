<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();
$in = json_decode(file_get_contents('php://input'), true) ?? [];

$stmt = $pdo->prepare(
  "INSERT INTO users (name, email, password, is_admin, is_active) VALUES (?,?,?,?,?)"
);
$stmt->execute([
  $in['name'],
  $in['email'],
  password_hash($in['password'], PASSWORD_DEFAULT),
  !empty($in['is_admin']) ? 1 : 0,
  1
]);

echo json_encode(['ok'=>true]);
