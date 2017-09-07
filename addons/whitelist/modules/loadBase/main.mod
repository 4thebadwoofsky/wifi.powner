#!/bin/bash

#Getting Interface
interface=`cat $ADDON/settings/interface.if`
#Writing own MAC-ID
ifconfig $interface | egrep -o -E "(([0-9A-Fa-f]{2}[-:]){5}[0-9A-Fa-f]{2})|(([0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4}|([0-9A-Fa-f]{12}))" > $ADDON/settings/mymac.mac
mymac=`cat $ADDON/settings/mymac.mac`
log " LOADB" "Local-MAC-Address for this Device is [$mymac]"
