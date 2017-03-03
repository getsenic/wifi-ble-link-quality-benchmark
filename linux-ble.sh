#!/bin/bash

# Description:		Ble SNR 
# Author:			Aravinth Panchadcharam

ble_scan_log="logs/ble-scan.log"
ble_notify_log="logs/ble-notify.log"

# Run lescan every time because gatttool says "No route to host", if devices are not scanned
hcitool lescan &> $ble_scan_log &


# kill $(ps aux | grep 'gatttool' | grep -v grep | awk '{print $2}')
# sleep 3



# gatttool -b F9:8D:BB:F1:15:34 -t random --char-write-req -a 0x002c -n 01 --listen &> ble-snr.log &
# sleep 3 

# res="$(cat ble-snr.log | grep "No route to host" | wc -l)"
# echo $res

# if [ $res -gt 0 ]; then
# 	echo "Device not found; lescan"
# 	
# 	sleep 5
# 	kill $(ps aux | grep 'hcitool' | grep -v grep | awk '{print $2}')
# 	sleep 3
# 	gatttool -b F9:8D:BB:F1:15:34 -t random --char-write-req -a 0x002c -n 01 --listen &> ble-snr.log &
# fi

# sleep 10
# kill $(ps aux | grep 'gatttool' | grep -v grep | awk '{print $2}') > /dev/null 2>&1
# sleep 3
# res="$(cat ble-snr.log | grep Notification | wc -l)"
# echo $res