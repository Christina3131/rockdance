<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__.'/../../config/db_maniak.php';
require_once __DIR__.'/../../utils/auth.php';

$user = requireUser();

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$pollId   = (int)($in['poll_id'] ?? 0);
$optionId = (int)($in['option_id'] ?? 0);

if ($pollId <= 0 || $optionId <= 0) {
  json_error(400,'invalid_input','poll_id and option_id required.');
}

// Ensure poll open
$stmt = $pdo->prepare("SELECT is_open, closes_at FROM polls WHERE id=?");
$stmt->execute([$pollId]);
$poll = $stmt->fetch();
if (!$poll || !$poll['is_open'] || ($poll['closes_at'] && strtotime($poll['closes_at']) <= time())) {
  json_error(400,'poll_closed','Poll is closed.');
}

// Ensure option belongs to poll
$stmt = $pdo->prepare("SELECT 1 FROM poll_options WHERE id=? AND poll_id=?");
$stmt->execute([$optionId, $pollId]);
if (!$stmt->fetch()) {
  json_error(400,'invalid_option','Option does not belong to poll.');
}

// Insert vote (unique user per poll)
try {
  $stmt = $pdo->prepare("INSERT INTO poll_votes (poll_id, option_id, user_id) VALUES (?,?,?)");
  $stmt->execute([$pollId, $optionId, $user['id']]);
  echo json_encode(['ok'=>true, 'message'=>'Vote recorded']);
} catch (Throwable $e) {
  // duplicate (already voted)
  if (strpos($e->getMessage(), 'uniq_user_poll') !== false) {
    json_error(409,'already_voted','You already voted in this poll.');
  }
  json_error(500,'db_error','Please try again later.');
}
