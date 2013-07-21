<?php

$token = trim(file_get_contents('update_token'));
if (empty($_GET['token']) || $_GET['token'] !== $token) die();

exec('git pull');
exec('git submodule update');
exec('scripts/generate_pages.rb');
