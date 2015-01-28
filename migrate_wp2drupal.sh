#!/bin/bash

##-- This is a script to migrate CiviCRM from Wordpress to Drupal --##

set -e # Exit immediately if a command exits with a non-zero status.

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"

# Read Configurations
. ${ABS_CALLPATH}/migrate_wp2drupal.conf

echo "Installing Drupal ${CMS_VER} and CiviCRM ${CRM_VER}..."
civibuild create drupal-clean --civi-ver ${CRM_VER} --cms-ver ${CMS_VER} --url ${SITE_URL} \
  --title "${SITE_TITLE}" --admin-user ${CMS_USER} --admin-pass ${CMS_PASS} --admin-email ${CMS_EMAIL} --force-download --force

# Migrating CiviCRM files
echo "Migrating CiviCRM files from Wordpress to Drupal..."
ABS_CALLPATH/migrate_civicrm_files.php


# Migrating databases
echo "Migrating Wordpress databases to Drupal..."
ABS_CALLPATH/migrate_civicrm_db.php