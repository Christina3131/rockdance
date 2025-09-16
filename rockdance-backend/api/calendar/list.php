<?php
require_once '../config/db.php';
require_once '../utils/auth.php';

requireLogin(); // Only logged-in users can see the calendar

$stmt = $pdo->query("SELECT id, title, date, description FROM calendar ORDER BY date ASC");
$events = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($events);
?>
