<?php
header('Content-Type: application/json');

// Destroy the session
session_start();
session_unset();
session_destroy();

echo json_encode([
    'ok' => true,
    'message' => 'Logged out successfully'
]);
