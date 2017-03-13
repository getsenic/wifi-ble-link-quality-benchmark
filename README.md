# WiFi and BLE Link Quality Benchmarking

## Test Platforms
### MacBook Pro (Mid 2014)
- OS: MacOS 10.12.3
- NIC: AirPort Extreme
- Driver: bcm43xx

### [NanoPi Neo Air](http://wiki.friendlyarm.com/wiki/index.php/NanoPi_NEO_Air)
- OS: Ubuntu 16.04.1 LTS (Ubuntu Core with Qt Embedded by Friendly ARM)
- Kernel: 3.4.39-h3
- NIC: [Ampak AP6212](http://wiki.friendlyarm.com/wiki/images/5/57/AP6212_V1.1_09022014.pdf)
- Driver: bcm43438
- [Board Bringup](./docs/board-bringup.md#nanopi)

### [DragonBoard 410c](http://www.96boards.org/product/dragonboard410c)
- OS: Linaro Debian Jessie
- Kernel: 4.4.23
- NIC: [Qualcomm WCN3620](https://developer.qualcomm.com/download/sd410/wcn3620-wireless-connectivity-ic-device-revision-guide.pdf)
- Driver: wcn36xx

### [C.H.I.P Pro](https://docs.getchip.com/chip_pro.html)
- OS: Debian Builtroot
- Kernel: 
- NIC: [Realtek RTL8723DS](https://github.com/NextThingCo/RTL8723DS)
- Driver: rtl8723DS

### [Onion Omega2+](https://docs.onion.io/omega2-docs/first-time-setup.html)
- OS: OpenWrt
- Kernel: 
- NIC: []()
- Driver: 

### [BeagleBone Green Wireless](http://wiki.seeed.cc/BeagleBone_Green_Wireless)
- OS: Debian 
- Kernel: 
- NIC: [Texas Instruments (TI) WL1835MOD](http://www.ti.com/product/WL1835MOD)
- Driver: wl18xx

### [Orange Pi Zero](http://www.orangepi.org/orangepizero)
- OS: Armbian Ubuntu Jessie 
- Kernel: 3.4.113-sun8i
- NIC: [Allwinner XR819]()
- Driver: xradio

### [FreeTec Ultra-Mini Bluetooth-USB-Dongle](https://www.amazon.de/dp/B0052CJNDG)
- NIC: [Cambridge Silicon Radio (CSR) 8510 A10](http://www.csr.com/products/bluecore-csr8510-a10-wlcsp)
- Driver: btusb

### [MAXAH WLAN Dongle USB](https://www.amazon.de/Adapter-Wireless-drahtlos-802-11b-Stick-Aktionspreis/dp/B010V6WKSM)
- NIC: [MediaTek MT7601U](https://www.mediatek.com/products/broadbandWifi/mt7601u)
- Driver: mt7601u
- Maximum Current (MxPWR): 160 mA

### [TP-Link TL-WN725N Nano WLAN USB](https://www.amazon.de/TP-Link-TL-WN725N-Adapter-150Mbit-geeignet/dp/B008IFXQFU)
- NIC: [Realtek RTL8188EU](http://www.cnping.com/wp-content/uploads/2015/09/RTL8188CUS_DataSheet_1.01.pdf)
- Driver: r8188eu
- Maximum Current (MxPWR): 500 mA

### [Racksoy Professionell Wifi Dongle USB ](https://www.amazon.de/Racksoy-Professionell-Wireless-Kompatibel-Raspberry/dp/B00X538ONY)
- NIC: [Ralink (MediaTek) RT5370](https://wikidevi.com/wiki/Ralink)
- Driver: rt2800usb
- Maximum Current (MxPWR): 450 mA
- Transmit Power: 17 dBm


## Antenna Mapping
- 1 => PCB Pulse Antenna PWB 3.9 Inch - W3525B039 - [Datasheet](http://www.mouser.com/ds/2/336/-268322.pdf)
- 2 => 2.4GHz Dipole Swvl Antenna 205 mm - 0600-00057 - [Datasheet](http://www.mouser.de/ProductDetail/Laird-Technologies/0600-00057)
- 3 => PCB Pulse Antenna PWB 10 Inch - W3525B100 - [Datasheet](http://www.mouser.com/ds/2/336/-268322.pdf)
- 4 => Taoglas Ceramic Patch Antenna - WPC.25A.07.0150C - [Datasheet](http://www.mouser.com/ds/2/398/WPC.25A.07.0150C-13093.pdf)
- 5 => 2.4GHz Aristotle Antenna 150 mm RFA02-L2H1 - TRF1001 - [Datasheet](http://www.mouser.com/ds/2/268/microchip_RFA-02-L2H1-519877.pdf)
- 6 => PCB Flex Ground Coupled Antenna - FXP72.07.0053A - [Datasheet](http://www.mouser.de/ProductDetail/Taoglas/FXP72070053A)
- 7 => 2.4GHz Dipole Swvl Antenna 104 mm - 0600-00057 - [Datasheet](http://www.mouser.de/ProductDetail/Laird-Technologies/0600-00057)


## Benchmark
### NanoPi Neo Air
2.4 GHz WiFi Link Quality Benchmark on NanoPi Neo Air with Ampak AP6212 WiFi/BLE Combo Module (BCM43438). Measurements were carried out in linearly distributed spatial points with different antennas. Measurement consists of scanning RSSI and Link Quality metrics from "/proc/net/wireless" in Linux.

<p align="center">
<img src="./plot/ampak-ap6212-wifi.png"/>
</p>