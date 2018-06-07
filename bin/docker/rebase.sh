#!/bin/bash
if [ ! -f /var/scripts/config.sh ]; then
	echo "No valid config file: /bin/docker/config.sh . please copy /bin/docker/default-config.sh and rename."
fi
source /var/scripts/config.sh

lftp  -u $PROD_FTP_USER,$PROD_FTP_PASS  -e 'set ftp:ssl-allow no;mirror -en -x \cache/$ -P 4 ${PROD_FTP_DIR} /var/www/html/wp-content;exit' $PROD_FTP_ADDR
echo "Files updated. Please commit these new files."
