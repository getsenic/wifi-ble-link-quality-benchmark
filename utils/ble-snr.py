import pexpect
import time
 
DEVICE = "F9:8D:BB:F1:15:34"

print "Nuimo address: %s" % DEVICE
 
# Run gatttool interactively.
print("Run gatttool...")
child = pexpect.spawn("gatttool -b {0} -t random -I")
 
# Connect to the device.
print "Connecting to  %s" % DEVICE
child.sendline("connect")
child.expect("Connection successful", timeout=5)
print child.expect

child.sendline("char-write-req 0x002c 0100")
print(child.before)
time.sleep(5)

