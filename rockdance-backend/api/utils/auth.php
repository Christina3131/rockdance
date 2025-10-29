<?php
// api/utils/auth.php
require_once __DIR__ . '/session.php';

if (session_status() !== PHP_SESSION_ACTIVE) {
  session_name('rdc_sess'); // <-- replace with the exact name you found in auth.php
  session_start();
}


function json_error(int $code, string $error, string $message) {
  http_response_code($code);
  header('Content-Type: application/json');
  echo json_encode(['ok'=>false,'error'=>$error,'message'=>$message]);
  exit;
}

function requireLogin() {
  if (empty($_SESSION['user'])) {
    json_error(401, 'members_only', 'This feature is for club members only.');
  }
}

function requireUser() {
    if (empty($_SESSION['user'])) {
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'not_logged_in']);
        exit;
    }
    return $_SESSION['user'];
}


function requireAdmin() {
  if (!isset($_SESSION['user']) || empty($_SESSION['user']['is_admin'])) {
    http_response_code(403);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['ok'=>false, 'error'=>'admin_only', 'message'=>'This feature is for administrators only.']);
    exit;
  }
  return $_SESSION['user'];
}
