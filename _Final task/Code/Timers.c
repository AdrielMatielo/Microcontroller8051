//
// Created by Adriel on 01/10/2023.
//

#include "../Headers/Timers.h"

//Wait until MICRO delay ends
void Delay5us(){
    unsigned char i;
    for(i = 0; i < 5; i++){}
}
//Wait until delay ends
void delayMs0(unsigned int ms){          //use timer0 Mode01 (16 bits)
    timer0(ms);
    while(timer0end){}
}
//Wait until delay ends
void delayMs1(unsigned int ms){          //use timer1 Mode01 (16 bits)
    timer1(ms);
    while(timer1end){}
}
//like set an alarm
void timer0(unsigned int ms){            //use timer0 Mode01 (16 bits)
    timer0end = ms;
    TH0 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL0 = 0x18;
    TF0 = 0;
    TR0 = 1;
}
//like set an alarm
void timer1(unsigned int ms){            //use timer0 Mode01 (16 bits)
    timer1end = ms;
    TH1 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL1 = 0x18;
    TR1 = 1;
    TF1 = 0;
}