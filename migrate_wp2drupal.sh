#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

##-- This is a script to migrate from Wordpress to Drupal --##

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"

# Read Configurations
#. ${ABS_CALLPATH}/migrate_civicrm_config.php
. ${ABS_CALLPATH}/migrate_wp2drupal.conf

# Installing Drupal using drush
pushd ${PROJ_ROOT}
echo "Installing the newest version of Drupal"
drush dl drupal-7.34
cd drupal-7.34
drush site-install -y standard --account-name=${CMS_USER} --account-pass=${CMS_PASS} --db-url=mysql://${CMS_MYSQL_USER}:${CMS_MYSQL_PASS}@${CMS_MYSQL_HOST}/${CMS_MYSQL_DB}
cd ..
mv drupal-7.34/ htdocs/
popd

# Installing CiviCRM
pushd ${PROJ_ROOT}/tars
sudo rm -r civicrm-4.5.5-drupal.tar.*
echo "downloading CiviCRM from URL..."
wget "https://download.civicrm.org/civicrm-4.5.5-drupal.tar.gz"
popd
pushd ${PROJ_ROOT}/${WEB_DIR}/sites/all/modules
sudo tar -zxf ${PROJ_ROOT}/tars/civicrm-4.5.5-drupal.tar.gz
popd

pushd ${PROJ_ROOT}/${WEB_DIR}/sites/all/modules/civicrm/install
sudo cp -rf ${PROJ_ROOT}/utils/migrate_wp2drupal/index.php ./
popd

echo "Giving CiviCRM permissions to write to default directory..."
sudo setfacl -R -m u:www-data:rwX,d:u:www-data:rwX /var/www/ushccdrupal.localhost/htdocs/sites/default

echo "Enabling CiviCRM using drush..."
drush en -y civicrm

# Migrating CiviCRM files
echo "Migrating CiviCRM files from Wordpress to Drupal..."
#migrate_civicrm_files.php


# Migrating databases
echo "Migrating Wordpress databases to Drupal..."
#migrate_civicrm_db.php
