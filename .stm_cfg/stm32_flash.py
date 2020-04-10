#!/usr/bin/env python
# Script can be called from Makefile with 2 arguments provided:
# ./stm32_flash.py $(MAIN_OUT).bin .stm_cfg/stm32_flash.cfg
import sys
import re
import os

fin = open("%s" % sys.argv[2], "rt")
data = fin.read()
data = re.sub(r'erase .+ 0x08000000',
              'erase %s 0x08000000' % sys.argv[1], data)
fin.close()

fin = open("%s" % sys.argv[2], "wt")
fin.write(data)
fin.close()

stream = os.popen('openocd -f %s' % sys.argv[2])
output = stream.read()
print(output)
