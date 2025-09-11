<?php 
require_once '../config/db.php';
require_once '../utils/auth.php';

requireAdmin();

$in = json_decode(file_get_contents('php://input'), true);

$stmt = $pdo->prepare("
    INSERT INTO users (name, email, password, is_admin, is_active) 
    VALUES (?, ?, ?, ?, ?)
");
$stmt->execute([
    $in['name'],
    $in['email'],
    password_hash($in['password'], PASSWORD_DEFAULT),
    isset($in['is_admin']) && $in['is_admin'] ? 1 : 0,
    1 // active by default
]);

echo json_encode(['ok' => true]);
?>
