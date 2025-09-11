<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../utils/auth.php';

// Check if a user is logged in
if (!isset($_SESSION)) {
    session_start();
}

if (!empty($_SESSION['user'])) {
    echo json_encode([
        'ok' => true,
        'user' => $_SESSION['user']
    ]);
} else {
    http_response_code(401);
    echo json_encode([
        'ok' => false,
        'error' => 'Not logged in'
    ]);
}
