<?php
// api/polls/delete.php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';
requireAdmin();

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$pollId = (int)($in['poll_id'] ?? 0);
if ($pollId <= 0) { http_response_code(400); echo json_encode(['ok'=>false,'error'=>'invalid_poll']); exit; }

$stmt = $pdo->prepare("DELETE FROM polls WHERE id=?");
$stmt->execute([$pollId]);

echo json_encode(['ok'=>true]);
