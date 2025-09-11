<?php
require_once '../config/db.php';
$stmt = $pdo->query("SELECT * FROM news ORDER BY created_at DESC");
echo json_encode($stmt->fetchAll());
?> 