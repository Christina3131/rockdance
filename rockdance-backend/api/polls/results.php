<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();

$pollId = (int)($_GET['poll_id'] ?? 0);
if ($pollId <= 0) {
  http_response_code(400);
  echo json_encode(['ok'=>false,'error'=>'missing_poll_id']);
  exit;
}

try {
  $poll = $pdo->prepare("SELECT id, question, created_at FROM polls WHERE id=?");
  $poll->execute([$pollId]);
  $p = $poll->fetch();

  if (!$p) {
    http_response_code(404);
    echo json_encode(['ok'=>false,'error'=>'poll_not_found']);
    exit;
  }

  $rows = $pdo->prepare("
    SELECT o.id AS option_id, o.option_text, COUNT(v.id) AS votes
    FROM poll_options o
    LEFT JOIN poll_votes v ON v.option_id = o.id
    WHERE o.poll_id = ?
    GROUP BY o.id, o.option_text
    ORDER BY o.id
  ");
  $rows->execute([$pollId]);
  $p['results'] = $rows->fetchAll();

  echo json_encode(['ok'=>true,'poll'=>$p]);
} catch (Throwable $e) {
  http_response_code(500);
  echo json_encode(['ok'=>false,'error'=>'db_error','detail'=>$e->getMessage()]);
}
