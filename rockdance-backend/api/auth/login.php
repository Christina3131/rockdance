<?php
require_once '../config/db.php'; 

$in = json_decode(file_get_contents('php://input'), true);

$stmt = $pdo ->prepare("SELECT * FROM users WHERE email = ?AND is_active = 1" );
$stmt->execute([$in['email']]);
$user = $stmt->fetch();

if ($user && password_verify($in['password'], $user['password'])) {
    session_start();
    $_SESSION['user'] = [
        'id' => $user['id'],
        'name' => $user['name'],
        'email' => $user['email'],
        'is_admin' => $user['is_admin']
    ];
    echo json_encode(['ok' => true, 'user' => $_SESSION['user']]);
} else {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid email or password']);
}
?>
