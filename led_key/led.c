/**
 * 通过按键控制LED灯的开关
 **/

#define GPBCON (*(volatile unsigned long *)0x56000010)
#define GPBDAT (*(volatile unsigned long *)0x56000014)
#define GPFCON (*(volatile unsigned long *)0x56000050)
#define GPFDAT (*(volatile unsigned long *)0x56000054)
void sleep(unsigned long n){
    for (unsigned long i = 0; i < n; i++);
}
int main(){
    // 初始化按键
    GPFCON = 0x00000000; // 设置为输入

    // 初始化LED
    GPBCON = 0x00015400; // 设置为输出
    GPBDAT = 0x00000000; // 全点亮
    sleep(0x500000);
    GPBDAT = 0x000001E0; // 全灭

    unsigned long val;
    while(1){
        /*
        K1 EINT1 GPF1 [3:2]
        K2 EINT4 GPF4 [9:8]
        K3 EINT2 GPF2 [5:4]
        K4 EINT0 GPF0 [1:0]
        */
        val = 0x00000000;
        val |= GPFDAT & 0x02 ? 0x20  : 0b0; // K1
        val |= GPFDAT & 0x10 ? 0x40  : 0b0; // K2
        val |= GPFDAT & 0x04 ? 0x80  : 0b0; // K3
        val |= GPFDAT & 0x01 ? 0x100 : 0b0; // k4
        GPBDAT = val;
    }
    return 0;
}