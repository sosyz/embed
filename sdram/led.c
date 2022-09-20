/**
 * 流水灯
 **/

#define GPBCON (*(volatile unsigned long *)0x56000010)
#define GPBDAT (*(volatile unsigned long *)0x56000014)

#define GPB5_OUT (1<<(5*2))
#define GPB6_OUT (1<<(6*2))
#define GPB7_OUT (1<<(7*2))
#define GPB8_OUT (1<<(8*2))

#define GPB5_OFF (1<<5)
#define GPB6_OFF (1<<6)
#define GPB7_OFF (1<<7)
#define GPB8_OFF (1<<8)

#define DELAY 100000

void sleep(unsigned long n){
    for (; n > 0; n--);
}

int main(){
    // 初始化LED
    GPBCON = GPB5_OUT | GPB6_OUT | GPB7_OUT | GPB8_OUT; // 设置为输出
    GPBDAT = ~(GPB5_OFF | GPB6_OFF | GPB7_OFF | GPB8_OFF); // 全点亮

    sleep(DELAY);
    GPBDAT = GPB5_OFF | GPB6_OFF | GPB7_OFF | GPB8_OFF; // 全灭

    unsigned long val;
    while(1){
        val = GPBDAT;
        val |= (1<<9); // GPB9置1
        val >>= 1; // 右移一位
        if (!(
            (val & (GPB5_OFF | GPB6_OFF | GPB7_OFF | GPB8_OFF))
            ^ (GPB5_OFF | GPB6_OFF | GPB7_OFF | GPB8_OFF)
        )) // 如果全灭点亮GPB8
            val = ~GPB8_OFF;

        GPBDAT = val;
        sleep(DELAY);
    }
    return 0;
}