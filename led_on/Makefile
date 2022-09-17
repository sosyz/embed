led_on.bin : led_on2.S
	arm-linux-gnueabihf-gcc -g -c -o led_on.o led_on2.S
	arm-linux-gnueabihf-ld -Ttext 0x0000000 -g led_on.o -o led_on_elf
	arm-linux-gnueabihf-objcopy -O binary -S led_on_elf led_on.bin
clean:
	rm -f   led_on.bin led_on_elf *.o
