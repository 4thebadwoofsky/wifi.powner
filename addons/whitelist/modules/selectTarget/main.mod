#!/bin/bash

#cat $ADDON/data/wifi_targets.lst
#AP-Macs filtern
apid=0

tmux set-option -t "wp" -g status-right "Select your prefered Target with the Keys 1-9"

mkdir $ADDON/data/wifi_targets.d/ > /dev/null

while read -r line
do
	# Wenn Zeile lang genug ist
	if [ ${#line} -ge 10 ]; then
		# mit RegEx MAC rausfiltern
		apmac=$( echo "$line" | (egrep -Eio "(([0-9A-Fa-f]{2}[-:]){5}[0-9A-Fa-f]{2})|(([0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4}|([0-9A-Fa-f]{12}))"))
		# Wenn MAC-Addresse valid ist
		if [ ${#apmac} -ge 10 ]; then
			apid=$((apid+1))
			echo $apmac > "$ADDON/data/wifi_targets.d/$apid"
			log "SLCTGT" "[$apid] $apmac"
		fi
	fi
done < "$ADDON/data/wifi_targets.lst"
apselected=0
while [ $apselected -eq 0 ];
do
	read -n 1 apselinput
	case $apselinput in
		''|*[!0-9]*)
			log "SLCTGT" "$apselinput is not valid"
		;;
		*)
			if [ $apselinput -gt 0 ]; then
				if [ $apselinput -le $apid ]; then
					apselected=$apselinput
				fi
			fi
		;;
	esac
done
apMac=`cat $ADDON/data/wifi_targets.d/$apselinput`
echo  "Selected $apselected [$apMac]"
echo $apMac > $ADDON/data/target.ap
rm -f $ADDON/data/wifi_targets.d/*
rmdir $ADDON/data/wifi_targets.d/
