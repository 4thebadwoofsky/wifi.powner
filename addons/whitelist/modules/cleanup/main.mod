#!/bin/bash
if [ -f $ADDON/data/targets.d ]; then
	rm -f $ADDON/data/targets.d/*
	rmdir $ADDON/data/targets.d
fi
