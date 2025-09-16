<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../utils/auth.php';

$in = json_decode(file_get_contents('php://input'), true) ?? [];
$email = strtolower(trim($in['email'] ?? ''));
$pass  = $in['password'] ?? '';

if (!filter_var($email, FILTER_VALIDATE_EMAIL) || $pass === '') {
  json_error(400, 'invalid_input', 'Email and password are required.');
}

$stmt = $pdo->prepare("SELECT id,name,email,password,is_admin,is_active FROM users WHERE email=?");
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user || !$user['is_active'] || !password_verify($pass, $user['password'])) {
  json_error(401, 'bad_credentials', 'Invalid email or password.');
}

session_regenerate_id(true);
$_SESSION['user'] = [
  'id'       => (int)$user['id'],
  'name'     => $user['name'],
  'email'    => $user['email'],
  'is_admin' => (bool)$user['is_admin'],
];

echo json_encode(['ok'=>true, 'user'=>$_SESSION['user']]);
