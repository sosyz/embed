led.bin: led.c crt0.S
	arm-linux-gnueabihf-gcc -g -c -o crt0.o crt0.S
	arm-linux-gnueabihf-gcc -g -c -o led.o led.c
	arm-linux-gnueabihf-ld -Ttext 0x00000000 -g crt0.o led.o -o led_elf
	arm-linux-gnueabihf-objcopy -O binary -S  led_elf  led.bin
	arm-linux-gnueabihf-objdump -D -m arm  led_elf >  led.dis
	rm -f led_elf led.dis led.o crt0.o
clean:
	rm -f led_elf led.dis led.o crt0.o
