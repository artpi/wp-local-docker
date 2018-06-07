#!/bin/bash
cd /var/www/html
#wp core download --skip-themes --skip-plugins
rm wp-config.php
wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password
wp core install --url=localhost --title="Test site" --admin_user=admin --admin_email=artur.piszek@gmail.com --admin_password=password
if [ -f /var/db-dump/production-dump.sql ]; then
	echo "Found file with production db dump. Importing"
	wp db reset --yes
    wp db import /var/db-dump/production-dump.sql
    echo "Changing $(wp option get siteurl) to  http://localhost"
	wp search-replace $(wp option get siteurl) "http://localhost"
fi
