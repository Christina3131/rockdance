<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireLogin();

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$pollId   = (int)($in['poll_id'] ?? 0);
$optionId = (int)($in['option_id'] ?? 0);
$userId   = (int)$_SESSION['user']['id'];

if ($pollId <= 0 || $optionId <= 0) {
  http_response_code(400);
  echo json_encode(['ok'=>false,'error'=>'invalid_input']);
  exit;
}

// Validate that option belongs to poll
$st = $pdo->prepare("SELECT 1 FROM poll_options WHERE id=? AND poll_id=?");
$st->execute([$optionId, $pollId]);
if (!$st->fetch()) {
  http_response_code(400);
  echo json_encode(['ok'=>false,'error'=>'option_not_in_poll']);
  exit;
}

try {
  $stmt = $pdo->prepare("
    INSERT INTO poll_votes (poll_id, option_id, user_id)
    VALUES (?, ?, ?)
    ON DUPLICATE KEY UPDATE option_id = VALUES(option_id)
  ");
  $stmt->execute([$pollId, $optionId, $userId]);

  echo json_encode(['ok'=>true]);
} catch (Throwable $e) {
  http_response_code(500);
  echo json_encode(['ok'=>false,'error'=>'db_error','detail'=>$e->getMessage()]);
}
