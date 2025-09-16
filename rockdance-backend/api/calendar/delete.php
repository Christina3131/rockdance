<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();

$in  = json_decode(file_get_contents('php://input'), true) ?? [];
$id  = (int)($in['id'] ?? 0);
if ($id <= 0) { json_error(400,'invalid_id','Invalid id'); }

$stmt = $pdo->prepare("DELETE FROM events WHERE id=?");
$stmt->execute([$id]);

echo json_encode(['ok'=>true,'deleted'=>$id]);
