#!/bin/bash

# This script uses https://github.com/git-ftp/git-ftp to push changes to production environment.
# It needs data from docker/config.sh. PROD_FTP_DIR is root of WP install.
# It will only upload wp-content !
# Run this script from project root.

source ./bin/docker/config.sh
git ftp push ftp://${PROD_FTP_ADDR}${PROD_FTP_DIR} -v --syncroot ./wp-content/ -u $PROD_FTP_USER -p $PROD_FTP_PASS
