# WiFi and BLE Link Quality Benchmarking

## Test Platforms
### MacBook Pro (Mid 2014)
- OS: MacOS 10.12.3
- NIC: AirPort Extreme  (0x14E4, 0x134)
- Driver: Broadcom BCM43xx 1.0 (7.21.171.68.1a5)

### NanoPi Neo Air
- OS: Ubuntu 16.04.1 LTS (Ubuntu Core with Qt Embedded by Friendly ARM)
- Kernel: 3.4.39
- NIC: Ampak AP6212
- Driver: Broadcom BCM43438

## Antenna Mapping
- 1 => PCB Pulse Antenna PWB 3.9 Inch - W3525B039 - [Datasheet](http://www.mouser.com/ds/2/336/-268322.pdf)
- 2 => 2.4GHz Dipole Swvl Antenna 205 mm - 0600-00057 - [Datasheet](http://www.mouser.de/ProductDetail/Laird-Technologies/0600-00057)
- 3 => PCB Pulse Antenna PWB 10 Inch - W3525B100 - [Datasheet](http://www.mouser.com/ds/2/336/-268322.pdf)
- 4 => Taoglas Ceramic Patch Antenna - WPC.25A.07.0150C - [Datasheet](http://www.mouser.com/ds/2/398/WPC.25A.07.0150C-13093.pdf)
- 5 => 2.4GHz Aristotle Antenna 150 mm RFA02-L2H1 - TRF1001 - [Datasheet](http://www.mouser.com/ds/2/268/microchip_RFA-02-L2H1-519877.pdf)
- 6 => PCB Flex Ground Coupled Antenna - FXP72.07.0053A - [Datasheet](http://www.mouser.de/ProductDetail/Taoglas/FXP72070053A)
- 7 => 2.4GHz Dipole Swvl Antenna 104 mm - 0600-00057 - [Datasheet](http://www.mouser.de/ProductDetail/Laird-Technologies/0600-00057)


## Benchmark
2.4 GHz WiFi Link Quality Benchmark on NanoPi Neo Air with Ampak AP6212 WiFi/BLE Combo Module (BCM43438). Measurements were carried out in linearly distributed spatial points with different antennas. Measurement consists of scanning RSSI and Link Quality metrics from "/proc/net/wireless" in Linux.

<p align="center">
<img src="./plot/ampak-ap6212-wifi.png"/>
</p>