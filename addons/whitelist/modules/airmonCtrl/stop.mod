#!/bin/bash
monitorId=`cat $ADDON/settings/monitor.mon`
export monitorId
sudo airmon-ng stop $monitorId
