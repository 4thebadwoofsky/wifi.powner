#!/bin/bash
exit
interface=`cat $ADDON/data/interface.if`
export interface

monitorId=`sudo airmon-ng start $interface | grep "monitor mode enabled on"`
monitorId=`echo "$monitorId" | tail -c 6`
monitorIdL=${#monitorId}
monitorIdLS=$((monitorIdL-1))
monitorId=`echo "$monitorId" | head -c $monitorIdLS`
echo $monitorId > $ADDON/data/monitor.mon

#sudo airmon-ng stop $monitorId
