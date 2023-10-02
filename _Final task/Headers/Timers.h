//
// Created by Adriel on 01/10/2023.
//

#ifndef TIMERS_H
#define TIMERS_H

#include "defines.h"

void timer0(unsigned int ms);   //like an alarm
void delayMs0(unsigned int ms); //wait for the delay to end
void timer1(unsigned int ms);   //like an alarm
void delayMs1(unsigned int ms); //wait for the delay to end
void Delay5us();                //wait for the delay to end

//flags of interruption 8051
unsigned int timer0end;         //Flag TF0
unsigned int timer1end;         //Flag TF1
unsigned int moneyIsReady;      //Flag IE0

#endif
