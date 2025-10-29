<?php
// api/polls/list.php
header('Content-Type: application/json; charset=utf-8');
ini_set('display_errors', '0');

require_once __DIR__ . '/../config/db_maniak.php';
require_once __DIR__ . '/../utils/auth.php';

try {
    // must be logged in; returns $_SESSION['user'] or exits with JSON 401
    $user = requireUser(); // defined in utils/auth.php

    // fetch open polls (no close date OR closes in the future) and only is_open=1
    $q = $pdo->query("
        SELECT p.id, p.question, p.closes_at
        FROM polls p
        WHERE p.is_open = 1
          AND (p.closes_at IS NULL OR p.closes_at > NOW())
        ORDER BY p.id DESC
    ");
    $polls = $q->fetchAll(PDO::FETCH_ASSOC);

    // prepare sub-queries
    $optStmt  = $pdo->prepare("SELECT id, label, ord FROM poll_options WHERE poll_id=? ORDER BY ord ASC");
    $voteStmt = $pdo->prepare("SELECT 1 FROM poll_votes WHERE poll_id=? AND user_id=? LIMIT 1");

    $out = [];
    foreach ($polls as $p) {
        $optStmt->execute([$p['id']]);
        $options = $optStmt->fetchAll(PDO::FETCH_ASSOC);

        $voteStmt->execute([$p['id'], $user['id']]);
        $hasVoted = (bool)$voteStmt->fetchColumn();

        $out[] = [
            'id'        => (int)$p['id'],
            'question'  => $p['question'],
            'closes_at' => $p['closes_at'],
            'hasVoted'  => $hasVoted,
            'options'   => $options,
        ];
    }

    echo json_encode(['ok' => true, 'polls' => $out], JSON_UNESCAPED_UNICODE);
    exit;

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'error' => 'server_error',
        'hint' => 'Check server logs',
    ]);
    exit;
}
