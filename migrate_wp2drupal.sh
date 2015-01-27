#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

##-- This is a script to migrate from Wordpress to Drupal --##

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"

# Read Configurations
. ${ABS_CALLPATH}/migrate_civicrm_config.php

# Installing Drupal using drush
pushd ${PROJ_ROOT}
echo "Installing the newest version of Drupal"
drush dl drupal-7.34
drush site-install standard --account-name=ginkgo --account-pass=d3v3l0p3r --db-url=mysql://ginkgo:CiviDev0123#@localhost/membership_drupal

# Installing CiviCRM
set -e # Exit immediately if a command exits with a non-zero status.
echo "downloading CiviCRM from URL..."
wget "https://download.civicrm.org/civicrm-4.5.5-drupal.tar.gz"



# Migrating CiviCRM files
echo "Migrating CiviCRM files from Wordpress to Drupal..."
migrate_civicrm_files.php


# Migrating databases
echo "Migrating Wordpress databases to Drupal..."
migrate_civicrm_db.php

