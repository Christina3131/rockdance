<?php
header('Content-Type: application/json');

// 1) Only allow POST with JSON
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['ok' => false, 'error' => 'method_not_allowed', 'hint' => 'POST JSON required']);
  exit;
}

$raw = file_get_contents('php://input');
$in  = json_decode($raw, true);

// 2) Validate required fields
$required = ['name','surname', 'email', 'phone','message'];
$missing = [];
foreach ($required as $k) {
  if (!isset($in[$k]) || $in[$k] === '') { $missing[] = $k; }
}
if ($missing) {
  http_response_code(400);
  echo json_encode(['ok'=>false, 'error'=>'invalid_input', 'missing'=>$missing]);
  exit;
}

// 3) Build email body
$to      = "info@rockdancecompany.ch";
$subject = "New Registration Request";
$body    = "Name: {$in['name']} {$in['surname']}\n"
         . "Email: {$in['email']}\n"
         . "Phone: {$in['phone']}\n"
         . "Message: {$in['message']}\n";

$headers = "From: noreply@rockdancecompany.ch\r\n"
         . "Reply-To: {$in['email']}\r\n";

// 4) Try to send email. On localhost it will likely fail,
// so in DEV we just write to a log file and still return ok=true.
$sent = @mail($to, $subject, $body, $headers);

if (!$sent) {
  // DEV fallback: write to a file so you can inspect the "email"
  $logDir = __DIR__ . '/../../_mail_logs';
  if (!is_dir($logDir)) { @mkdir($logDir, 0775, true); }
  $fname = $logDir . '/register_' . date('Ymd_His') . '.txt';
  @file_put_contents($fname, "TO: $to\nSUBJECT: $subject\nHEADERS:\n$headers\n\n$body\n");

  // Return ok anyway so you can continue developing
  echo json_encode(['ok'=>true, 'dev_note'=>'mail_not_sent_local, written_to_log']);
  exit;
}

echo json_encode(['ok' => true]);
