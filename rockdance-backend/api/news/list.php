<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/db_maniak.php';

$limit  = min((int)($_GET['limit'] ?? 20), 100);
$offset = max((int)($_GET['offset'] ?? 0), 0);

try {
  $sql = "SELECT id, title, body, image_url, created_at
          FROM news
          ORDER BY created_at DESC
          LIMIT :limit OFFSET :offset";

  $stmt = $pdo->prepare($sql);
  $stmt->bindValue(':limit',  $limit,  PDO::PARAM_INT);
  $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
  $stmt->execute();

  echo json_encode(['ok'=>true, 'items'=>$stmt->fetchAll(PDO::FETCH_ASSOC)]);
} catch (Throwable $e) {
  http_response_code(500);
  echo json_encode(['ok'=>false, 'error'=>'db_error']);
}
