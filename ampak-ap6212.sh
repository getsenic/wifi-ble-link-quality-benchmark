#!/bin/bash

# Description:		Benchmark Ampak AP6212 on Nanopi Neo Air Ubuntu Core 3.4.39 Kernel 
# Author:			Aravinth Panchadcharam

# Platform:			NanoPi Neo Air
# OS:				Ubuntu 16.04.1 LTS (Ubuntu Core with Qt Embedded by Friendly ARM)
# Kernel:			3.4.39
# Card Type:		Ampak AP6212
# Firmware:			Broadcom BCM43438

# Type of antenna
# 1 = PCB (P4204 4AEA01-L) Pulse Antenna PWB 3.9 Inch
# 2 = 2.4Ghz Swivel Antenna


if [ $# -lt 2 ]; then	
	echo "./airport-extreme.sh antenna-type receiver-distance"
	echo "Enter the distance of the receiver from the sender and type of antenna"
else
	echo "= Benchmark Ampak AP6212 on Nanopi Neo Air Ubuntu Core 3.4.39 Kernel ="
	date_str="$(date +"%m-%d-%Y")"	
	rssi_file_name="logs/ampak-rssi-"$date_str".csv"
	ping_file_name="logs/ampak-ping-"$date_str".csv"	
	ssid="$(iwgetid | cut -d ":" -f 2 | tr -d ""\")"
	nic="ampak-ap6212"
	antenna=$1
	distance=$2

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $rssi_file_name ]; then		
		echo "nic,antenna,ssid,distance,timestamp,rssi,link_quality,channel,link_quality_in_percentage" > $rssi_file_name
	fi

	# Measure RSSI & link_quality
	echo -e "\n=> Scanning at distance" $distance "meters with SSID" $ssid
	no_of_samples=30
	sampling_interval_in_sec=1
	for ((i=0; i<=no_of_samples; i++)); 
	do
		timestamp="$(date +"%s")"
		scan="$(iwconfig wlan0)"
	   	rssi="$(echo "$scan" | grep Signal | cut -d "=" -f3 | tr -d " dBm")"
	   	link_quality="$(echo "$scan" | grep Signal | cut -d "=" -f2 | cut -d " " -f 1 | cut -d "/" -f 1)"
	   	link_quality_in_percentage=$((link_quality * 100 / 70))
	   	channel="$(iwlist wlan0 channel | grep Current | cut -d "(" -f 2 | cut -d " " -f2 | tr -d ")")"
	   	
	   	echo "RSSI:" $rssi, "Link Quality:" $link_quality "("$link_quality_in_percentage "%)", "Channel:" $channel
		echo $nic,$antenna,$ssid,$distance,$timestamp,$rssi,$link_quality,$channel,$link_quality_in_percentage >> $rssi_file_name
		sleep $sampling_interval_in_sec
	done

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $ping_file_name ]; then		
		echo "nic,antenna,ssid,distance,timestamp,ping_packet_size,ping_loss,ping_min,ping_avg,ping_max,ping_mdev" >> $ping_file_name
	fi		

	# Measure packet statistics
	echo -e "\n=> Ping Statistics"
	ping_count=30
	ping_interval=0.5
	ping_host="google.com"

	# 64 bytes size packets
	ping_packet_size=64
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -i $ping_interval -s $ping_packet_size $ping_host)"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
	ping_mdev="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"

	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max, "mdev Time:" $ping_mdev

	echo $nic,$antenna,$ssid,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_mdev >> $ping_file_name
	
	# 1024 bytes size packets
	ping_packet_size=1024
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -i $ping_interval -s $ping_packet_size $ping_host)"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
	ping_mdev="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"
	
	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max, "mdev Time:" $ping_mdev

	echo $nic,$antenna,$ssid,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_mdev >> $ping_file_name
fi
