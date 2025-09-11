<?php 
require_once '../config/db.php';
require_once '../utils/auth.php';

requireAdmin();

$in = json_decode(file_get_contents('php://input'), true);

if (isset($in['id'])) {
    $stmt = $pdo->prepare("UPDATE news SET title = ?, body = ?, updated_at = NOW() WHERE id = ?");
    $stmt->execute([$in['title'], $in['body'], $in['id']]);
} else {
    $stmt = $pdo->prepare("INSERT INTO news (title, body, created_at) VALUES (?, ?, NOW())");
    $stmt->execute([$in['title'], $in['body'], $SESSION['user']['id']]);

}

echo json_encode(['ok' => true]);
?>
