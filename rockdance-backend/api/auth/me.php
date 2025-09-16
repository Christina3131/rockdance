<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../utils/auth.php';
requireLogin();
echo json_encode(['ok'=>true,'user'=>$_SESSION['user']]);
// This file returns the current user's session information
// It requires the user to be logged in and returns their details