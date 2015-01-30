#!/usr/bin/php
<?php

define('WP_DB', 'membership_wp');
define('DB_USER', 'membership');
define('DB_PASS', 'Zz401Ch@mbR');

$sql = 'SELECT user_login, user_pass, user_email FROM mmbr_users ORDER BY ID ASC;';

$statement = ' echo "'.$sql.'" | mysql '.WP_DB.' -u'.DB_USER.' -p'.DB_PASS.' > wp_users.csv';

system( $statement);


