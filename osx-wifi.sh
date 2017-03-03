#!/bin/bash

# Description:		BLE Benchmarking in OSX
# Author:			Aravinth Panchadcharam

if [ $# -lt 2 ]; then	
	echo "./airport-extreme.sh antenna-type receiver-distance"
	echo "Enter the distance of the receiver from the sender and type of antenna"
else
	echo "= Benchmarking Airport Extreme - MacBook Pro - MacOS 10.12.3 ="
	date_str="$(date +"%m-%d-%Y")"	
	rssi_file_name="logs/airport-rssi-"$date_str".csv"
	ping_file_name="logs/airport-ping-"$date_str".csv"	
	ssid="$(airport -I | grep " SSID" | cut -d":" -f 2 | sed 's/ //g')"
	nic="airport-extreme"
	antenna=$1
	distance=$2

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $rssi_file_name ]; then		
		echo "nic,antenna,ssid,distance,timestamp,rssi,noise,channel,snr" > $rssi_file_name
	fi

	# Measure RSSI & Noise
	echo -e "\n=> Scanning at distance" $distance "meters with SSID" $ssid
	no_of_samples=30
	sampling_interval_in_sec=1
	for ((i=0; i<=no_of_samples; i++)); 
	do
		timestamp="$(date +"%s")"
		scan="$(airport -I)"
	   	rssi="$(echo "$scan" | grep "agrCtlRSSI" | cut -d":" -f 2 | sed 's/ //g')"
	   	noise="$(echo "$scan" | grep "agrCtlNoise" | cut -d":" -f 2 | sed 's/ //g')"
	   	channel="$(echo "$scan" | grep "channel" | cut -d":" -f 2 | sed 's/ //g' | tr "," ":")"
	   	snr=$((rssi - $noise))

	   	echo "RSSI:" $rssi, "Noise:" $noise, "SNR:" $snr, "Channel:" $channel
		echo $nic,$antenna,$ssid,$distance,$timestamp,$rssi,$noise,$channel,$snr >> $rssi_file_name
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
