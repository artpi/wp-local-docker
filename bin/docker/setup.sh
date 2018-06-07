#!/bin/bash
cd /var/www/html
#wp core download --skip-themes --skip-plugins
rm wp-config.php
wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password
wp core install --url=localhost --title="Test site" --admin_user=admin --admin_email=artur.piszek@gmail.com --admin_password=password

/var/scripts/import-db-from-prod-dump.sh
