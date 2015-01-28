#!/usr/bin/php
<?php

require_once(__DIR__ . '/migrate_civicrm_config.php');

// there are no extensions to migrate, so there's no step for that here...

// upload_dir is a full path from server root
$upload_dir = array_key_exists('uploadDir', $civicrm_setting['Directory Preferences'])
  ? $civicrm_setting['Directory Preferences']['uploadDir'] : DRUPAL_WEBROOT . '/sites/default/files/civicrm/upload';
@mkdir($upload_dir); // ensure it exists
system('cp -a ' . WP_WEBROOT . '/wp-content/plugins/files/civicrm/upload/* ' . $upload_dir);

// upload_dir is a full path from server root
$image_dir = array_key_exists('imageUploadDir', $civicrm_setting['Directory Preferences'])
  ? $civicrm_setting['Directory Preferences']['imageUploadDir'] : DRUPAL_WEBROOT . '/sites/default/files/civicrm/persist/contribute';
@mkdir($image_dir); // ensure it exists
system('cp -a ' . WP_WEBROOT . '/wp-content/plugins/files/civicrm/upload/* ' . $image_dir);

// custom_dir is a full path from server root
$custom_dir = array_key_exists('customFileUploadDir', $civicrm_setting['Directory Preferences'])
  ? $civicrm_setting['Directory Preferences']['customFileUploadDir'] : DRUPAL_WEBROOT . '/sites/default/files/civicrm/custom';
@mkdir($custom_dir); // ensure it exists
system('cp -a ' . WP_WEBROOT . '/wp-content/plugins/files/civicrm/custom/* ' . $custom_dir);