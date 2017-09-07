#!/bin/bash
if [ -f $ADDON/settings/interface.if ]; then
	log "$NRM VALID" "Checking for Interface-Availability"
	checkInterface=`cat $ADDON/settings/interface.if`
	ifconfig $checkInterface > /dev/null
	exitCode=$?
	if [ $exitCode -ne 0 ]; then
		log "$RED VALID" "Interface '$checkInterface' is not available, destroying handle"
		rm -f $ADDON/settings/interface.if $ADDON/settings/mymac.mac
	fi
	if [ $exitCode -eq 0 ]; then
		log "$GRN VALID" "Interface '$checkInterface' is available"
	fi
fi
