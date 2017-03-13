#!/bin/bash

# Description:		Stress/Temperature Benchmarking in Linux
# Author:			Aravinth Panchadcharam

# sudo apt-get install stress

if [ $# -lt 3 ]; then	
	echo "./linux-stress-temp.sh board-name is-heat-sink-attached no-of-stressed-cpu-cores"
else
	board_name=$1
	heat_sink=$2
	stressed_cpu_cores=$3	

	measurement_interval=1
	date_str="$(date +"%m-%d-%Y")"	
	temp_log="logs/"$board_name"-temp-"$date_str".csv"	

	echo -e "\n=> Temperature Benchmarking of" $board_name "by stressing CPU cores" $stressed_cpu_cores

	# If logs directory doesn't exists, then create it
	if [ ! -d "logs" ];then
		echo -e "\nCreating logging directory"
		mkdir "logs"
	fi

	# If file doesn't exists, then add comments and headers to CSV files
	if [ ! -e $temp_log ]; then
		echo "Creating log file" $temp_log		
		echo "board_name,thermal_zones,heat_sink,stressed_cpu_cores,temperature,timestamp" > $temp_log
	fi

	# Start stress
	echo -e "\nGenerating CPU load"
	stress --cpu $stressed_cpu_cores &

	# Measure temperature
	echo -e "\nMesuring Temperature"
	no_of_thermal_zones="$(ls /sys/class/thermal | grep thermal_zone | wc -l)"

	while :
	do
		timestamp="$(date +"%s")"	
		temp0="$(cat /sys/class/thermal/thermal_zone0/temp)"
		temp1="$(cat /sys/class/thermal/thermal_zone1/temp)"

		echo "Thermal Zone 0 :" $temp0 "Thermal Zone 1 :" $temp1
		echo $board_name,$no_of_thermal_zones,$heat_sink,$stressed_cpu_cores,$temp0:$temp1,$timestamp >> $temp_log

		sleep $measurement_interval
	done
fi

