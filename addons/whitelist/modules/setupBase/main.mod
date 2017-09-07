#!/bin/bash
checkInterface=''
loadedInterface=0
while [ $loadedInterface -eq 0 ];
do
	read -p "Interface Name:" checkInterface
	ifconfig $checkInterface > /dev/null
	if [[ $? -eq 0 ]]; then
		loadedInterface=1
	fi
done
echo $checkInterface > $ADDON/settings/interface.if
