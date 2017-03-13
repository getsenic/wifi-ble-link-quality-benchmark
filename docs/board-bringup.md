# Board Bringup of Test Platforms


## [NanoPi Neo Air](http://wiki.friendlyarm.com/wiki/index.php/NanoPi_NEO_Air) <div id="nanopi"/>
- OS: Ubuntu 16.04.1 LTS (Ubuntu Core with Qt Embedded by Friendly ARM)
- Kernel: 3.4.39-h3
	- Connect serial 1 (Edge of PCB)-> GND, 2 -> PWR (no need to connect), 3 -> TX of Host, 4 -> RX of Host
	- ``` screen /dev/tty.usbserial 115200 ```
	- usrname: root, password: fa
	- Attach 2.4Ghz antenna with IPX/u.FL connector to NanoPi
	- ``` vim /etc/wpa_supplicant/wpa_supplicant.conf ```
	```
		network={
		    ssid=""
		    psk=""
		}
	```
	- ``` ifup wlan0 ```
