led.bin : led.S
	arm-linux-gnueabihf-gcc -g -c -o led.o led.S
	arm-linux-gnueabihf-ld -Ttext 0x0000000 -g led.o -o led_elf
	arm-linux-gnueabihf-objcopy -O binary -S led_elf led.bin
	rm -f led_elf *.o
clean:
	rm -f led.bin led_elf *.o
