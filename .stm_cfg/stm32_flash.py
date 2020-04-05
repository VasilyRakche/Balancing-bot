#!/usr/bin/env
import telnetlib
import sys

HOST = "localhost"
PORT = "4444"
cmd_list = ['reset halt', 'flash probe 0',
            'flash write_image erase %s 0x08000000' % sys.argv[1], 'reset', 'exit']

tlnt = telnetlib.Telnet(HOST, PORT)
timeout = 5
for cmd in cmd_list:
    tlnt.write(b"%s\n" % cmd)
    # wait until command is executed on device
    hello = tlnt.read_until(b"> %s" % cmd, timeout)
    print(hello)


tlnt.close()
