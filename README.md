# Balancing-bot

TODO
binary build and rest from Makefile file in stm32f103VH

/_Exploring Startup Implementations: Newlib (ARM)!!!
\_https://embeddedartistry.com/blog/2019/04/17/ \_exploring-startup-implementations-newlib-arm/
_/

To assemble the file, invoke the GNU Toolchain’s assembler as
arm-none-eabi-as -o add.o add.s

the -o option specifies the output filename

To generate the executable file, invoke the GNU Toolchain’s linker ld
arm-none-eabi-ld -Ttext=0x0 -o add.elf add.o

The -Ttext=0x0, specifies that addresses should be assigned to the labels, such that the instructions were starting from address 0x0

To view the address assignment for various labels, the nm command can be used
arm-none-eabi-nm add.elf

Run openocd command
openocd -f local/share/openocd/scripts/interface/stlink.cfg -f local/share/openocd/scripts/target/stm32f1x.cfg

in another terminal:
telnet localhost 4444
poll
reset halt
flash probe 0
flash write_image erase main.bin 0x08000000
reset
exit

arm-none-eabi-gdb main.elf
target remote :3333
quit

Useful source for debug and openocd
https://stackoverflow.com/questions/38033130/how-to-use-the-gdb-gnu-debugger-and-openocd-for-microcontroller-debugging-fr

OPENOCD

Makefile tutorial:
http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
Makefile example
https://github.com/othane/mos/blob/master/hal/stm32f107x/stm32f107x.mk

http://www.bravegnu.org/gnu-eprog/hello-arm.html
https://embdev.net/topic/129986#new
http://pandafruits.com/stm32_primer/stm32_primer_minimal.php
https://cycling-touring.net/2018/12/flashing-and-debugging-stm32-microcontrollers-under-linux

STM example
https://www.triplespark.net/elec/pdev/arm/stm32.html
https://www.triplespark.net/elec/pdev/arm/stm32.html

bash# arm-none-eabi-gcc -I. -c -fno-common -O0 -g -mcpu=cortex-m3 -mthumb main.c
bash# arm-none-eabi-ld -Tstm32.ld -nostartfiles -o main.elf main.o
bash# arm-none-eabi-objcopy -Obinary main.elf main.bin
