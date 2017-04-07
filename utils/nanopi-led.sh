#!/bin/bash

# Description:		BLE Benchmarking in Linux
# Author:			Aravinth Panchadcharam


blue_trigger="$(cat /sys/class/leds/blue_led/trigger | awk -F '[][]' '{print $2}')"
if [ "$blue_trigger" != "heartbeat" ]; then	
	echo heartbeat > /sys/class/leds/blue_led/trigger
fi

green_trigger="$(cat /sys/class/leds/green_led/trigger | awk -F '[][]' '{print $2}')"
if [ "$green_trigger" != "none" ]; then	
	echo none > /sys/class/leds/green_led/trigger
	echo 0 > /sys/class/leds/green_led/brightness
fi