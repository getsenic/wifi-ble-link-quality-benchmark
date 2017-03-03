#!/bin/bash

# Description:		BLE Benchmarking in Linux
# Author:			Aravinth Panchadcharam

if [ $# -lt 3 ]; then	
	echo "./linux-ble.sh nic-name antenna-type receiver-distance"	
else
	nic=$1
	antenna=$2
	distance=$3

	date_str="$(date +"%m-%d-%Y")"
	ble_notify_log="logs/ble_notify.log"
	ble_results_log="logs/"$nic"-ble-ping-"$date_str".csv"
	logging_time=20

	echo -e "\n=> Scanning BLE at distance" $distance "meters with NIC "$nic
	
	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $ble_results_log ]; then
		echo "nic","antenna","distance","notify_count","timestamp" > $ble_results_log
	fi	

	# Kill if there is any existing gatttool
	gatttool_pid="$(ps aux | grep 'gatttool' | grep -v grep | awk '{print $2}')"
	if [ "$gatttool_pid" != "" ]; then
		echo "Killing existing gatttool"
		kill $gatttool_pid
		sleep 1
	fi

	# Restart service and adapter because gatttool doesn't work after it is killed
	service bluetooth restart
	hciconfig hci0 reset
	sleep 5

	# Run gatttool for given time to receive notifications	
	echo "Running gatttool"
	gatttool -b F9:8D:BB:F1:15:34 -t random --char-write-req -a 0x002c -n 01 --listen &> $ble_notify_log &
	sleep $logging_time
	gatttool_pid="$(ps aux | grep 'gatttool' | grep -v grep | awk '{print $2}')"
	if [ "$gatttool_pid" != "" ]; then
		echo "Killing gatttool"
		kill $gatttool_pid
		sleep 1
	else
		echo "gatttool failed"
	fi

	# Get statistics
	timestamp="$(date +"%s")"
	notify_count="$(cat "$ble_notify_log" | grep Notification | wc -l)"	

	echo "Notification count:" $notify_count
	echo $nic,$antenna,$distance,$notify_count,$timestamp >> $ble_results_log

	if [ "$notify_count" == 0 ]; then
		echo "====> RERUN THE SCRIPT"
	fi
fi