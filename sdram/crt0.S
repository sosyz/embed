@**************************
@file name: crt0.S
@file function: 初始存储器控制器，从而可以操作SDRAM，实现SDRAM的读写功能，调用Main函数
@**************************

.equ    MEM_CTL_BASE,   0x48000000  @内存控制器基地址
.equ    SDRAM_BASE,     0x30000000  @SDRAM(BANK 6)起始地址

.text   
.global _start

_start:
    BL      disassemble_watch_dog
    BL      mem_setup
    BL      cp_code_steppingstone_to_sdram
    LDR     PC, =on_sdram

on_sdram:
    LDR     SP, =0x34000000
    BL      main

malt_loop:
    B       malt_loop

@关闭看门狗
disassemble_watch_dog:
    MOV     R1, #0x53000000
    MOV     R2, #0x00000000
    STR     R2, [R1]
    MOV     PC, LR

cp_code_steppingstone_to_sdram:
    MOV     R1, #0x00000000
    LDR     R2, =SDRAM_BASE
    MOV     R3, #4096
    LDR     R4, =0x00000000

copy_loop:
    LDR     R0, [R1], #4
    ADD     R4, R4,   #4
    STR     R0, [R2], #4
    CMP     R4, R3
    BNE     copy_loop
    MOV     PC, LR

mem_setup:
    MOV     R2, #MEM_CTL_BASE
    ADRL    R1, mem_cfg_val
    ADD     R3, R2, #0x34
    MOV     R4, #MEM_CTL_BASE
    B       copy_loop

.align 4
mem_cfg_val:
    .long   0x22011110      @ BWSCON
    .long   0x00000700      @ BANKCON0
    .long   0x00000700      @ BANKCON1
    .long   0x00000700      @ BANKCON2
    .long   0x00000700      @ BANKCON3  
    .long   0x00000700      @ BANKCON4
    .long   0x00000700      @ BANKCON5
    .long   0x00018005      @ BANKCON6
    .long   0x00018005      @ BANKCON7
    .long   0x008C07A3      @ REFRESH
    .long   0x000000B1      @ BANKSIZE
    .long   0x00000030      @ MRSRB6
    .long   0x00000030      @ MRSRB7