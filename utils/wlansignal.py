import subprocess
import time
import argparse

parser = argparse.ArgumentParser(description='Display WLAN signal strength.')
parser.add_argument(dest='interface', nargs='?', default='wlan0',
                    help='wlan interface (default: wlan0)')
args = parser.parse_args()

print '\n---Press CTRL+Z or CTRL+C to stop.---\n'

while True:
    cmd = subprocess.Popen('iwconfig %s' % args.interface, shell=True,
                           stdout=subprocess.PIPE)
    for line in cmd.stdout:
        if 'Link Quality' in line:
            print line.lstrip(' '),
        elif 'Not-Associated' in line:
            print 'No signal'
    time.sleep(1)
