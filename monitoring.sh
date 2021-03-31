#!/bin/bash 
df -h | grep -v loop | awk '{ if(NR>1) print "disk_usage,hostname=servername,mount_point=" $6 " value=" substr($5,1,length($5)-1)}'

freemem=$(vmstat -S M | awk '{print $4 + $6}' | tail -n 1)
totalmem=$(free -m | grep -i mem | awk '{print $2}')
echo "memory_usage,hostname= servername" " value="$((100 -( 100 * $freemem/$totalmem )))

save_current() {
    grep 'cpu ' /proc/stat > /tmp/cpustat
}

[ ! -e /tmp/cpustat ] && save_current

previous=$(cat /tmp/cpustat)
current=$(grep 'cpu ' /proc/stat)

awkscript='NR == 1 {
             owork=($2+$4);
             oidle=$5;
           }
           NR > 1 {
             work=($2+$4)-owork;
             idle=$5-oidle;
             printf 100 * work / (work+idle)
           }'

usage=$(echo -e "$previous\n$current" | awk "$awkscript")

save_current

echo "cpu_usage,hostname= servername" " value="$usage
exit 0
