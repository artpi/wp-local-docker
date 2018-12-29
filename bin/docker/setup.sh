#!/bin/bash
cd /var/www/html
if [ -f /var/www/html/xmlrpc.php ]
then
	echo "skipping wg install\n"
elif [ -f /var/www/html/wp-content/themes ]
then
	wp core download --skip-content
else
	wp core download
fi

rm wp-config.php
wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password
wp core install --url=localhost --title="Test site" --admin_user=admin --admin_email=artur.piszek@gmail.com --admin_password=password

/var/scripts/import-db-from-prod-dump.sh
