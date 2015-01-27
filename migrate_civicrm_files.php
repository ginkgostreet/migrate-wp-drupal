#!/usr/bin/php
<?php

require_once('./migrate_civicrm_config.php');

mkdir('tmp');
chdir('tmp');
$tmp_dir = getcwd();

system('tar xzf '.WP_PLUGINS_TAR);

$ext_dir = $civicrm_setting['Directory Preferences']['extensionsDir'];

mkdir($ext_dir); // ensure it exists
chdir($ext_dir);
foreach ($extension_archs as $arch) {
  system('tar xzf '.GSL_PROJ_ROOT.'/tars/extensions/'.$arch.' --overwrite');
}

chdir($tmp_dir.'/files/civicrm/upload');
foreach ($extension_archs as $arch) {
  system( 'rm -rf '.str_replace($arch, '.tar.gz', ''));
}
chdir($tmp_dir);

system('cp -a files/civicrm/upload/* '.$civicrm_setting['Directory Preferences']['uploadDir']);
system('cp -a files/civicrm/custom/* '.$civicrm_setting['Directory Preferences']['customFileUploadDir']);

system('rm -rf '.$tmp_dir);
