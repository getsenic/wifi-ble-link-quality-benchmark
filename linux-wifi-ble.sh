#!/bin/bash

# Description:		Run WiFi and BLE benchmarking scripts together
# Author:	

./linux-wifi.sh mediatek-mt7610u 1 wlan1 0 &
./linux-ble.sh csr-8510 usb 1 0