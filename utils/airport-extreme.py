#!/usr/bin/python

# Card Type:	AirPort Extreme  (0x14E4, 0x134)
# Firmware Version:	Broadcom BCM43xx 1.0 (7.21.171.68.1a5)
# MAC Address:	6c:40:08:9f:31:3
# Supported PHY Modes:	802.11 a/b/g/n/ac

print "===== Airport Extreme on MacBook Pro - MacOS 10.12.3 ====="

import subprocess

# def run_cmd(args_list):
#     print('Running system command: {0}'.format(' '.join(args_list)))
    
#     proc = subprocess.Popen(args_list, stdout=subprocess.PIPE,
#             stderr=subprocess.PIPE)
#     (output, errors) = proc.communicate()
    
#     if proc.returncode:
#         raise RuntimeError(
#             'Error running command: %s. Return code: %d, Error: %s' % (
#                 ' '.join(args_list), proc.returncode, errors))
    
#     return (output, errors)
 
# output, errors = run_cmd(['airport', '-I', 'en0', '| grep "agrCtlRSSI"'])
# print output

ls = subprocess.Popen('airport -I en0'.split(), stdout=subprocess.PIPE)
grep = subprocess.Popen('grep RSSI'.split(), stdin=ls.stdout, stdout=subprocess.PIPE)
cut = subprocess.Popen('cut -d":" -f2'.split(), stdin=grep.stdout, stdout=subprocess.PIPE)
output = grep.communicate()[0]

print output