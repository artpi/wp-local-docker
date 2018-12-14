<?php
// This file uploads db-dump.php to remote server and calls it to fetch db dump. Then it deletes it.

$PROD_FTP_USER="";
$PROD_FTP_PASS="";
$PROD_FTP_DIR="";
$PROD_FTP_ADDR="";
$SITE_URL="";


function lftp( $command ) {
	global $PROD_FTP_USER, $PROD_FTP_PASS, $PROD_FTP_DIR, $PROD_FTP_ADDR, $SITE_URL;
	passthru( "lftp -u ${PROD_FTP_USER},${PROD_FTP_PASS}  -e 'set ftp:ssl-allow no;${command};exit' ${PROD_FTP_ADDR}" );
}

$file = "db-dump.php";

lftp( 'put -O '. $PROD_FTP_DIR . '/ /var/scripts/' . $file );
copy(   $SITE_URL . '/' . $file . '?password=potato&' . time(), '/var/db-dump/production-dump.sql' ); // cache busting
lftp( 'rm '. $PROD_FTP_DIR . '/' . $file );


