<?php
// api/polls/create.php
header('Content-Type: application/json; charset=utf-8');
ini_set('display_errors', '0');
ini_set('log_errors', '1');
ini_set('error_log', __DIR__ . '/../_runtime_logs/php_errors.log');

require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin(); // only admins

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$question  = trim($in['question'] ?? '');
$options   = $in['options'] ?? null;   // array of strings
$closes_at = trim($in['closes_at'] ?? ''); // optional 'YYYY-MM-DD HH:MM:SS' (server time)

if ($question === '' || !is_array($options) || count($options) < 2) {
  http_response_code(400);
  echo json_encode(['ok'=>false,'error'=>'invalid_input','hint'=>'Need question + at least 2 options']);
  exit;
}

try {
  $pdo->beginTransaction();

  $stmt = $pdo->prepare("INSERT INTO polls (question, is_open, closes_at) VALUES (?,?,?)");
  $stmt->execute([$question, 1, ($closes_at !== '' ? $closes_at : null)]);
  $pollId = (int)$pdo->lastInsertId();

  $opt = $pdo->prepare("INSERT INTO poll_options (poll_id, label, ord) VALUES (?,?,?)");
  $ord = 1;
  foreach ($options as $label) {
    $label = trim((string)$label);
    if ($label === '') continue;
    $opt->execute([$pollId, $label, $ord++]);
  }

  $pdo->commit();
  echo json_encode(['ok'=>true,'poll_id'=>$pollId]);

} catch (Throwable $e) {
  $pdo->rollBack();
  error_log("create poll error: ".$e->getMessage());
  http_response_code(500);
  echo json_encode(['ok'=>false,'error'=>'server_error']);
}
