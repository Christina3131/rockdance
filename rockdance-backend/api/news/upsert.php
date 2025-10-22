<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$id    = isset($in['id']) ? (int)$in['id'] : 0;
$title = trim($in['title'] ?? '');
$body  = $in['body'] ?? '';

if ($title === '') {
  json_error(400,'missing_title','Title is required.');
}

try {
  if ($id > 0) {
    $stmt = $pdo->prepare("UPDATE news SET title=?, body=?, updated_at=NOW() WHERE id=?");
    $stmt->execute([$title, $body, $id]);
    echo json_encode(['ok'=>true,'id'=>$id,'mode'=>'updated']);
  } else {
    // If you have a created_by column, use this insert; otherwise remove created_by.
    $stmt = $pdo->prepare("INSERT INTO news (title, body, created_by) VALUES (?,?,?)");
    $stmt->execute([$title, $body, $_SESSION['user']['id']]);
    echo json_encode(['ok'=>true,'id'=>$pdo->lastInsertId(),'mode'=>'created']);
  }
} catch (Throwable $e) {
  json_error(500,'db_error','Please try again later.');
}
