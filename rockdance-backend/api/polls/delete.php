<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$pollId = (int)($in['poll_id'] ?? 0);

if ($pollId <= 0) {
  http_response_code(400);
  echo json_encode(['ok'=>false,'error'=>'invalid_poll_id']);
  exit;
}

try {
  $stmt = $pdo->prepare("DELETE FROM polls WHERE id=?");
  $stmt->execute([$pollId]);

  echo json_encode(['ok'=>true,'deleted'=>$pollId]);
} catch (Throwable $e) {
  http_response_code(500);
  echo json_encode(['ok'=>false,'error'=>'db_error','detail'=>$e->getMessage()]);
}
