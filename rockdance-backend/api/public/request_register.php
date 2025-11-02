<?php
// Always return JSON
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json; charset=utf-8');

// Don't leak PHP errors to the client; log them instead
ini_set('display_errors', '0');
ini_set('log_errors', '1');
ini_set('error_log', __DIR__ . '/../../_runtime_logs/php_errors.log');

$autoload = dirname(__DIR__) . '/vendor/autoload.php';
if (file_exists($autoload)) {
  require_once $autoload;
} else {
  throw new Exception('PHPMailer not installed (no autoload found).');
}



/* ---------- CONFIGURE SMTP HERE ---------- */
const SMTP_HOST = 'mail.infomaniak.com';
const SMTP_PORT = 587; // or 465 if you need SSL
const SMTP_USER = 'noreply@rockdancecompany.ch';   // your mailbox
const SMTP_PASS = 'rockDance31';     // use an app-specific password
const SMTP_FROM = 'noreply@rockdancecompany.ch';
const SMTP_FROM_NAME = 'Rock Dance Company';
const SMTP_TO   = 'info@rockdancecompany.ch';
/* ----------------------------------------- */

// 1) Only allow POST with JSON
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['ok' => false, 'error' => 'method_not_allowed', 'hint' => 'POST JSON required']);
  exit;
}

$raw = file_get_contents('php://input');
$in  = json_decode($raw, true);

// 2) Validate required fields
$required = ['name','surname','email','phone','message'];
$missing = [];
foreach ($required as $k) {
  if (!isset($in[$k]) || trim($in[$k]) === '') { $missing[] = $k; }
}
if ($missing) {
  http_response_code(400);
  echo json_encode(['ok'=>false, 'error'=>'invalid_input', 'missing'=>$missing]);
  exit;
}

// 3) Build mail content
$name     = trim($in['name']);
$surname  = trim($in['surname']);
$email    = trim($in['email']);
$phone    = trim($in['phone']);
$message  = trim($in['message']);

$subject  = 'New Registration Request';
$bodyTxt  = "Name: {$name} {$surname}\nEmail: {$email}\nPhone: {$phone}\nMessage: {$message}\n";
$bodyHtml = "
  <h3>New Registration Request</h3>
  <p><b>Name:</b> ".htmlspecialchars($name.' '.$surname)."</p>
  <p><b>Email:</b> ".htmlspecialchars($email)."</p>
  <p><b>Phone:</b> ".htmlspecialchars($phone)."</p>
  <p><b>Message:</b><br>".nl2br(htmlspecialchars($message))."</p>
";

$devLogDir = __DIR__ . '/../../_mail_logs';
if (!is_dir($devLogDir)) { @mkdir($devLogDir, 0775, true); }

// 4) Send via PHPMailer (SMTP)
try {
  // Prefer Composer autoload
  $autoload1 = __DIR__ . '/../../vendor/autoload.php';
  // Fallback: manual include if you uploaded PHPMailer/src without Composer
  $autoload2 = __DIR__ . '/../../phpmailer/autoload.php';

  if (file_exists($autoload1)) {
    require_once $autoload1;
  } elseif (file_exists($autoload2)) {
    require_once $autoload2;
  } else {
    throw new Exception('PHPMailer not installed (no autoload found).');
  }

  $mail = new PHPMailer\PHPMailer\PHPMailer(true);
  $mail->isSMTP();
  $mail->Host       = SMTP_HOST;
  $mail->SMTPAuth   = true;
  $mail->Username   = SMTP_USER;
  $mail->Password   = SMTP_PASS;
  $mail->Port       = SMTP_PORT;
  if (SMTP_PORT == 465) {
    $mail->SMTPSecure = PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_SMTPS; // SSL
  } else {
    $mail->SMTPSecure = PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS; // STARTTLS
  }

  $mail->CharSet = 'UTF-8';
  $mail->setFrom(SMTP_FROM, SMTP_FROM_NAME);
  $mail->addAddress(SMTP_TO);
  // Set the user's email as Reply-To (so when you reply, it goes to them)
  if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $mail->addReplyTo($email, $name.' '.$surname);
  }

  $mail->Subject = $subject;
  $mail->Body    = $bodyHtml;
  $mail->AltBody = $bodyTxt;
  $mail->isHTML(true);

  $mail->send();

  echo json_encode(['ok'=>true]);
  exit;

} catch (Throwable $e) {
  // Fallback for dev: write the "email" to a file, and still return ok so the app can proceed
  $fname = $devLogDir . '/register_' . date('Ymd_His') . '.txt';
  @file_put_contents($fname, "TO: ".SMTP_TO."\nSUBJECT: $subject\nFROM: ".SMTP_FROM."\n\n$bodyTxt\n\nMailerError: ".$e->getMessage());
  echo json_encode(['ok'=>true, 'dev_note'=>'mail_not_sent_smtp_error, written_to_log']);
  exit;
}
