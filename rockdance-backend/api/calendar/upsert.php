<?php
require_once '../config/db.php';
require_once '../utils/auth.php';

requireAdmin(); // Only admins can add/update

$in = json_decode(file_get_contents('php://input'), true);

if (empty($in['title']) || empty($in['date'])) {
    echo json_encode(['error' => 'Title and date are required']);
    exit;
}

if (!empty($in['id'])) {
    // Update
    $stmt = $pdo->prepare("UPDATE calendar SET title = ?, date = ?, description = ? WHERE id = ?");
    $stmt->execute([$in['title'], $in['date'], $in['description'], $in['id']]);
} else {
    // Insert
    $stmt = $pdo->prepare("INSERT INTO calendar (title, date, description) VALUES (?, ?, ?)");
    $stmt->execute([$in['title'], $in['date'], $in['description']]);
}

echo json_encode(['ok' => true]);
?>
