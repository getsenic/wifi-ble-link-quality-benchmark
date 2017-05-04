#!/bin/bash

# Description:		WiFi Benchmarking in Linux
# Author:			Aravinth Panchadcharam

if [ $# -lt 4 ]; then	
	echo "./linux-wifi.sh nic-name antenna-type wlan-interface receiver-distance"
else
	nic=$1
	antenna=$2
	wlan_interface=$3
	distance=$4
	echo -e "\n=> WiFi Benchmarking at distance" $distance "meters with NIC "$nic

	date_str="$(date +"%m-%d-%Y")"	
	rssi_log="logs/"$nic"-wifi-rssi-"$date_str".csv"
	ping_log="logs/"$nic"-wifi-ping-"$date_str".csv"	
	ssid="$(iw wlan0 link | grep SSID | cut -d ":" -f 2 | sed 's/ //g')"	

	rssi_count=20
	rssi_interval=1
	ping_count=20
	ping_interval=0.5
	ping_host="google.com"

	# Create logs directory if not exists
	if [ ! -d "logs" ]; then
  		mkdir logs
	fi

	# ########## RSSI ##########

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $rssi_log ]; then		
		echo "nic,antenna,ssid,distance,timestamp,rssi" > $rssi_log
	fi

	# Measure RSSI & link_quality
	echo -e "\nScanning RSSI of link "$ssid		
	for ((i=0; i<=rssi_count; i++)); 
	do
		timestamp="$(date +"%s")"
		scan="$(iw wlan0 link)"
	   	rssi="$(echo "$scan" | grep signal | cut -d ":" -f 2 | cut -d " " -f 2)"
	   	echo "RSSI:" $rssi "dBm"
		echo $nic,$antenna,$ssid,$distance,$timestamp,$rssi>> $rssi_log
		sleep $rssi_interval
	done

	########## PING ##########

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $ping_log ]; then		
		echo "nic,antenna,ssid,distance,timestamp,ping_packet_size,ping_loss,ping_min,ping_avg,ping_max" >> $ping_log
	fi		

	# Measure packet statistics
	echo -e "\n=> Pinging the host "$ping_host
	
	# 64 bytes size packets
	ping_packet_size=64
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -s $ping_packet_size -I $wlan_interface $ping_host)"
	echo "$ping_results" > "logs/ping-64.log"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3 | tr -d "ms")"

	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max

	echo $nic,$antenna,$ssid,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max >> $ping_log
	
	# 1024 bytes size packets
	ping_packet_size=1024
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -s $ping_packet_size -I $wlan_interface $ping_host)"
	echo "$ping_results" > "logs/ping-1024.log"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3 | tr -d "ms")"
	
	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max

	echo $nic,$antenna,$ssid,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max >> $ping_log
fi
