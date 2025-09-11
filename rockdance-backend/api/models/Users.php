<?php

require_once '../config/Database.php';

class Users {
    public function register() {
      
    }
}

$init = new Users;

// Ensure that user is sending a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    switch($_POST['type']) {
        case 'register':
            $init->register();
            break;
    }
}