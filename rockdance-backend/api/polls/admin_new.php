<?php
require_once __DIR__ . '/../utils/auth.php';
requireAdmin(); // ✅ only allow admins, not just members
?>
<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <title>New Poll</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body { font-family: system-ui, Arial; margin: 24px; }
    input, textarea { width: 100%; padding: 8px; margin: 6px 0; }
    .row { margin-bottom: 12px; }
  </style>
</head>
<body>
  <h2>Create Poll</h2>
  <div class="row">
    <label>Question</label>
    <input id="q" placeholder="Poll question">
  </div>
  <div class="row">
    <label>Options (one per line, min 2)</label>
    <textarea id="opts" rows="6" placeholder="Yes&#10;No"></textarea>
  </div>
  <div class="row">
    <label>Closes at (optional, YYYY-MM-DD HH:MM:SS)</label>
    <input id="close" placeholder="2025-11-10 22:00:00">
  </div>
  <button onclick="createPoll()">Create</button>
  <pre id="out"></pre>

<script>
async function createPoll(){
  const question  = document.getElementById('q').value.trim();
  const options   = document.getElementById('opts').value.split('\n').map(s=>s.trim()).filter(Boolean);
  const closes_at = document.getElementById('close').value.trim();

  const res = await fetch('./create.php', {
    method:'POST',
    headers:{'Content-Type':'application/json'},
    credentials:'include',
    body: JSON.stringify({question, options, closes_at})
  });
  document.getElementById('out').textContent = await res.text();
}
</script>
</body>
</html>
