led.bin: led.c crt0.S
	arm-linux-gnueabi-gcc -g -c -o crt0.o crt0.S
	arm-linux-gnueabi-gcc -g -c -o led.o led.c
	arm-linux-gnueabi-ld -Ttext 0x00000000 -g crt0.o led.o -o led_elf
	arm-linux-gnueabi-objcopy -O binary -S  led_elf  led.bin
	arm-linux-gnueabi-objdump -D -m arm  led_elf >  led.dis
	rm -f led_elf led.dis led.o crt0.o
clean:
	rm -f led_elf led.dis led.o crt0.o
