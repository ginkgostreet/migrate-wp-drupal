#!/usr/bin/php
<?php
/***
 * based on https://wiki.civicrm.org/confluence/display/CRMDOC/Migrating+from+Drupal+to+WordPress
 * WARNING: does not address database prefixes
 ***/

require_once('./migrate_civicrm_config.php');
require_once('./functions.php');
/*
 define('DB_DUMP', 
 define('DATABASE', 
 define('SITE_DIR', 
 define('WEBUSER',
 define('CAT', 
*/

echo "Migrate civicrm to Drupal\n";
echo "You need sudo ability to run this script\n";

user_confirm_or_exit('This script will drop your civicrm database. Continue? [y/n]');

#confirm db connection
  passthru(mymysql('show tables').' >/dev/null 2>/dev/null', $output);
  if ($output > 0) echo "mysql connection failed, check your .my.cnf\n"; 

echo "Dropping CiviCRM database\n";
system(mymysql('DROP DATABASE '.DATABASE, '').' -f');
system(mymysql('CREATE DATABASE '.DATABASE, '').' -f');

echo "Restore db dump\n";
system(CAT.' '.DB_DUMP.' | mysql '.DATABASE);

echo "Truncate uf_match\n";
system(mymysql('delete from civicrm_uf_match'));

echo "Update path configs\n";
chdir(SITE_DIR);
system('sudo drush civicrm-update-cfg');
system('sudo chown -R '.WEBUSER.':'.WEBUSER.' files/civicrm');
system('sudo chmod -R ug+w files');

echo "Clearing CiviCRM menu caches to force rebuild.\n";
system(mymysql('DELETE FROM civicrm_menu'));
system(mymysql('UPDATE civicrm_domain SET config_backend = NULL WHERE civicrm_domain.id = 1'));

/***
 * create a system mysql query call
 ***/
function mymysql($sql, $db=DATABASE) {
  return 'echo '.escapeshellarg($sql).' | mysql '.$db;
}

