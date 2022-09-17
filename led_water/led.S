@******************************************************************************
@ File：led.S
@ 功能：跑马灯程序
@******************************************************************************       
            
.text
.global _start
@ 初始化, 将PortB设为输出, 并对其GPIO引脚进行初始化
_start:
    LDR     R0, =0x56000010
    MOV     R1, #0x00015400      @ 设置GPB5 6 7 8为输出口 [17:...:10]
    STR     R1, [R0]
    LDR     R0, =0x56000014      @ R0设为GPBDAT寄存器

    @ 检查LED是否有坏的
    MOV     R1, #0x00000000      @ 全部点亮
    STR     R1, [R0]
    BL      sleep
    MOV     R1, #0x000001E0      @ 全部熄灭
    STR     R1, [R0]
    BL      sleep

@ 跑马灯开始 将LED4设为亮
init:
    MOV     R1, #0x000000E0
    STR     R1, [R0]
    BL      sleep

main:
    LDR     R1, [R0]              @ 读取GPBDAT寄存器的值
    AND     R1, R1, #0x000001E0   @ 取出GPB5 6 7 8的值
    CMP     R1, #0x000001E0
    BEQ     init

    ORR     R1, R1, #0x00000200   @ 把GPBDAT[9]的值置为1
    MOV     R1, R1, LSR #6        @ 右移6位
    MOV     R1, R1, LSL #5        @ 左移5位

    STR     R1, [R0]
    BL      sleep
    B       main

sleep:
    MOV     R2, #0x00050000
_sleep:
    SUBS    R2, R2,  #1
    BNE     _sleep
    MOV     PC, LR