<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../config/db.php';

// 1. Read JSON input
$in = json_decode(file_get_contents('php://input'), true) ?? [];
$name     = trim($in['name'] ?? '');
$email    = strtolower(trim($in['email'] ?? ''));
$password = $in['password'] ?? '';

// 2. Validate input
if ($name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || $password === '') {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'invalid_input', 'hint' => 'Name, valid email and password required']);
    exit;
}

// 3. Check if email already exists
$stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    http_response_code(409); // Conflict
    echo json_encode(['ok' => false, 'error' => 'email_exists']);
    exit;
}

// 4. Insert new user (inactive by default)
$stmt = $pdo->prepare("INSERT INTO users (name, email, password, is_admin, is_active) VALUES (?,?,?,?,?)");
$stmt->execute([
    $name,
    $email,
    password_hash($password, PASSWORD_DEFAULT),
    0, // not admin
    0  // inactive until approved
]);

echo json_encode(['ok' => true, 'message' => 'Registration successful. Waiting for admin approval.']);
