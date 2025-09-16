<?php
// api/utils/auth.php
require_once __DIR__ . '/session.php';

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

function requireAdmin() {
  requireLogin();
  if (empty($_SESSION['user']['is_admin'])) {
    json_error(403, 'admin_only', 'Admin access required.');
  }
}
