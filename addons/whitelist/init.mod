#!/bin/bash
gid=`id -g`
pwd
sleep 2
if [ $gid -ne 0 ]; then
	echo "gid!=0, no root privileg"
	sleep 2
	exit
fi
if [ -f $ADDON/data/mod.kill ]; then
	echo "Removed old Module Kill Interupt"
	rm -f $ADDON/data/mod.kill
fi
if [ -f $ADDON/data/abortstart ]; then
	rm -f $ADDON/data/abortstart
fi
export ADDON=`cat addons/base/addon.set`

#Farben
export RED="\e[31m"
export NRM="\e[0m"
export GRN="\e[32m"

unset mod
unset log
unset modkill
unset amod
unset kamod
unset mod_tmux

#modkill reason
modkill(){
	echo "$1" > $ADDON/data/mod.kill
}
#log logger-name log-text*
log(){
	echo -e "[$1"$NRM"\t] $2"
}
#mod module-name <submod(def=main)>
mod(){
	if [ ! -f $ADDON/data/mod.kill ]; then
		module=$1
		subMod="main"
		if [ ${#2} -ge 1 ]; then
			subMod=$2
		fi
		bash "$ADDON/modules/$module/$subMod.mod"
		echo -e $NRM
	fi
}
#mod_tmux module-name <submod(def=main)>
mod_tmux(){
	if [ ! -f $ADDON/data/mod.kill ]; then
		module=$1
		subMod="main"
		if [ ${#2} -ge 1 ]; then
			subMod=$2
		fi
		tmux split-window -t "wp" -h "bash $ADDON/init.mod tmux $module $subMod"
	fi
}
#amod module-name <submod(def=main)>
amod(){
	if [ ! -f $ADDON/data/mod.kill ]; then
		module=$1
		subMod="main"
		if [ ${#2} -ge 1 ]; then
			subMod=$2
		fi
		bash "$ADDON/modules/$module/$subMod.mod" & echo $! > $ADDON/data/$module.pid
	fi
}
#kamod module-name
kamod(){
	module=$1
	if [ -f $ADDON/data/$module.pid ]; then #Wenn .pid Datei existiert
		pid=`cat $ADDON/data/$module.pid`
		rm $ADDON/data/$module.pid
		kill -9 $pid
	fi
}

#Exportieren
export -f log
export -f mod
export -f mod_tmux
export -f amod
export -f kamod
export -f modkill

#Main
core(){
	mod validateInterface
	if [ ! -f $ADDON/settings/interface.if ]; then
		mod setupBase
	fi
	mod loadBase
	mod airmonCtrl start
	mod scanTargets
	mod selectTarget
	mod scanClients
	mod airmonCtrl stop
	if [ -f $ADDON/data/mod.kill ]; then
		reason=`cat $ADDON/data/mod.kill`
		log "ERROR" "Exited because of $reason"
		rm -f $ADDON/data/mod.kill
	fi
}
case "$1" in
	tmux)
		mod $2 $3
		;;
	*)
		core
		;;
esac
sleep 3
