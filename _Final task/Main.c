// ======================================= Universidade Federal de Pelotas - UFPEL
// ======================================= Centro de Desenvolvimento Tecnologico
// ======================================= Bacharelado em Engenharia de Computacao
// ======================================= Disciplina: 22000279 --- Microcontroladores
// ======================================= Turma: 2023/1 --- M1
// ======================================= Professor: Alan Rossetto
//
//										  Descricao: Trabalho Final
//
// 										  Identificao:
// 										  Nome da(o) aluna(o) & Matricula: Adriel Correa Matielo, 16105321
//                                        github.com/AdrielMatielo
// 										  Nome da(o) aluna(o) & Matricula: Ari Vitor da Silva Lazzarotto, 17200917
//										  Data: 12/09/2023
//
//=======================================
#include "Headers/Main.h"
/*
void ISR_External0(void) interrupt 0{
    //EX0 = 0;
    moneyIsReady = 1;
    return;
}
void ISR_Timer0(void) interrupt 1{
    TF0 = 0;
    TH0 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL0 = 0x18;
    timer0end = timer0end-1;
    if(!timer0end)
    TR0 = 0;
    return;
}
void ISR_Timer1(void) interrupt 3{
    TF1 = 0;
    TH1 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL1 = 0x18;
    timer1end--;
    if(!timer1end)
    TR1 = 0;
    return;
}*/

void main() {
    start:
    start();
    while(1){
        digit1 = scanKeyboard();
        //10 == '*' | 12 == '#' | 77 == void
        if((digit1 != 10) && (digit1 != 12) && (digit1 != 77)){
            if (startCode()) {
                TR0 = 0;
                TR1 = 0;
                if (giveMeTheMoney()) {
                    TR0 = 0;
                    TR1 = 0;
                    dispenseProduct();
                }
            }
            goto start;
        }
        goto start;
        //start with money
        //if (EX0) {
        //    //startMoney();
        //    goto start;
        //}
    }
}


