<?php
// Use the exact same session settings as the rest of the API.
require_once __DIR__ . '/utils/auth.php';  
require_once __DIR__ . '/config/db_maniak.php';

$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email    = strtolower(trim($_POST['email'] ?? ''));
    $password = $_POST['password'] ?? '';

    if (!filter_var($email, FILTER_VALIDATE_EMAIL) || $password === '') {
        $error = "Please enter a valid email and password.";
    } else {
        $stmt = $pdo->prepare("SELECT id, name, email, password, is_admin, is_active FROM users WHERE email=?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['password'])) {
            if ((int)$user['is_active'] !== 1) {
                $error = "Your account is not yet activated.";
            } elseif ((int)$user['is_admin'] !== 1) {
                $error = "You must be an administrator to log in here.";
            } else {
                // Save the exact same structure your API expects.
                $_SESSION['user'] = [
                    'id'       => (int)$user['id'],
                    'name'     => $user['name'],
                    'email'    => $user['email'],
                    'is_admin' => (bool)$user['is_admin'],
                ];
                // make sure session is flushed before redirect
                session_write_close();
                header('Location: /polls/admin_new.php');
                exit;
            }
        } else {
            $error = "Invalid email or password.";
        }
    }
}
?>
<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <title>Admin Login</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body { font-family: system-ui, Arial; background:#fafafa; display:flex; align-items:center; justify-content:center; height:100vh; }
    form { background:#fff; padding:24px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1); width:320px; }
    input { width:100%; padding:10px; margin:8px 0; border:1px solid #ccc; border-radius:6px; }
    button { width:100%; background:#d63384; color:#fff; padding:10px; border:none; border-radius:6px; font-weight:bold; }
    .error { color:red; margin-bottom:10px; text-align:center; }
  </style>
</head>
<body>
  <form method="POST" autocomplete="on">
    <h2 style="text-align:center;">Admin Login</h2>
    <?php if (!empty($error)): ?>
      <div class="error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <input type="email" name="email" placeholder="Email" required autofocus>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Log in</button>
  </form>
</body>
</html>
