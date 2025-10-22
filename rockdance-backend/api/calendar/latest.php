<?php
header('Content-Type: application/json; charset=utf-8');

$pointer = __DIR__ . '/../../data/calendar_current.json';

if (!file_exists($pointer)) {
  http_response_code(404);
  echo json_encode(['ok'=>false, 'error'=>'not_found', 'hint'=>'No calendar uploaded yet']);
  exit;
}

$j = json_decode(file_get_contents($pointer), true);
if (!$j || empty($j['url'])) {
  http_response_code(500);
  echo json_encode(['ok'=>false, 'error'=>'bad_pointer']);
  exit;
}

echo json_encode(['ok'=>true, 'calendar'=>$j]);
