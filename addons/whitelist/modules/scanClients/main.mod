#!/bin/bash
#Variabeln auslesen

AP=`cat $ADDON/data/target.ap`
mymac=`cat $ADDON/settings/mymac.mac`
tmux set-option -t "wp" -g status-right "Active"

export mymac
export AP

#Alte überbleibsel
rm -f $ADDON/data/temp-*.csv
rm -f $ADDON/data/byebyeclients.lst
rm -f $ADDON/data/byebyeclients.temp.lst
echo "" > $ADDON/data/byebyeclients.lst

#Nach MACs suchen
tmux split-window -t "wp" -v "airodump-ng mon0 --bssid $AP --output-format csv -w $ADDON/data/temp"
tmux next-window -t "wp"

sleep 1
echo 1 > $ADDON/data/run.kick
mod_tmux loopKickClients

stopLoop()
{
	rm -f $ADDON/data/run.kick
}
clear
trap stopLoop SIGINT
trap stopLoop SIGTERM
pass=0
while [ -f $ADDON/data/run.kick ];
do
	pass=$((pass+1))
	if [ $pass -ge 60 ]; then
		pass=0
		rm -f $ADDON/data/temp-01.csv
		tmux respawn-pane -k -t "wp:.1"
		while [ ! -f $ADDON/data/temp-01.csv ];
		do
			sleep 1
		done
	fi
	echo -e "\e[0;0H"
	date
	echo "Ticks $pass/60[30s]"
	cat $ADDON/data/temp-01.csv | egrep -o -E "(([0-9A-Fa-f]{2}[-:]){5}[0-9A-Fa-f]{2})|(([0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4}|([0-9A-Fa-f]{12}))" | grep -i --invert-match "$AP"> $ADDON/data/byebyeclients.temp.lst
	while read -r line
	do
		if [ ${#line} -ge 10 ]; then
			echo -e "found Client '$line'\n"
		fi
	done < "$ADDON/data/byebyeclients.temp.lst"

	echo -e "Applying Filters:\n"

	inLines=$(cat "$ADDON/data/byebyeclients.temp.lst")
	while read -r line
	do
		inLines=$( echo "$inLines" | (bash "$ADDON/settings/filters.d/$line"))
	done < "$ADDON/settings/filters"

	echo $inLines | while read -r line
	do
		if [ ${#line} -ge 10 ]; then
			echo -e "Kicking: $line\n"
		fi
	done
	echo $inLines > "$ADDON/data/byebyeclients.lst"
	sleep 0.5
done
tmux send-keys -t "wp" C-c
killall airodump-ng
kamod loopKickClients
if [ -f $ADDON/data/run.kick ];then
	rm -f $ADDON/data/run.kick
fi
