# Balancing-bot
![balancing-bot](https://user-images.githubusercontent.com/30003101/141695899-f1b3e85b-0f52-4fb8-b4b8-000de7a4f00b.png)

## How to help this project (LEARN AND APPLY!):

[Write proper commit message](https://chris.beams.io/posts/git-commit/)

[Automate with Makefile](http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/)

[Get to know about OPENOCD and GDB](https://stackoverflow.com/questions/38033130/how-to-use-the-gdb-gnu-debugger-and-openocd-for-microcontroller-debugging-fr)

[Using GNU ARM Tools from Hello word in ARM to C startup](http://www.bravegnu.org/gnu-eprog/hello-arm.html)

[Try to make minimal example for STM32 work](http://pandafruits.com/stm32_primer/stm32_primer_minimal.php)

[Try more detailed example from hands on to automation with Makefile and perl](https://www.triplespark.net/elec/pdev/arm/stm32.html)

## Cheat-sheet

Assemble the file, invoke the GNU Toolchain’s assembler  
`arm-none-eabi-as -o file.o file.s`

the `-o` option specifies the output filename

Compile with gcc for STM32  
`arm-none-eabi-gcc -I. -c -fno-common -O0 -g -mcpu=cortex-m3 -mthumb file.c`

Generate the executable file, invoke the GNU Toolchain’s linker  
`arm-none-eabi-ld -Tlinker_file.ld -o file.elf file.o`

Create binary image:  
`arm-none-eabi-objcopy -Obinary file.elf file.bin`

To view the address assignment for various labels, the `nm` command can be used  
`arm-none-eabi-nm file.elf`

Run `openocd` command  
`openocd -f configuration_file.cfg`

Connect to `openocd` with terminal:  
`telnet localhost 4444`  
or with `gdb`:  
`arm-none-eabi-gdb main.elf`  
`target remote :3333`

Commands to flash file.bin

```
reset halt
#show banks
flash banks
#inspect Flash memory
flash probe 0
#write image to Flash
flash write_image erase file.bin 0x08000000
reset
shutdown
```

Useful links:  
[Get to know elf and ld scripts](https://guyonbits.com/from-rodata-to-rwdata-introduction-to-memory-mapping-and-ld-scripts/)  
[Understand the ELF](https://medium.com/@MrJamesFisher/understanding-the-elf-4bd60daac571)  
[Explore Startup Implementations for Newlib (ARM)](https://embeddedartistry.com/blog/2019/04/17/)  
[Find some useful code examples in MCD Application Team](https://blog.danman.eu/blinking-led-on-stm32f103-with-only-linux-tools/)  
[Get to know code Dissasembly with simple example](https://blogs.oracle.com/linux/hello-from-a-libc-free-world-part-1-v2)
