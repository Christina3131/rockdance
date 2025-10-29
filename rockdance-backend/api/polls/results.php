<?php
// api/polls/results.php
header('Content-Type: application/json; charset=utf-8');
ini_set('display_errors','0');
require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();

$pollId = isset($_GET['poll_id']) ? (int)$_GET['poll_id'] : 0;
if ($pollId <= 0) { http_response_code(400); echo json_encode(['ok'=>false,'error'=>'invalid_poll']); exit; }

$q = $pdo->prepare("
  SELECT o.id as option_id, o.label, COALESCE(v.cnt,0) as votes
  FROM poll_options o
  LEFT JOIN (
    SELECT option_id, COUNT(*) as cnt
    FROM poll_votes
    WHERE poll_id=?
    GROUP BY option_id
  ) v ON v.option_id = o.id
  WHERE o.poll_id=?
  ORDER BY o.ord ASC
");
$q->execute([$pollId, $pollId]);
$rows = $q->fetchAll(PDO::FETCH_ASSOC);

echo json_encode(['ok'=>true,'poll_id'=>$pollId,'results'=>$rows], JSON_UNESCAPED_UNICODE);
