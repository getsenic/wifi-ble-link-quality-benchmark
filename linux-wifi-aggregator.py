#!/usr/bin/env python

# Description:     Aggregate the logged RSSI from Ampak
# Author:          Aravinth Panchadcharam

import csv
import datetime as dt
import time

log_file_name = 'logs/ampak-rssi-03-01-2017'
log_file = open(log_file_name + '.csv', "rb")
reader = csv.reader(log_file)

agg_file_name = log_file_name + '-agg.csv'
agg_file = open(agg_file_name, "wb")
writer = csv.writer(agg_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONE)

# write headers to aggregated file
writer.writerow(["nic","antenna","ssid","distance","rssi","link_quality","channel","link_quality_in_percentage"])

for row in reader:

	# ignore header row
    if reader.line_num == 1:
    	pass
    	
    # first data row
    if reader.line_num == 2:
    	distance = int(row[3])
    	rssi = int(row[5])
    	link_quality = int(row[6])
    	link_quality_in_percentage = int(row[8])
    	row_count = 1

    	nic = row[0]
        antenna = int(row[1])
        ssid = row[2]
        channel = int(row[7])
    	pass

    # other data rows
    if reader.line_num > 2:
    	if distance == int(row[3]):    		
    		row_count += 1
        	rssi += int(row[5])
        	link_quality += int(row[6])
        	link_quality_in_percentage += int(row[8])
        else:        	
        	rssi_avg = rssi / row_count
        	link_quality_avg = link_quality / row_count
        	link_quality_in_percentage_avg = link_quality_in_percentage / row_count
        	print "Distance : %d, RSSI Avg: %d, Link Avg: %d, Link Percent Avg: %d, Sample Count: %d" % (distance,rssi_avg,link_quality_avg,link_quality_in_percentage_avg,row_count)
        	writer.writerow([nic,antenna,ssid,distance,rssi_avg,link_quality_avg,channel,link_quality_in_percentage_avg])
        	
        	distance = int(row[3])
	    	rssi = int(row[5])
	    	link_quality = int(row[6])
	    	link_quality_in_percentage = int(row[8])

	    	row_count = 1
        	nic = row[0]
        	antenna = int(row[1])
        	ssid = row[2]
        	channel = int(row[7])

# save last row
rssi_avg = rssi / row_count
link_quality_avg = link_quality / row_count
link_quality_in_percentage_avg = link_quality_in_percentage / row_count
print "Distance : %d, RSSI Avg: %d, Link Avg: %d, Link Percent Avg: %d, Sample Count: %d" % (distance,rssi_avg,link_quality_avg,link_quality_in_percentage_avg,row_count)
writer.writerow([nic,antenna,ssid,distance,rssi_avg,link_quality_avg,channel,link_quality_in_percentage_avg])
    
log_file.close()
agg_file.close()