<?php
require_once '../config/db.php'; // adjust path if needed

// Prepare the statement
$stmt = $pdo->prepare("INSERT INTO users (name, surname, email, password, age, is_admin)
                       VALUES (:name, :surname, :email, :password, :age, :is_admin)");

// Bind values
$stmt->execute([
    'name' => 'Sofia',
    'surname' => 'Lopez',
    'email' => 'sofia@example.com',
    'password' => password_hash('mySecretPassword', PASSWORD_DEFAULT),
    'age' => 22,
    'is_admin' => 0
]);

echo "User added successfully!";
?>
