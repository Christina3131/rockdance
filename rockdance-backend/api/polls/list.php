<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../config/db_maniak.php';
// require_once __DIR__ . '/../utils/auth.php';
// requireLogin();

try {
  $polls = $pdo->query("SELECT id, question, created_at FROM polls ORDER BY id DESC")->fetchAll();

  $optStmt = $pdo->prepare("SELECT id, option_text FROM poll_options WHERE poll_id = ?");
  foreach ($polls as &$p) {
    $optStmt->execute([$p['id']]);
    $p['options'] = $optStmt->fetchAll();
  }

  echo json_encode(['ok'=>true,'items'=>$polls]);
} catch (Throwable $e) {
  http_response_code(500);
  echo json_encode(['ok'=>false,'error'=>'db_error','detail'=>$e->getMessage()]);
}
