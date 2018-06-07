#!/bin/bash

if [ -f /var/db-dump/production-dump.sql ]; then
	echo "Found file with production db dump. Importing"
	wp db reset --yes
    wp db import /var/db-dump/production-dump.sql
    echo "Changing $(wp option get siteurl) to  http://localhost"
	wp search-replace $(wp option get siteurl) "http://localhost"
fi
