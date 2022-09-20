@**************************
@file name: crt0.S
@file function: 初始存储器控制器，从而可以操作SDRAM，实现SDRAM的读写功能，调用Main函数
@**************************

.equ    MEM_CTL_BASE,   0x48000000  @内存控制器基地址
.equ    SDRAM_BASE,     0x30000000  @SDRAM(BANK 6)起始地址

.text   
.global _start

_start:
    BL      disassemble_watch_dog   @关闭看门狗
    BL      mem_setup               @初始化内存控制器
    BL      cp_code_steppingstone_to_sdram @将代码从NAND FLASH拷贝到SDRAM
    LDR     PC, =on_sdram           @跳转到SDRAM中的代码

on_sdram:
    LDR     SP, =0x34000000         @在SDRAM的结尾处设置堆栈
    BL      main                    @调用main函数

malt_loop:
    B       malt_loop               @死循环

@关闭看门狗
disassemble_watch_dog:
    MOV     R1, #0x53000000
    MOV     R2, #0x00000000
    STR     R2, [R1]
    MOV     PC, LR

@拷贝steppingstone(SDRAM)中的4K代码到SDRAM中
cp_code_steppingstone_to_sdram:
    MOV     R1, #0x00000000         @将steppingstone的0地址加载到R1中，目的是从0地址开始拷贝
    LDR     R2, =SDRAM_BASE         @将SDRAM的起始地址加载到R2中，目的是从SDRAM的起始地址开始拷贝
    MOV     R3, #4096

copy_loop:
    LDR     R0, [R1], #4            @从steppingstone中读出指令
    STR     R0, [R2], #4            @将上一步拷贝出来的指令保存到SDRAM中
    CMP     R1, R3                  @比较R1和R3的值，如果R1不等于R3，跳转到copy_loop继续拷贝
    BNE     copy_loop
    MOV     PC, LR

mem_loop:
    LDR     R1, [R2], #4            @读取每个寄存器即将配置的数值
    STR     R1, [R0], #4            @将上一步读取的数值配置到相应的寄存器中
    CMP     R0, R3                  @比较R0和R3的值，如果R0不等于R3，跳转到mem_loop
    BNE     mem_loop
    MOV     PC, LR

@初始化SDRAM
mem_setup:
    MOV     R0, #MEM_CTL_BASE
    ADRL    R2, mem_cfg_val         @mem_cfg_data即将配置到存储器控制器13个特殊功能寄存器的数据首地址
    ADD     R3, R0, #52             @R3指向存储器控制器的SDRAM配置寄存器
    B       mem_loop                @调用mem_loop函数，将mem_cfg_data中的数据配置到存储器控制器的13个特殊功能寄存器中

.align 4
mem_cfg_val:
    @ 存储控制器13个寄存器的设置值
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