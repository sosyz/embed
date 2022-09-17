@*******************************************
@file name:  crt0.S
@file function:(C语言底层文件，用于将main函数设置为C程序的入口)
@*******************************************

.text
.global _start
_start:
    LDR     SP, =1024*4
    BL      main
loop:
    B       loop