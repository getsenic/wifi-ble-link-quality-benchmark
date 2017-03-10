#!/bin/bash

# Description:		WiFi Host Reachability Benchmark
# Author:			Aravinth Panchadcharam

if [ $# -lt 4 ]; then	
	echo "./wifi-ping.sh host-nic-name host-antenna-type host-ip host-distance"
else
	nic=$1
	antenna=$2	
	host_ip=$3
	distance=$4
	echo -e "\n=> WiFi Host Reachability Benchmarking at distance" $distance "meters with NIC "$nic

	date_str="$(date +"%m-%d-%Y")"		
	ping_log="logs/"$nic"-wifi-host-ping-"$date_str".csv"	
	
	ping_count=30
	ping_interval=1

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $ping_log ]; then
		echo "nic,antenna,distance,timestamp,ping_packet_size,ping_loss,ping_min,ping_avg,ping_max,ping_mdev" >> $ping_log
	fi		

	# Measure packet statistics
	echo -e "\n=> Pinging the host "$host_ip
	
	# 64 bytes size packets
	ping_packet_size=64
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -i $ping_interval $host_ip)"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
	ping_mdev="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"

	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max, "mdev Time:" $ping_mdev

	echo $nic,$antenna,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_mdev >> $ping_log
	
	# 1024 bytes size packets, PING command adds additional 8 bytes somehow and that has to be subtracted
	ping_packet_size=1024
	timestamp="$(date +"%s")"
	ping_results="$(ping -c $ping_count -i $ping_interval -s $((ping_packet_size-8)) $host_ip)"
	ping_loss="$(echo "$ping_results" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
	ping_min="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
	ping_avg="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
	ping_max="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
	ping_mdev="$(echo "$ping_results" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"
	
	echo "Packet Size:" $ping_packet_size "bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min,\
	 "Average Time:" $ping_avg, "Max Time:" $ping_max, "mdev Time:" $ping_mdev

	echo $nic,$antenna,$distance,$timestamp,$ping_packet_size,$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_mdev >> $ping_log
fi
