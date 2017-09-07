#!/bin/bash
monitorId=`cat $ADDON/settings/monitor.mon`
export $monitorId
#Alte überbleibsel
rm -f $ADDON/data/initscan-*.csv
rm -f $ADDON/data/wifi_targets.lst

tmux set-option -t "wp" -g status-right "Ctrl-C to stop Scanning for Targets"

#Nach MACs suchen
airodump-ng $monitorId -a --output-format csv -w $ADDON/data/initscan

if [ ! -f $ADDON/data/initscan-01.csv ]; then
	modkill "No 'airodump-ng' output"
else
	#Leeren
	sleep 1

	#Nur die APs einlesen, die Clients ignorieren
	while read -r line
	do
		if [[ $line == *"Station MAC"* ]]; then
			break;
		fi
		echo $line >> $ADDON/data/initscan.csv
	done < "$ADDON/data/initscan-01.csv"
	if [ ! -f $ADDON/data/initscan.csv ]; then
		modkill "No Access-Point's found"
	else
		#Aufraeumen
		rm -f $ADDON/data/initscan-01.csv

		#AP-Macs filtern
		while read -r line
		do
			# Wenn Zeile lang genug ist
			if [ ${#line} -ge 10 ]; then
				# mit RegEx MAC rausfiltern
				apmac=$( echo "$line" | (egrep -Eio "(([0-9A-Fa-f]{2}[-:]){5}[0-9A-Fa-f]{2})|(([0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4}|([0-9A-Fa-f]{12}))"))
				essid=$( echo "$line" | (rev | cut -d , -f1-2 | rev))
				essid=${essid//[,]/}

				# Wenn MAC-Addresse valid ist
				if [ ${#apmac} -ge 10 ]; then
					echo "$apmac/$essid" >> $ADDON/data/wifi_targets.lst
					log "SCTGTS" "Inserted new AP: $apmac=$essid"
				fi
			fi
		done < "$ADDON/data/initscan.csv"
		rm -f $ADDON/data/initscan.csv
		log "SCTGTS" "Finished"
	fi
fi
