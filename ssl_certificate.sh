#!/bin/bash 
current_epoch=$(date +"%s")
line="The Url for the site"
expiry_date=$( echo | openssl s_client -showcerts -servername $line -connect $line:443 2>/dev/null | openssl x509 -noout -enddate | cut -d "=" -f 2 )
expiry_epoch=$( date -d "$expiry_date" +%s )
expiry_days="$(( ($expiry_epoch - $current_epoch) / (3600 * 24) ))"
echo "ssl_certificate,hostname="$line "value="$expiry_days >> monitoring.txt

