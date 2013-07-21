<?php

function active_page() {
    if (!empty($_GET['page'])) return trim(preg_replace('/[^a-zA-Z0-9\/]+/', '', $_GET['page']));
    return 'mainpage';
}

function content($name) {
    $filename = "public_html/pages/{$name}";
    $ext = file_exists("{$filename}.html.php") ? 'html.php' : 'html';
    if (!file_exists("{$filename}.{$ext}")) include('public_html/pages/error_404.html');
    include("{$filename}.{$ext}");
}

// Go for it!
include('public_html/pages/layout.html.php');
