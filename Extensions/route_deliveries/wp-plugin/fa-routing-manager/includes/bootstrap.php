<?php

// Include config.php if it exists
if (file_exists(BASE_PATH . 'plugin-config.php')) {
    require_once BASE_PATH . 'plugin-config.php';
} else {
    error_log('FA Route Manager plugin-config.php not found.');
}

// Function to autoload all PHP files in a directory
function autoload_directory($directory) {
    foreach (glob($directory . '*.php') as $file) {
        require_once $file;
    }
}

// Autoload all files in db and shortcodes directories
autoload_directory(BASE_PATH . 'includes/db/');
autoload_directory(BASE_PATH . 'includes/shortcodes/');
autoload_directory(BASE_PATH . 'includes/wp/');

