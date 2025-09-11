<?php 
session_start();

function requireLogin() {
    if (!isset($_SESSION['user'])) {
        http_response_code(401);
        echo json_encode(['error' => 'Login required']);
        exit();
    }
}

function requireAdmin() {
    requireLogin();
    if ($_SESSION['user']['is_admin'] !=1) {
        http_response_code(403);
        echo json_encode(['error' => 'Admin access required']);
        exit;
    }
}
?>