#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

##-- This is a script to delete drupal for the Wordpress to Drupal upgrade --##

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"

# Read Configurations
. ${ABS_CALLPATH}/utils/migrate_wp2drupal.conf

echo "Deleting Drupal Site..."
sudo rm -r ${PROJ_ROOT}/${PROJ_NAME}/${WEB_DIR}

echo "Dropping databases..."
mysql
DROP DATABASE membership_drupal
DROP DATABASE membership_civi

