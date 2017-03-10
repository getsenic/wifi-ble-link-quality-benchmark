#!/bin/bash

# Description:		BLE Benchmarking in Linux
# Author:			Aravinth Panchadcharam

if [ $# -lt 4 ]; then	
	echo "./linux-ble.sh nic-name usb/uart antenna-type receiver-distance"	
else
	nic=$1
	nic_type=$2
	antenna=$3
	distance=$4
	device_mac="F9:8D:BB:F1:15:34"
	echo -e "\n=> BLE Benchmarking at distance" $distance "meters with NIC "$nic

	hci_usb="$(hciconfig | grep USB | cut -d ":" -f1)"
	hci_uart="$(hciconfig | grep UART | cut -d ":" -f1)"

	date_str="$(date +"%m-%d-%Y")"
	timestamp="$(date +"%s")"
	ble_notify_log="logs/ble_notify.log"
	btmon_capture_log="logs/rssi.btsnoop"
	btmon_log="logs/rssi.log"
	ble_ping_log="logs/"$nic"-ble-ping-"$date_str".csv"
	ble_rssi_log="logs/"$nic"-ble-rssi-"$date_str".csv"	
	logging_time=20		

	########## RSSI ##########

	# Restart service and adapter because gatttool doesn't work after it is killed
	echo -e "\nRestarting Bluetooth service and reset HCI adapter"
	sudo service bluetooth restart
	
	if [ $nic_type == "usb" ]; then		
		echo "Using external USB Bluetooth adapter"
		sudo hciconfig $hci_usb reset
		sudo hciconfig $hci_uart down
		sudo hciconfig $hci_usb up	
	else
		echo "Using internal UART Bluetooth adapter"
		sudo hciconfig $hci_uart reset		
		sudo hciconfig $hci_uart up
	fi

	sleep 5

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $ble_rssi_log ]; then
		echo "nic","antenna","distance","rssi","timestamp" > $ble_rssi_log
	fi	

	# Kill if there is any existing btmon/hcitool
	btmon_pid="$(ps aux | grep 'btmon' | grep -v grep | awk '{print $2}')"
	if [ "$btmon_pid" != "" ]; then
		echo "Killing existing btmon"
		sudo kill $btmon_pid
		sleep 1
	fi

	hcitool_pid="$(ps aux | grep 'hcitool' | grep -v grep | awk '{print $2}')"
	if [ "$hcitool_pid" != "" ]; then
		echo "Killing existing hcitool"
		sudo kill $hcitool_pid
		sleep 1
	fi

	# Run btmon and hcitool lescan for the given duration
	echo -e "\nScanning RSSI of BLE peripheral" $device_mac
	sudo btmon -w $btmon_capture_log &> /dev/null &
	sleep 1
	sudo hcitool lescan &> /dev/null &
	sleep $logging_time

	# Stop scanning and aggregate rssi
	btmon_pid="$(ps aux | grep 'btmon' | grep -v grep | awk '{print $2}')"
	if [ "$btmon_pid" != "" ]; then
		echo "Closing scanning"
		sudo kill $btmon_pid
		sleep 1

		sudo btmon -r $btmon_capture_log > $btmon_log
		cat $btmon_log | grep F9:8D:BB:F1:15:34 -A 10 | grep RSSI

		no_of_samples="$(cat $btmon_log | grep F9:8D:BB:F1:15:34 -A 10 | grep RSSI | cut -d ":" -f2 | cut -d ' ' -f2 | wc -l)"
		rssi_total=0
		for ((i=1; i<=no_of_samples; i++));
		do			
			rssi="$(cat $btmon_log | grep F9:8D:BB:F1:15:34 -A 10 | grep RSSI | cut -d ":" -f2 | cut -d ' ' -f2 | sed -n "${i}p" )"
			(( rssi_total += rssi ))
		done
		rssi_avg=$((rssi_total / no_of_samples))
		echo $nic,$antenna,$distance,$rssi_avg,$timestamp >> $ble_rssi_log

	else
		echo "Scanning failed"
	fi

	hcitool_pid="$(ps aux | grep 'hcitool' | grep -v grep | awk '{print $2}')"
	if [ "$hcitool_pid" != "" ]; then
		echo "Killing hcitool"
		sudo kill $hcitool_pid
		sleep 1
	fi

	########## PING ##########

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $ble_ping_log ]; then
		echo "nic","antenna","distance","notify_count","timestamp" > $ble_ping_log
	fi	

	# Kill if there is any existing gatttool
	gatttool_pid="$(ps aux | grep 'gatttool' | grep -v grep | awk '{print $2}')"
	if [ "$gatttool_pid" != "" ]; then
		echo "Killing existing gatttool"
		sudo kill $gatttool_pid
		sleep 1
	fi

	# Restart service and adapter because gatttool doesn't work after it is killed
	echo -e "\nRestarting Bluetooth service and reset HCI adapter"
	sudo service bluetooth restart
	
	if [ $nic_type == "usb" ]; then		
		echo "Using external USB Bluetooth adapter"
		sudo hciconfig $hci_usb reset
		sudo hciconfig $hci_uart down
		sudo hciconfig $hci_usb up	
	else
		echo "Using internal UART Bluetooth adapter"
		sudo hciconfig $hci_uart reset		
		sudo hciconfig $hci_uart up
	fi

	sleep 5

	# Run gatttool for given time to receive notifications	
	echo -e "\nConnecting to BLE peripheral via gatttool"
	sudo gatttool -b $device_mac -t random --char-write-req -a 0x002c -n 01 --listen &> $ble_notify_log &	
	sleep $logging_time

	# Stop scanning and aggregate ping
	gatttool_pid="$(ps aux | grep 'gatttool' | grep -v grep | awk '{print $2}')"
	if [ "$gatttool_pid" != "" ]; then
		echo "Closing connection"
		sudo kill $gatttool_pid
		sleep 1

		# Get statistics
		timestamp="$(date +"%s")"
		notify_count="$(cat "$ble_notify_log" | grep Notification | wc -l)"	

		echo -e "\nNotification count:" $notify_count
		echo $nic,$antenna,$distance,$notify_count,$timestamp >> $ble_ping_log

	else
		echo "Connection failed"
		notify_count="$(cat "$ble_notify_log" | grep Notification | wc -l)"	

		if [ "$notify_count" == 0 ]; then
			echo "====> RERUN THE SCRIPT"
			cat $ble_notify_log
		fi
	fi

fi
