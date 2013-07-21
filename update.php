<?php

$token = trim(file_get_contents('update_token'));
if (empty($_GET['token']) || $_GET['token'] !== $token) die();

shell_exec('git pull');
shell_exec('cd wiki-data && git pull');
shell_exec('scripts/generate_pages.rb');
