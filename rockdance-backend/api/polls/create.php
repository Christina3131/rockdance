<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../utils/auth.php';

requireAdmin();

$in = json_decode(file_get_contents('php://input'), true) ?? [];

$question = trim($in['question'] ?? '');
$options = $in['options'] ?? [];

if ($question === '' || !is_array($options) || count($options) < 2) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'invalid_input', 'message' => 'Need a question and at least 2 options']);
    exit;
}

try {
    // Insert poll
    $stmt = $pdo->prepare("INSERT INTO polls (question, created_at) VALUES (?, NOW())");
    $stmt->execute([$question]);
    $pollId = $pdo->lastInsertId();

    // Insert poll options
    $optStmt = $pdo->prepare("INSERT INTO poll_options (poll_id, option_text) VALUES (?, ?)");
    foreach ($options as $opt) {
        $opt = trim($opt);
        if ($opt !== '') {
            $optStmt->execute([$pollId, $opt]);
        }
    }

    echo json_encode(['ok' => true, 'poll_id' => $pollId]);

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'db_error', 'detail' => $e->getMessage()]);
}
