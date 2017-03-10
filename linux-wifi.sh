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
	ssid="$(iwgetid | cut -d ":" -f 2 | tr -d ""\")"	

	rssi_count=30
	rssi_interval=1
	ping_count=30
	ping_interval=0.5
	ping_host="google.com"

	# ########## RSSI ##########

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $rssi_log ]; then		
		echo "nic,antenna,ssid,distance,timestamp,rssi,link_quality,channel,link_quality_in_percentage" > $rssi_log
	fi

	# Measure RSSI & link_quality
	echo -e "\nScanning RSSI of link "$ssid		
	for ((i=0; i<=rssi_count; i++)); 
	do
		timestamp="$(date +"%s")"
		scan="$(iwconfig $wlan_interface)"
	   	rssi="$(echo "$scan" | grep Signal | cut -d "=" -f3 | tr -d " dBm")"
	   	link_quality="$(echo "$scan" | grep Signal | cut -d "=" -f2 | cut -d " " -f 1 | cut -d "/" -f 1)"
	   	link_quality_in_percentage=$((link_quality * 100 / 70))
	   	channel="$(iwlist $wlan_interface channel | grep Current | cut -d "(" -f 2 | cut -d " " -f2 | tr -d ")")"
	   	
	   	echo "RSSI:" $rssi, "Link Quality:" $link_quality "("$link_quality_in_percentage "%)", "Channel:" $channel
		echo $nic,$antenna,$ssid,$distance,$timestamp,$rssi,$link_quality,$channel,$link_quality_in_percentage >> $rssi_log
		sleep $rssi_interval
	done


	########## PING ##########

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $ping_log ]; then		
		echo "nic,antenna,ssid,distance,timestamp,ping_packet_size,ping_loss,ping_min,ping_avg,ping_max,ping_mdev" >> $ping_log
	fi		

	# Measure packet statistics
	echo -e "\n=> Pinging the host "$ping_host
	
	# 64 bytes size packets
	ping_packet_size=64
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -i $ping_interval -s $ping_packet_size -I $wlan_interface $ping_host)"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
	ping_mdev="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"

	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max, "mdev Time:" $ping_mdev

	echo $nic,$antenna,$ssid,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_mdev >> $ping_log
	
	# 1024 bytes size packets
	ping_packet_size=1024
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -i $ping_interval -s $ping_packet_size -I $wlan_interface $ping_host)"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
	ping_mdev="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"
	
	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max, "mdev Time:" $ping_mdev

	echo $nic,$antenna,$ssid,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_mdev >> $ping_log
fi
