#!/bin/bash

# Description:		Benchmark Airport Extreme - MacBook Pro - MacOS 10.12.3
# Author:			Aravinth Panchadcharam

# Card Type:		AirPort Extreme  (0x14E4, 0x134)
# Firmware:			Broadcom BCM43xx 1.0 (7.21.171.68.1a5)
# MAC Address:		6c:40:08:9f:31:3

echo "===== Benchmarking Airport Extreme - MacBook Pro - MacOS 10.12.3 ====="

timestamp="$(date +"%m-%d-%Y_%T")"
rssi_file_name="logs/airport-rssi-"$timestamp".csv"
ping_file_name="logs/airport-ping-"$timestamp".csv"
date_str="($date)"

# Remove file, if exists
if [ -e $rssi_file_name ]; then
	rm -f $rssi_file_name
fi

# Add comments and headers to CSV files
ssid="$(airport -I | grep " SSID" | cut -d":" -f 2 | sed 's/ //g')"
echo "# NIC: AirPort Extreme | SSID:" $ssid "| Date:" $date_str > $rssi_file_name 
echo "rssi,noise,channel" >> $rssi_file_name
echo "# NIC: AirPort Extreme | SSID:" $ssid "| Date:" $date_str > $ping_file_name 
echo "packet_size,packet_loss,min_time,avg_time,max_time,max_time,mdev_time" >> $ping_file_name

# Measure RSSI & Noise
echo -e "\n=> RSSI Scan"
no_of_sample="5"
sampling_interval_in_sec=1
for ((i=0; i<=no_of_sample; i++)); 
do
	scan="$(airport -I)"
   	rssi="$(echo "$scan" | grep "agrCtlRSSI" | cut -d":" -f 2 | sed 's/ //g')"
   	noise="$(echo "$scan" | grep "agrCtlNoise" | cut -d":" -f 2 | sed 's/ //g')"
   	channel="$(echo "$scan" | grep "channel" | cut -d":" -f 2 | sed 's/ //g' | tr "," ":")"

   	echo "RSSI": $rssi, "Noise": $noise, "Channel":, $channel
	echo $rssi,$noise,$channel >> $rssi_file_name
	sleep $sampling_interval_in_sec
done

# Measure packet statistics
echo -e "\n=> Ping Statistics"
ping_count=2
ping_interval=0.5
ping_host="google.com"

# 64 bytes packets
ping_64b="$(ping -c $ping_count -i $ping_interval $ping_host)"
ping_loss="$(echo "$ping_64b" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
ping_min="$(echo "$ping_64b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
ping_avg="$(echo "$ping_64b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
ping_max="$(echo "$ping_64b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
ping_dev="$(echo "$ping_64b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"

echo "Packet Size: 64 bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min, "Average Time:" $ping_avg, \
"Max Time:" $ping_max, "mdev Time:" $ping_dev
echo "64",$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_dev >> $ping_file_name

# 1024 bytes packets
ping_1024b="$(ping -c $ping_count -i $ping_interval -s 1024 $ping_host)"
ping_loss="$(echo "$ping_1024b" | grep "loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's/ //g')"
ping_min="$(echo "$ping_1024b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f1)"
ping_avg="$(echo "$ping_1024b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f2)"
ping_max="$(echo "$ping_1024b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f3)"
ping_dev="$(echo "$ping_1024b" | grep max | cut -d "=" -f2 | sed 's/ //g' | cut -d "/" -f4 | tr -d "ms")"

echo "Packet Size: 1024 bytes, Packet Loss:" $ping_loss, "Min Time:" $ping_min, "Average Time:" $ping_avg, \
"Max Time:" $ping_max, "mdev Time:" $ping_dev
echo "1024",$ping_loss,$ping_min,$ping_avg,$ping_max,$ping_dev >> $ping_file_name
