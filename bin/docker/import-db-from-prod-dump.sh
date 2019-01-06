#!/bin/bash

if [ -f /var/db-dump/production-dump.sql ]; then
	echo "Found file with production db dump. Importing"
	wp db reset --yes
    wp db import /var/db-dump/production-dump.sql
    IS_MULTISITE=$( wp config get MULTISITE )
	if [[ $IS_MULTISITE == *"1"* ]]; then
		echo "This is a multisite. We need to convert all subdomains."
		CONFIG_DOMAIN=$( wp config get DOMAIN_CURRENT_SITE | xargs)
		URL_DOMAIN=$( wp config get PRODUCTION_DOMAIN_CURRENT_SITE | xargs)
		echo "Changing $URL_DOMAIN to $CONFIG_DOMAIN"
		wp search-replace --network --all-tables-with-prefix "$URL_DOMAIN" "$CONFIG_DOMAIN"
	else
	    echo "Changing $(wp option get siteurl) to  http://localhost"
		wp search-replace $(wp option get siteurl) "http://localhost"
	fi
fi
