<?php
// api/utils/session.php
if (session_status() === PHP_SESSION_NONE) {
  $secure = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on';
  session_set_cookie_params([
    'lifetime' => 0,
    'path'     => '/',
    'domain'   => '',
    'secure'   => $secure,
    'httponly' => true,
    'samesite' => 'Lax',
  ]);
  session_name('RDC_SESSID');
  session_start();
}
