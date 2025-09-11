<?php
// Quick tool to generate a password hash. Keep this file local; don't deploy it.

$password = 'MySecretPassword!';  // <— change this for the hash you want
$hash = password_hash($password, PASSWORD_DEFAULT);

header('Content-Type: text/plain');
echo "Password: $password\n";
echo "Hash:     $hash\n";
