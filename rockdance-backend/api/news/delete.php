<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';
requireAdmin();

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$id = (int)($in['id'] ?? 0);

if ($id <= 0) { http_response_code(400); echo json_encode(['ok'=>false,'error'=>'invalid_id']); exit; }

$stmt = $pdo->prepare("DELETE FROM news WHERE id=?");
$stmt->execute([$id]);

echo json_encode(['ok'=>true, 'deleted'=>$id]);
