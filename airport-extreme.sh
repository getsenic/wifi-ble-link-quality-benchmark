#!/bin/bash

# Description:		Benchmark Airport Extreme - MacBook Pro - MacOS 10.12.3
# Author:			Aravinth Panchadcharam

# Card Type:		AirPort Extreme  (0x14E4, 0x134)
# Firmware:			Broadcom BCM43xx 1.0 (7.21.171.68.1a5)
# MAC Address:		6c:40:08:9f:31:3

file_name="test.csv"

# Remove file, if exists
if [ -e $file_name ]; then
	rm -f $file_name
fi

ssid="$(airport -I | grep " SSID" | cut -d":" -f 2 | sed 's/ //g')"
timestamp="$(date)"

echo "===== Airport Extreme - MacBook Pro - MacOS 10.12.3 ====="
echo "=> Benchmarking RSSI and Noise"

echo "# NIC: AirPort Extreme | SSID:" $ssid "| Date:" $timestamp > $file_name 
echo "rssi,noise,channel" >> $file_name

for i in {1..5}
do	
   	rssi="$(airport -I | grep "agrCtlRSSI" | cut -d":" -f 2 | sed 's/ //g')"
   	noise="$(airport -I | grep "agrCtlNoise" | cut -d":" -f 2 | sed 's/ //g')"
   	channel="$(airport -I | grep "channel" | cut -d":" -f 2 | sed 's/ //g')"
   	echo "RSSI": $rssi, "Noise": $noise, "Channel":, $channel
	echo $rssi,$noise,$channel >> $file_name
	sleep 1
done
