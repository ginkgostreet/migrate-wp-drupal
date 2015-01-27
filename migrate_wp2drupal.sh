#!/bin/bash

##-- This is a script to migrate CiviCRM from Wordpress to Drupal --##

set -e # Exit immediately if a command exits with a non-zero status.

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"

# Read Configurations
. ${ABS_CALLPATH}/migrate_wp2drupal.conf

echo "Deleting anything that might be under the web root..."
rm -rf ${PROJ_ROOT}/${WEB_DIR}/*

echo "Installing the newest version of Drupal..."
drush dl drupal-7.34 --destination=${PROJ_ROOT}
mv ${PROJ_ROOT}/drupal-7.34 ${PROJ_ROOT}/${WEB_DIR}
drush -r ${PROJ_ROOT}/${WEB_DIR} site-install -y standard --account-name=${CMS_USER} --account-pass=${CMS_PASS} --db-url=mysql://${CMS_MYSQL_USER}:${CMS_MYSQL_PASS}@${CMS_MYSQL_HOST}/${CMS_MYSQL_DB}

# Installing CiviCRM
echo "Downloading CiviCRM..."

set +e # don't choke on a non-zero exit status

MY_TARGZ="civicrm-${CRM_VER}-drupal.tar.gz"

if [[ ! ( -f "${PROJ_ROOT}/tars/${MY_TARGZ}" ) ]]; then
  mkdir -p ${PROJ_ROOT}/tars
  echo "... to ${PROJ_ROOT}/tars/"
  wget -P ${PROJ_ROOT}/tars/ "http://downloads.sourceforge.net/project/civicrm/civicrm-stable/${CRM_VER}/${MY_TARGZ}"
fi

if [[ ! ( -f "${PROJ_ROOT}/tars/${MY_TARGZ}" ) ]]; then
  echo "${MY_TARGZ} was not found and could not be downloaded" 1>&2
  exit 1
fi

set -e # Exit immediately if a command exits with a non-zero status.

sudo tar -zxf ${PROJ_ROOT}/tars/civicrm-4.5.5-drupal.tar.gz -C ${PROJ_ROOT}/${WEB_DIR}/sites/all/modules
drush -r ${PROJ_ROOT}/${WEB_DIR} civicrm-install --dbhost ${CRM_MYSQL_HOST} --dbname ${CRM_MYSQL_DB} --dbpass ${CRM_MYSQL_PASS} --dbuser ${CRM_MYSQL_USER} --site-url ${CRM_SITE_URL}

# echo "Giving CiviCRM permissions to write to default directory..."
# sudo setfacl -R -m u:www-data:rwX,d:u:www-data:rwX /var/www/ushccdrupal.localhost/htdocs/sites/default

echo "Enabling CiviCRM using drush..."
drush en -y civicrm

# Migrating CiviCRM files
echo "Migrating CiviCRM files from Wordpress to Drupal..."
#migrate_civicrm_files.php


# Migrating databases
echo "Migrating Wordpress databases to Drupal..."
#migrate_civicrm_db.php
